//import SwiftUI
//
//struct UploadedFilesView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}
//
//#Preview {
//    UploadedFilesView()
//}
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: DocumentViewModel
    
    var body: some View {
        VStack {
            // Title
            HStack {
                Text("Files")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
            
            // Logo Placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 150, height: 100)
                .overlay(
                    Text("Logo")
                        .foregroundColor(.gray)
                        .font(.headline)
                )

            // Upload Text
            Text("Upload files to get started")
                .foregroundColor(.gray)
                .padding(.top, 8)

             Spacer()
         
        } .background(Color.gray.opacity(0.2))

    }
    }



