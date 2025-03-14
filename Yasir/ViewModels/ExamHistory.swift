//
//  ExamHistory.swift
//  Yasir
//
//  Created by Whyyy on 09/03/2025.
//

import SwiftUI

class ExamHistory: ObservableObject {
    @Published var pastExams: [ExamSummary] = [] {
        didSet {
            saveToFile()
        }
    }
    
    private let fileURL: URL
    
    init() {
        // Get documents directory URL
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        fileURL = paths[0].appendingPathComponent("exam_history.json")
        loadFromFile()
    }
    
    func addExam(_ exam: ExamSummary) {
        // Filter exams for the current document
        let documentExams = pastExams.filter { $0.documentName == exam.documentName }
        
        // Assign the next exam number for this document
        var newExam = exam
        newExam.examNumber = documentExams.count + 1
        
        // Add the updated exam to the history
        pastExams.append(newExam)
    }
    
    func removeExams(at offsets: IndexSet) {
        pastExams.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence Methods
    private func saveToFile() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(pastExams)
            try data.write(to: fileURL)
        } catch {
            print("Error saving exams: \(error)")
        }
    }
    
    private func loadFromFile() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            pastExams = try decoder.decode([ExamSummary].self, from: data)
        } catch {
            print("Error loading exams or no saved data: \(error)")
        }
    }
}
