import SwiftUI

struct QuestionView: View {
    let question: String
    let answers: [String]
    let correctAnswer: String
    @Binding var selectedAnswerIndex: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            ForEach(answers.indices, id: \.self) { index in
                Button(action: { selectedAnswerIndex = index }) {
                    HStack {
                        Text(answers[index])
                            .foregroundColor(.black)
                        Spacer()
                        
//                        if let selectedIndex = selectedAnswerIndex, selectedIndex == index {
//                            if answers[index] == correctAnswer {
//                                Image(systemName: "checkmark.circle.fill")
//                                    .foregroundColor(.green)
//                            } else {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.red)
//                            }
//                        }
                    }
                    .padding()
                    .background(backgroundColor(for: index))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func backgroundColor(for index: Int) -> Color {
        guard let selectedIndex = selectedAnswerIndex else { return Color.white }
        
        if selectedIndex == index {
            return answers[index] == correctAnswer ?
                Color.green.opacity(0.2) : Color.red.opacity(0.2)
        } else if selectedIndex != index && answers[index] == correctAnswer && answers[selectedIndex] != correctAnswer {
            return Color.green.opacity(0.2)
        }
        return Color.white
    }
}
