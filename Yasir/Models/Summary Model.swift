//
//  Summary Model.swift
//  Yasir
//
//  Created by Alaa Emad Alhamzi on 12/09/1446 AH.
//

import Foundation

struct GeneratedSummary: Identifiable, Codable {
    let id = UUID()
    let documentName: String
    let summaryText: String
    let date: Date
}
