//
//  Services view.swift
//  CarPlay App
//
//  Created by Alaa Emad Alhamzi on 04/09/1446 AH.
//

//import SwiftUI
//
//struct ServicesView: View {
//    let fileName: String // The selected file name
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            // File name header
//            Text(fileName)
//                .font(.largeTitle)
//                .bold()
//                .padding(.top, 20)
//                
//            Spacer()
//            Text("Create one of this service:")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top, 5)
//                
//            // Service buttons
//            HStack {
//                ServiceButton(title: "Exam", icon: "doc.text") {}
//                ServiceButton(title: "Podcast", icon: "mic") {}
//            }
//            ServiceButton(title: "Summary", icon: "clipboard.text") {}
//                .padding(.top, 5)
//            Spacer()
//            // Previous actions section
//            Text("Previous actions:")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top, 20)
//                
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                .frame(height: 300)
//                .overlay(Text("Create content to get started").foregroundColor(.gray))
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//// Custom button component
//struct ServiceButton: View {
//    let title: String
//    let icon: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: icon)
//                Text(title)
//                    .bold()
//            }
//            .frame(width: 160, height: 50)
//            .background(Color.teal)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//    }
//}
//
//struct ServicesSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesView(fileName: "MeetingNotes.pdf")
//    }
//}
//import SwiftUI
//
//struct ServicesView: View {
//    let fileName: String // The selected file name
//    @State private var generatedServices: [String] = [] // Stores the generated services
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            // File name header
//            Text(fileName)
//                .font(.largeTitle)
//                .bold()
//                .padding(.top, 20)
//            
//            Spacer()
//            
//            // Create Service Section
//            Text("Create one of these services:")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top, 5)
//            
//            // Service buttons
//            HStack {
//                ServiceButton(title: "Exam", icon: "doc.text") {
//                    addService("Exam - \(fileName)")
//                }
//                ServiceButton(title: "Podcast", icon: "mic") {
//                    addService("Podcast - \(fileName)")
//                }
//            }
//            ServiceButton(title: "Summary", icon: "clipboard.text") {
//                addService("Summary - \(fileName)")
//            }
//            .padding(.top, 5)
//            
//            Spacer()
//            
//            // Previous Actions Section
//            Text("Previous actions:")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.top, 20)
//            
//            if generatedServices.isEmpty {
//                // Placeholder box when no services exist
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.gray.opacity(0.1)) // Light gray background
//                    .frame(height: 300)
//                    .overlay(
//                        Text("Create content to get started.")
//                            .foregroundColor(.gray)
//                            .font(.callout)
//                    )
//                    .padding(.vertical, 10)
//            } else {
//                // List of generated services
//                List(generatedServices, id: \.self) { service in
//                    HStack {
//                        Image(systemName: "doc.fill") // File icon
//                            .foregroundColor(.teal)
//                        Text(service)
//                    }
//                    .padding(8)
//                }
//                .listStyle(PlainListStyle()) // Removes default list styling
//                .frame(height: 300) // Control list height
//            }
//            
//            Spacer()
//        }
//        .padding()
//    }
//    
//    // Function to add a generated service
//    private func addService(_ service: String) {
//        generatedServices.append(service)
//    }
//}
//
//// Custom button component
//struct ServiceButton: View {
//    let title: String
//    let icon: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: icon)
//                Text(title)
//                    .bold()
//            }
//            .frame(width: 160, height: 50)
//            .background(Color.teal)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//    }
//}
//
//// Preview
//struct ServicesSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesView(fileName: "MeetingNotes.pdf")
//    }
//}
//




