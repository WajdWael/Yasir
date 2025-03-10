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
    
    // MARK: - Computed Properties for History Tracking
    var correctAnswersCount: Int {
        questions.reduce(0) { count, question in
            // Remove 'correctAnswer' from the guard (it's non-optional)
            guard let selectedIndex = selectedAnswers[question.id],
                  let selectedAnswer = stableAnswers[question.id]?[selectedIndex] else {
                return count
            }
            // Directly access non-optional correctAnswer
            let correctAnswer = question.correctAnswer
            return count + (selectedAnswer == correctAnswer ? 1 : 0)
        }
    }
    
    var totalQuestions: Int {
        questions.count
    }
    
    // MARK: - Navigation Methods
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
