//
//  QuestionCardView.swift
//  Yasir
//
//  Created by Whyyy on 06/03/2025.
//

import SwiftUI

struct QuestionCardView: View {
    let question: Question
    @ObservedObject var viewModel: ExamViewModel
    let interactive: Bool
    private let cardWidth: CGFloat = 370
    private let cardHeight: CGFloat = 570
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if interactive {
                skipButton
            }
            
            QuestionView(
                question: question.question,
                answers: viewModel.stableAnswers[question.id] ?? [],
                correctAnswer: question.correctAnswer,
                selectedAnswerIndex: Binding(
                    get: { viewModel.selectedAnswers[question.id] },
                    set: { newValue in
                        if newValue != nil {
                            viewModel.selectAnswer(for: question.id, index: newValue!)
                        }
                    }
                )
            )
            
            if interactive {
                nextButton
            }
        }
        .padding()
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private var skipButton: some View {
        HStack {
            Spacer()
            Button(action: viewModel.skipQuestion) {
                Text("Skip >")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.vertical, 8)
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private var nextButton: some View {
        HStack {
            Spacer()
            Button("Next") {
                if viewModel.selectedAnswers[question.id] != nil {
                    viewModel.animateAndAdvance()
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 8)
            .background(viewModel.selectedAnswers[question.id] != nil ? Color.teal : Color.gray)
            .cornerRadius(12)
            .disabled(viewModel.selectedAnswers[question.id] == nil)
            .foregroundColor(.white)
        }
    }
}
