import SwiftData
import PDFKit
import UniformTypeIdentifiers

class DocumentViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var extractedText: String = "Extracting text..."
    @Published var errorMessage: String?
    @Published var isDocumentPickerPresented = false

    let geminiService = GeminiService()
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchDocuments()
    }

    // Fetch all documents from SwiftData
    func fetchDocuments() {
        let descriptor = FetchDescriptor<Document>()
        do {
            documents = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to fetch documents: \(error.localizedDescription)"
        }
    }

//    // Upload a PDF file
//    func uploadPDF(from url: URL) {
//        do {
//            let pdfData = try Data(contentsOf: url)
//            let document = Document(name: url.lastPathComponent, pdfData: pdfData)
//            modelContext.insert(document)
//            fetchDocuments() // Refresh the list
//            print("PDF saved to SwiftData!")
//        } catch {
//            errorMessage = "Failed to upload PDF: \(error.localizedDescription)"
//        }
//    }
    
    
    func uploadPDF(from url: URL) {
            do {
                let data = try Data(contentsOf: url)
                let extractedText = extractText(from: data)
                
                let newDocument = Document(name: url.lastPathComponent, pdfData: data, extractedText: extractedText)
                modelContext.insert(newDocument)
                fetchDocuments() // Refresh the list
                print("PDF saved to SwiftData!")
                // Save document to SwiftData
                //documents.append(newDocument)
            } catch {
                print("Failed to load PDF data: \(error)")
            }
        }
        
    
    
//    func uploadPDF(from url: URL) {
//            do {
//                let data = try Data(contentsOf: url)
//                let extractedText = extractText(from: data)
//                
//                let newDocument = Document(name: url.lastPathComponent, pdfData: data, extractedText: extractedText)
//                
//                // Save document to SwiftData
//                documents.append(newDocument)
//            } catch {
//                print("Failed to load PDF data: \(error)")
//            }
//        }
        

//    // Extract text from PDF data
//    func extractText(from data: Data) {
//        guard let pdfDocument = PDFDocument(data: data) else {
//            errorMessage = "Failed to load PDF document."
//            return
//        }
//
//        var text = ""
//        for pageNumber in 0..<pdfDocument.pageCount {
//            if let page = pdfDocument.page(at: pageNumber), let pageText = page.string {
//                text += pageText + "\n\n"
//            }
//        }
//
//        extractedText = text.isEmpty ? "No text found in PDF." : text
//    }
    
    // Extract text from PDF
    private func extractText(from pdfData: Data) -> String? {
        guard let document = PDFDocument(data: pdfData) else { return nil }
        var extractedText = ""
        
        for pageIndex in 0..<document.pageCount {
            if let page = document.page(at: pageIndex), let text = page.string {
                extractedText += text + "\n"
            }
        }
        
        return extractedText.isEmpty ? nil : extractedText
    }
    
    
    func deleteDocument(_ document: Document){
        
        modelContext.delete(document)   //Remove the document from SwiftData
        fetchDocuments()   // Refresh the list after deletion.
    }
}
