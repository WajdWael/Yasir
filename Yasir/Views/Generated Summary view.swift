//
//  Generated Summary view.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 12/09/1446 AH.
//

//import SwiftUI
//
//struct GeneratedServicesView: View {
//    @StateObject var viewModel = GeneratedSummaryViewModel()
//    var selectedFileName: String
//
//    var body: some View {
//        List {
//            Section(header: Text("Generated Summaries")) {
//                ForEach(viewModel.generatedSummaries.filter { $0.documentName == selectedFileName }) { summary in
//                    VStack(alignment: .leading) {
//                        Text("Summary for \(summary.documentName)")
//                            .font(.headline)
//                        Text(summary.summaryText.prefix(50) + "...")
//                            .foregroundColor(.gray)
//                        Text("Date: \(formatDate(summary.date))")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//        }
//        .navigationTitle("Generated Summaries")
//    }
//
//    func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//}
