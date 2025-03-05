//
//  Exam view.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 04/09/1446 AH.
//

import SwiftUI

struct ExamView: View {
    let questions: [Question]
    
    var body: some View {
        List(questions) { question in
            VStack(alignment: .leading) {
                Text(question.question)
                    .font(.headline)
                
                ForEach(question.allAnswers, id: \.self) { answer in
                    Text("• \(answer)")
                        .padding(.leading, 10)
                }
            }
            .padding()
        }
        .navigationTitle("Generated Exam")
    }
}