//import SwiftUI
//
//struct ServicesView: View {
//    let fileName: String // The selected file name
//    @State private var generatedServices: [String] = [] // Stores the generated services
//    
//    var body: some View {
//        ZStack {
//            // Background color matching iOS system background
//            Color(.systemGroupedBackground)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack(alignment: .leading) {
//                // File name header
//                Text(fileName)
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top, 20)
//                
//                Spacer()
//                
//                // Create Service Section
//                Text("Create one of these services:")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.top, 5)
//                
//                // Service buttons
//                HStack {
//                    ServiceButton(title: "Exam", icon: "doc.text") {
//                        addService("Exam - \(fileName)")
//                    }
//                    ServiceButton(title: "Podcast", icon: "mic") {
//                        addService("Podcast - \(fileName)")
//                    }
//                }
//                ServiceButton(title: "Summary", icon: "clipboard.text") {
//                    addService("Summary - \(fileName)")
//                }
//                .padding(.top, 5)
//                
//                Spacer()
//                
//                // Previous Actions Section
//                Text("Previous actions:")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.top, 20)
//                
//                if generatedServices.isEmpty {
//                    // White background placeholder box
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.white)
//                        
//                        .frame(height: 300)
//                        .overlay(
//                            Text("Create content to get started.")
//                                .foregroundColor(.gray)
//                                .font(.callout)
//                        )
//                        .padding(.vertical, 10)
//                } else {
//                    // List of generated services
//                    List(generatedServices, id: \.self) { service in
//                        HStack {
//                            Image(systemName: "doc.fill") // File icon
//                                .foregroundColor(.teal)
//                            Text(service)
//                        }
//                        .padding(8)
//                    }
//                    .listStyle(PlainListStyle()) // Removes default list styling
//                    .frame(height: 300) // Control list height
//                    .cornerRadius(10)
//                }
//                
//                Spacer()
//            }
//            .padding()
//        }
//    }
//    
//    // Function to add a generated service
//    private func addService(_ service: String) {
//        generatedServices.append(service)
//    }
//}
//
//// Custom button component
//struct ServiceButton: View {
//    let title: String
//    let icon: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: icon)
//                Text(title)
//                    .bold()
//            }
//            .frame(width: 160, height: 50)
//            .background(Color.teal)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//    }
//}
//
//// Preview
//struct ServicesSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesView(fileName: "MeetingNotes.pdf")
//    }
//}



//import SwiftUI
//
//struct ServicesView: View {
//    let document: Document
//    @State private var isGenerating = false
//    @State private var navigateToExam = false
//    @State private var generatedExam: String = ""
//    
//    let geminiService = GeminiService()
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text(document.name)
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top, 20)
//                
//                Spacer()
//                
//                Text("Create one of these services:")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                
//                // Buttons for AI Services
//                HStack {
//                    ServiceButton(title: "Exam", icon: "doc.text") {
//                        startExamGeneration()
//                    }
//                    ServiceButton(title: "Podcast", icon: "mic") {
//                        // Placeholder for future podcast feature
//                    }
//                }
//                ServiceButton(title: "Summary", icon: "clipboard.text") {
//                    // Placeholder for future summary feature
//                }
//                
//                Spacer()
//                
//                // Show loading view while generating
//                if isGenerating {
//                    ProgressView("Generating Exam...")
//                }
//                
//                NavigationLink(destination: ExamView(questions: parseExam(generatedExam)), isActive: $navigateToExam) {
//                    EmptyView()
//                }
//            }
//            .padding()
//        }
//    }
//    
//    // Function to start generating an exam
//    private func startExamGeneration() {
//        guard let text = document.extractedText else {
//            print("No text found in document.")
//            return
//        }
//        
//        isGenerating = true
//        
//        Task {
//            do {
//                let result = try await geminiService.processText(content: text, type: .questions)
//                
//                DispatchQueue.main.async {
//                    generatedExam = result
//                    isGenerating = false
//                    navigateToExam = true
//                }
//            } catch {
//                print("Error generating exam: \(error.localizedDescription)")
//                isGenerating = false
//            }
//        }
//    }
//    
//    // Parse JSON response into questions array
//    private func parseExam(_ jsonString: String) -> [Question] {
//        
//        
//        guard let data = jsonString.data(using: .utf8) else { return [] }
//        
//        do {
//            
//           
//            
//            let questions = try JSONDecoder().decode([Question].self, from: data)
//            return questions
//        } catch {
//            print("Error parsing JSON: \(error.localizedDescription)")
//            return []
//        }
//    }
//}
//
//// Custom button component
//struct ServiceButton: View {
//    let title: String
//    let icon: String
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: icon)
//                Text(title)
//                    .bold()
//            }
//            .frame(width: 160, height: 50)
//            .background(Color.teal)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//    }
//}
//
//// Preview
////struct ServicesSelectionView_Previews: PreviewProvider {
////    static var previews: some View {
////        ServicesView(document: document)
////    }
////}


