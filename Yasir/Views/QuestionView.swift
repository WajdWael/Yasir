import SwiftUI

struct QuestionView: View {
    let question: String
    let answers: [String]
    let correctAnswer: String
    @Binding var selectedAnswerIndex: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .lineLimit(nil)
            
            ForEach(answers.indices, id: \.self) { index in
                Button(action: {
                    if selectedAnswerIndex == nil {
                        selectedAnswerIndex = index
                    }
                }) {
                    HStack {
                        Text(answers[index])
                            .foregroundColor(.black)
                            .lineLimit(nil) // Allow unlimited lines
                            .fixedSize(horizontal: false, vertical: true) // Enable vertical growth
                            .multilineTextAlignment(.leading) // Force leading alignment
                            .layoutPriority(1)
                        Spacer()
                        if selectedAnswerIndex == index {
                            Image(systemName: "circle.fill")
                                .foregroundColor(iconColor(for: answers[index]))
                        }
                        
                    }
                    .padding()
                    .background(background(for: answers[index], at: index))
                    .cornerRadius(8)
                }
                .disabled(selectedAnswerIndex != nil)
            }
        }
    }
    
    private func iconColor(for answer: String) -> Color {
        answer == correctAnswer ? .green : .red
    }
    
    private func background(for answer: String, at index: Int) -> Color {
        if selectedAnswerIndex != nil {
            if answer == correctAnswer {
                return Color.green.opacity(0.1)
            }
            if selectedAnswerIndex == index && answer != correctAnswer {
                return Color.red.opacity(0.1)
            }
        }
        return Color.clear
    }
}
