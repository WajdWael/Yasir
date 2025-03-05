//
//  Test Gemini API.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 04/09/1446 AH.
//

import SwiftUI

struct Test: View {
    @State private var result: String = "Press the button to test"
    let service = GeminiService()
    
    var body: some View {
        VStack {
            Text(result)
                .padding()

            Button("Test Gemini API") {
                Task {
                    do {
//                        let text = "The Earth revolves around the Sun, completing one orbit in approximately 365 days."
                        let text = "That sounds like a great feature! Let's break it down step by step. Since you haven't integrated the AI code yet, I'll guide you on how to structure your app first and then later we can work on the AI integration."
                        let output = try await service.processText(content: text, type: .questions)
                        DispatchQueue.main.async {
                            result = output
                        }
                    } catch {
                        result = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    Test()
}
