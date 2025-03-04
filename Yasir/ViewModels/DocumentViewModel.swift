import SwiftData
import PDFKit
import UniformTypeIdentifiers

class DocumentViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var extractedText: String = "Extracting text..."
    @Published var errorMessage: String?
    @Published var isDocumentPickerPresented = false

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

    // Upload a PDF file
    func uploadPDF(from url: URL) {
        do {
            let pdfData = try Data(contentsOf: url)
            let document = Document(name: url.lastPathComponent, pdfData: pdfData)
            modelContext.insert(document)
            fetchDocuments() // Refresh the list
            print("PDF saved to SwiftData!")
        } catch {
            errorMessage = "Failed to upload PDF: \(error.localizedDescription)"
        }
    }

    // Extract text from PDF data
    func extractText(from data: Data) {
        guard let pdfDocument = PDFDocument(data: data) else {
            errorMessage = "Failed to load PDF document."
            return
        }

        var text = ""
        for pageNumber in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageNumber), let pageText = page.string {
                text += pageText + "\n\n"
            }
        }

        extractedText = text.isEmpty ? "No text found in PDF." : text
    }
    
    func deleteDocument(_ document: Document){
        
        modelContext.delete(document)   //Remove the document from SwiftData
        fetchDocuments()   // Refresh the list after deletion.
    }
}
