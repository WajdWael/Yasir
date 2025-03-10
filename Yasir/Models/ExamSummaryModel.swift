//
//  ExamSummary.swift
//  Yasir
//
//  Created by Whyyy on 09/03/2025.
//

import Foundation

struct ExamSummary: Identifiable, Codable { // Add Codable
    let id = UUID()
    var examNumber: Int // Keep as var for modification
    let documentName: String
    let questions: [Question]
    let stableAnswers: [UUID: [String]]
    let selectedAnswers: [UUID: Int]
    let correctAnswersCount: Int
    let totalQuestions: Int
    let date: Date
}
