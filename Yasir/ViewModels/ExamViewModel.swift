import SwiftUI

class ExamViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswers: [UUID: Int] = [:]
    @Published var swipeOffset: CGFloat = 0
    
    let questions: [Question]
    let stableAnswers: [UUID: [String]]
    private let cardWidth: CGFloat = 370
    
    init(questions: [Question]) {
        self.questions = questions
        var computedStableAnswers: [UUID: [String]] = [:]
        for question in questions {
            computedStableAnswers[question.id] = question.allAnswers
        }
        self.stableAnswers = computedStableAnswers
    }
    
    var progressValue: Double {
        Double(currentQuestionIndex + 1)
    }
    
    var progressTotal: Double {
        Double(questions.count)
    }
    
    func nextQuestion() {
        currentQuestionIndex = min(currentQuestionIndex + 1, questions.count)
    }
    
    func skipQuestion() {
        animateAndAdvance()
    }
    
    func selectAnswer(for questionID: UUID, index: Int) {
        selectedAnswers[questionID] = index
    }
    
    func animateAndAdvance() {
        withAnimation(.easeInOut(duration: 0.5)) {
            swipeOffset = -cardWidth
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.none) {
                self.nextQuestion()
                self.swipeOffset = 0
            }
        }
    }
}
