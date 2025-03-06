//
//  Question.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 04/09/1446 AH.
//

import Foundation

import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    // Combine incorrect answers with the correct one and optionally shuffle.
    var allAnswers: [String] {
         var answers = incorrectAnswers + [correctAnswer]
         answers.shuffle() // Optional: shuffle to mix the order
         return answers
    }
    
    // Custom keys that match the JSON structure
    private enum CodingKeys: String, CodingKey {
        case question, correctAnswer, incorrectAnswers
    }
    
    // Custom initializer to generate an ID if it's not provided in the JSON.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.question = try container.decode(String.self, forKey: .question)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        // Generate a new id since it's not provided in JSON.
        self.id = UUID()
    }
    
    // Default initializer for creating Question instances manually.
    init(id: UUID = UUID(), question: String, correctAnswer: String, incorrectAnswers: [String]) {
         self.id = id
         self.question = question
         self.correctAnswer = correctAnswer
         self.incorrectAnswers = incorrectAnswers
    }
}
