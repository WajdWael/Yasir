//import Foundation
//import SwiftUI
//
//class SummaryViewModel: ObservableObject {
//    @Published var generatedSummaries: [GeneratedSummary] = []
//    @Published var isSummaryGeneratedForDocument: [String: Bool] = [:]
//    
//    
//    init() {
//        loadSummaries()
//    }
//
//    // MARK: - Summary Handling
//    func saveSummary(_ summary: GeneratedSummary) {
//        //generatedSummaries.append(summary)
//        saveToUserDefaults(generatedSummaries, key: "generatedSummaries")
//    }
//    
//    // Add a new summary
//        func addSummary(_ summary: GeneratedSummary) {
//            generatedSummaries.append(summary)
//            isSummaryGeneratedForDocument[summary.documentName] = true
//        }
//
////
////    func deleteSummary(_ summary: GeneratedSummary) {
////        // Remove from the list
////        if let index = generatedSummaries.firstIndex(where: { $0.id == summary.id }) {
////            generatedSummaries.remove(at: index)
////        }
////
////        
////    }
//
//    // Delete a summary
//        func deleteSummary(at offsets: IndexSet, for documentName: String) {
//            generatedSummaries.remove(atOffsets: offsets)
//            if generatedSummaries.filter({ $0.documentName == documentName }).isEmpty {
//                isSummaryGeneratedForDocument[documentName] = false
//            }
//            
//            saveToUserDefaults(generatedSummaries, key: "generatedSummaries")
//        }
//    
//    
//    // Check if a summary has been generated for a document
//        func isSummaryGenerated(for documentName: String) -> Bool {
//            return isSummaryGeneratedForDocument[documentName] ?? false
//        }
//    private func loadSummaries() {
//        generatedSummaries = loadFromUserDefaults(key: "generatedSummaries") ?? []
//    }
//
//    // MARK: - UserDefaults Storage Helpers
//    private func saveToUserDefaults<T: Codable>(_ data: T, key: String) {
//        if let encoded = try? JSONEncoder().encode(data) {
//            UserDefaults.standard.set(encoded, forKey: key)
//        }
//    }
//
//    private func loadFromUserDefaults<T: Codable>(key: String) -> T? {
//        if let savedData = UserDefaults.standard.data(forKey: key),
//           let decoded = try? JSONDecoder().decode(T.self, from: savedData) {
//            return decoded
//        }
//        return nil
//    }
//}
//
//
import Foundation
import SwiftUI


class SummaryViewModel: ObservableObject {
    @Published var generatedSummaries: [GeneratedSummary] = []
    @Published var isSummaryGeneratedForDocument: [String: Bool] = [:]
    
    init() {
        loadSummaries()
        loadSummaryStatus()
    }

    // Add a new summary
    func addSummary(_ summary: GeneratedSummary) {
        generatedSummaries.append(summary)
        isSummaryGeneratedForDocument[summary.documentName] = true
        saveSummaryStatus()
        saveToUserDefaults(generatedSummaries, key: "generatedSummaries")
    }

    // Delete a summary
    func deleteSummary(at offsets: IndexSet, for documentName: String) {
        generatedSummaries.remove(atOffsets: offsets)
        if generatedSummaries.filter({ $0.documentName == documentName }).isEmpty {
            isSummaryGeneratedForDocument[documentName] = false
            saveSummaryStatus()
        }
        saveToUserDefaults(generatedSummaries, key: "generatedSummaries")
    }

    // Check if a summary has been generated for a document
    func isSummaryGenerated(for documentName: String) -> Bool {
        return isSummaryGeneratedForDocument[documentName] ?? false
    }

    private func loadSummaries() {
        generatedSummaries = loadFromUserDefaults(key: "generatedSummaries") ?? []
    }

    // Save and Load Summary Status
    private func saveSummaryStatus() {
        if let encoded = try? JSONEncoder().encode(isSummaryGeneratedForDocument) {
            UserDefaults.standard.set(encoded, forKey: "summaryStatus")
        }
    }

    private func loadSummaryStatus() {
        if let savedData = UserDefaults.standard.data(forKey: "summaryStatus"),
           let decoded = try? JSONDecoder().decode([String: Bool].self, from: savedData) {
            isSummaryGeneratedForDocument = decoded
        }
    }

    // UserDefaults Storage Helpers
    private func saveToUserDefaults<T: Codable>(_ data: T, key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadFromUserDefaults<T: Codable>(key: String) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(T.self, from: savedData) {
            return decoded
        }
        return nil
    }
}
