//
//  Question.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 04/09/1446 AH.
//

import Foundation

// Model for Questions
struct Question: Identifiable, Codable {
    let id = UUID()
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    var allAnswers: [String] {
        ([correctAnswer] + incorrectAnswers).shuffled()
    }
}
