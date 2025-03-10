//
//  ExamSummaryViewModel.swift
//  Yasir
//
//  Created by Whyyy on 06/03/2025.
//


import SwiftUI

class ExamSummaryViewModel: ObservableObject {
    let questions: [Question]
    let stableAnswers: [UUID: [String]]
    let selectedAnswers: [UUID: Int]
    
    var totalQuestions: Int {
        questions.count
    }
    
    var correctAnswersCount: Int {
        questions.reduce(0) { count, question in
            guard let selectedIndex = selectedAnswers[question.id],
                  let selectedAnswer = stableAnswers[question.id]?[selectedIndex] else {
                return count
            }
            // Directly use non-optional correctAnswer
            let correctAnswer = question.correctAnswer
            return count + (selectedAnswer == correctAnswer ? 1 : 0)
        }
    }
    
    init(questions: [Question], stableAnswers: [UUID: [String]], selectedAnswers: [UUID: Int]) {
        self.questions = questions
        self.stableAnswers = stableAnswers
        self.selectedAnswers = selectedAnswers
    }
    
    // Determines text color for a given answer
    func answerColor(for answer: String, question: Question) -> Color {
        answer == question.correctAnswer ? .green : .black
    }
    
    // Checks whether the user selected this particular answer index
    func isSelectedAnswer(_ index: Int, question: Question) -> Bool {
        selectedAnswers[question.id] == index
    }
    
    // Determines the background color for a given answer
    func backgroundForAnswer(_ answer: String, question: Question) -> Color {
        if answer == question.correctAnswer {
            return Color.green.opacity(0.1)
        } else if isWrongSelection(answer, question: question) {
            return Color.red.opacity(0.1)
        }
        return Color.clear
    }
    
    // Checks whether the user selected this answer and it is incorrect
    func isWrongSelection(_ answer: String, question: Question) -> Bool {
        guard let selectedIndex = selectedAnswers[question.id],
              let answers = stableAnswers[question.id]
        else { return false }
        
        return answer == answers[selectedIndex] && answer != question.correctAnswer
    }
    
    
}
