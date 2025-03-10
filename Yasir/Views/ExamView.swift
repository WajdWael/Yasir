//
//  Exam view.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 04/09/1446 AH.
//

import SwiftUI

struct ExamView: View {
    let documentName: String
        @StateObject private var viewModel: ExamViewModel
        @EnvironmentObject private var examHistory: ExamHistory
        
        init(documentName: String, questions: [Question]) {
            self.documentName = documentName
            _viewModel = StateObject(wrappedValue: ExamViewModel(questions: questions))
        }
        
        var body: some View {
            VStack(spacing: 20) {
                if viewModel.currentQuestionIndex < viewModel.questions.count {
                    progressSection
                    cardStack
                } else {
                    ExamSummaryView(
                        documentName: documentName,
                        questions: viewModel.questions,
                        stableAnswers: viewModel.stableAnswers,
                        selectedAnswers: viewModel.selectedAnswers
                    )
                    .onAppear {
                        guard !viewModel.questions.isEmpty else { return }
                        
                        let summary = ExamSummary(
                            examNumber: 0,
                            documentName: documentName,
                            questions: viewModel.questions,
                            stableAnswers: viewModel.stableAnswers,
                            selectedAnswers: viewModel.selectedAnswers,
                            correctAnswersCount: viewModel.correctAnswersCount,
                            totalQuestions: viewModel.totalQuestions,
                            date: Date()
                        )
                        examHistory.addExam(summary)
                    }
                }
                Spacer()
            }
            .background(Color.teal.ignoresSafeArea())
        }
    
    private var progressSection: some View {
        VStack(spacing: 10) {
            ProgressView(
                value: viewModel.progressValue,
                total: viewModel.progressTotal
            )
            .tint(.white)
            .padding(.horizontal)
            
            HStack {
                Text("\(viewModel.currentQuestionIndex + 1)/\(viewModel.questions.count)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    private var cardStack: some View {
        ZStack {
            if viewModel.currentQuestionIndex + 1 < viewModel.questions.count {
                cardView(for: viewModel.questions[viewModel.currentQuestionIndex + 1], interactive: false)
                    .stackedCard(at: 1)
            }
            
            cardView(for: viewModel.questions[viewModel.currentQuestionIndex], interactive: true)
                .offset(x: viewModel.swipeOffset)
        }
        .frame(width: 370, height: 570)
    }
    
    private func cardView(for question: Question, interactive: Bool) -> some View {
        QuestionCardView(
            question: question,
            viewModel: viewModel,
            interactive: interactive
        )
    }
}

extension View {
    func stackedCard(at position: Int) -> some View {
        self.offset(y: CGFloat(position) * 10)
    }
}




struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView(
            documentName: "Sample Document", // Add this line
            questions: [
                Question(
                    question: "Which of the following is an example of a valid logical statement?",
                    correctAnswer: "If it is raining, then the ground is wet.",
                    incorrectAnswers: [
                        "A cat is an animal, and animals can fly.",
                        "The sun is made of water, so it is cold.",
                        "If I study, I will pass, but if I don't study, I will also pass."
                    ]
                ),
                Question(
                    question: "What is 2 + 2?",
                    correctAnswer: "4",
                    incorrectAnswers: ["1", "2", "3"]
                )
            ]
        )
    }
}
