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
import SwiftUI

struct ServicesView: View {
    let fileName: String // The selected file name
    @State private var generatedServices: [String] = [] // Stores the generated services
    
    var body: some View {
        ZStack {
            // Background color matching iOS system background
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // File name header
                Text(fileName)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                Spacer()
                
                // Create Service Section
                Text("Create one of these services:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                
                // Service buttons
                HStack {
                    ServiceButton(title: "Exam", icon: "doc.text") {
                        addService("Exam - \(fileName)")
                    }
                    ServiceButton(title: "Podcast", icon: "mic") {
                        addService("Podcast - \(fileName)")
                    }
                }
                ServiceButton(title: "Summary", icon: "clipboard.text") {
                    addService("Summary - \(fileName)")
                }
                .padding(.top, 5)
                
                Spacer()
                
                // Previous Actions Section
                Text("Previous actions:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                if generatedServices.isEmpty {
                    // White background placeholder box
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        
                        .frame(height: 300)
                        .overlay(
                            Text("Create content to get started.")
                                .foregroundColor(.gray)
                                .font(.callout)
                        )
                        .padding(.vertical, 10)
                } else {
                    // List of generated services
                    List(generatedServices, id: \.self) { service in
                        HStack {
                            Image(systemName: "doc.fill") // File icon
                                .foregroundColor(.teal)
                            Text(service)
                        }
                        .padding(8)
                    }
                    .listStyle(PlainListStyle()) // Removes default list styling
                    .frame(height: 300) // Control list height
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // Function to add a generated service
    private func addService(_ service: String) {
        generatedServices.append(service)
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
        }
    }
}

// Preview
struct ServicesSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView(fileName: "MeetingNotes.pdf")
    }
}
