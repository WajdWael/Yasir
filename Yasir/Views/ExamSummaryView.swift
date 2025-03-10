//
//  ExamSummaryView.swift
//  Yasir
//
//  Created by Whyyy on 06/03/2025.
//

import SwiftUI

struct ExamSummaryView: View {
    let documentName: String // Added property
    @StateObject private var viewModel: ExamSummaryViewModel
    @EnvironmentObject private var examHistory: ExamHistory // Added
        
    init(documentName: String, questions: [Question], stableAnswers: [UUID: [String]], selectedAnswers: [UUID: Int]) {
        self.documentName = documentName
        _viewModel = StateObject(
            wrappedValue: ExamSummaryViewModel(
                questions: questions,
                stableAnswers: stableAnswers,
                selectedAnswers: selectedAnswers
            )
        )
    }
    
    var body: some View {
        ZStack {
            // Full-screen background that ignores safe area
            Color.teal.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    ForEach(viewModel.questions) { question in
                        questionCard(for: question)
                    }
                }
                .padding(.top, 20)
            }
            .background(Color.teal.ignoresSafeArea())
            // If you want to remove or style the top bar (iOS 16+):
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.teal, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Exam Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Score: \(viewModel.correctAnswersCount)/\(viewModel.totalQuestions)")
                .font(.title2)
                .foregroundColor(.white)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Question Card
    private func questionCard(for question: Question) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.question)
                .font(.headline)
                .foregroundColor(.teal)
                .padding(.bottom, 8)
            
            answersSection(for: question)
            
            // If user skipped this question
            if viewModel.selectedAnswers[question.id] == nil {
                skippedIndicator
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
    
    // MARK: - Answers Section
    private func answersSection(for question: Question) -> some View {
        Group {
            if let answers = viewModel.stableAnswers[question.id] {
                ForEach(Array(answers.enumerated()), id: \.offset) { index, answer in
                    HStack {
                        Text(answer)
                            .foregroundColor(viewModel.answerColor(for: answer, question: question))
                        
                        Spacer()
                        
                        if viewModel.isSelectedAnswer(index, question: question) {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.teal)
                                .font(.system(size: 12))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.backgroundForAnswer(answer, question: question))
                    )
                }
            }
        }
    }
    
    // MARK: - Skipped Indicator
    private var skippedIndicator: some View {
        HStack {
            Spacer()
            Text("Skipped")
                .foregroundColor(.red)
                .padding(8)
                .background(Capsule().stroke(Color.red, lineWidth: 1))
            Spacer()
        }
        .padding(.top, 8)
    }
}


struct ExamSummaryView_Previews: PreviewProvider {
    // Sample data for previewing the view.
    static var sampleQuestions: [Question] = [
        Question(
            question: "What is a 'zero-day attack'?",

            correctAnswer: "An attack that takes place before the security community or software developer becomes aware of and repairs a vulnerability",
            
            incorrectAnswers: [
                "An attack that causes zero damage",
                "An attack that uses zero lines of code",
                "An attack that occurs only on the first day of each month"
            ]
        ),
        Question(
            question: "What is a disaster recovery plan?",
            correctAnswer: "A documented, structured approach that describes how an organization can quickly resume work after an unplanned incident",
            
            incorrectAnswers: [
                "A plan to cause a disaster",
                "A plan to do nothing after a disaster",
                "None of the above"
            ]
        )
    ]
    
    // Mapping each question's UUID to its list of answers.
    static var sampleStableAnswers: [UUID: [String]] = {
        Dictionary(uniqueKeysWithValues: sampleQuestions.map { question in
            (question.id, question.allAnswers)
        })
    }()
    
    // Example: user selected the 3rd answer for the first question, and the 1st answer for the second question.
    static var sampleSelectedAnswers: [UUID: Int] = [
        sampleQuestions[0].id: 2,
        sampleQuestions[1].id: 1
    ]
    
    // The preview shows the ExamSummaryView in both light and dark modes.
    static var previews: some View {
            ExamSummaryView(
                documentName: "Sample Document", // Add this line
                questions: sampleQuestions,
                stableAnswers: sampleStableAnswers,
                selectedAnswers: sampleSelectedAnswers
            )
            .preferredColorScheme(.dark)
        }
}
