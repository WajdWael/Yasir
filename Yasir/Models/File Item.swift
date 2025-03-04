//
//  File Item.swift
////  CarPlay App
////
////  Created by Alaa Emad Alhamzi on 03/09/1446 AH.
////
//
//import Foundation
//import SwiftData
//
//@Model
//class Document {
//    var name: String
//    var pdfData: Data
//
//    init(name: String, pdfData: Data) {
//        self.name = name
//        self.pdfData = pdfData
//    }
//}


import Foundation
import SwiftData

@Model
class Document {
    var name: String
    var pdfData: Data

    init(name: String, pdfData: Data) {
        self.name = name
        self.pdfData = pdfData
    }
}