import SwiftUI

struct ServicesView: View {
    let document: Document
    @State private var isGenerating = false
    @State private var navigateToExam = false
    @State private var navigateToSummary = false
    @State private var generatedExam: String = ""
    @State private var generatedSummary: String = ""  // Added summary state
    @State private var errorMessage: String?
    
    let geminiService = GeminiService()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(document.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                Spacer()
                
                Text("Create one of these services:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                // Buttons for AI Services
                HStack {
                    ServiceButton(title: "Exam", icon: "doc.text") {
                        startExamGeneration()
                    }
                    ServiceButton(title: "Podcast", icon: "mic") {
                        // Placeholder for future podcast feature
                        print("Podcast feature coming soon!")
                    }
                }
                ServiceButton(title: "Summary", icon: "clipboard.text") {
                    startSummaryGeneration()  // Start generating summary when clicked
                }
                
                Spacer()
                
                // Show loading view while generating
                if isGenerating {
                    ProgressView("Generating...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 20)
                }
                
                // Show error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // Show the generated summary if available
                if !generatedSummary.isEmpty {
                    NavigationLink(destination: SummaryView(summary: generatedSummary)) {
                        Text("Go to Summary")
                        .font(.headline)
                         .foregroundColor(.teal)
                         .padding(.top, 20)
              }
                                    
                }
                
                NavigationLink(destination: ExamView(questions: parseExam(generatedExam)), isActive: $navigateToExam) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    // Function to start generating an exam
    private func startExamGeneration() {
        guard let text = document.extractedText else {
            print("No text found in document.")
            errorMessage = "No text found in document."
            return
        }
        
        isGenerating = true
        errorMessage = nil // Reset error message
        
        Task {
            do {
                let result = try await geminiService.processText(content: text, type: .questions)
                
                DispatchQueue.main.async {
                    generatedExam = result
                    isGenerating = false
                    navigateToExam = true
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error generating exam: \(error.localizedDescription)")
                    errorMessage = "Error generating exam. Please try again."
                    isGenerating = false
                }
            }
        }
    }
    
    // Function to start generating the summary
    private func startSummaryGeneration() {
        guard let text = document.extractedText else {
            print("No text found in document.")
            errorMessage = "No text found in document."
            return
        }
        
        isGenerating = true
        errorMessage = nil // Reset error message
        
        Task {
            do {
                let result = try await geminiService.processText(content: text, type: .summary)
                
                DispatchQueue.main.async {
                    generatedSummary = result
                    isGenerating = false
                    navigateToSummary = true
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error generating summary: \(error.localizedDescription)")
                    errorMessage = "Error generating summary. Please try again."
                    isGenerating = false
                }
            }
        }
    }
    
    // Parse JSON response into questions array
    private func parseExam(_ jsonString: String) -> [Question] {
        guard let data = jsonString.data(using: .utf8) else {
            print("Error: Invalid JSON string.")
            errorMessage = "Invalid response format."
            return []
        }
        
        do {
            let questions = try JSONDecoder().decode([Question].self, from: data)
            return questions
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
            errorMessage = "Error parsing exam. Please check the response format."
            return []
        }
    }
}

// Custom button component
struct ServiceButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .bold()
            }
            .frame(width: 160, height: 50)
            .background(Color.teal)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.vertical, 5)
        }
    }
}

//// Preview
//struct ServicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesView(document: Document(name: "Sample Document", extractedText: "This is a sample text for summary generation"))
//    }
//}
