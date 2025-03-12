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

struct UploadedFilesView: View {
    
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

            Image(systemName: "doc.fill.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(Color(UIColor.systemGray2))
            
            // Upload Text
            Text("Upload files to get started.")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.top, 8)

             Spacer()
         
        }
        .background(Color(UIColor.systemGray6))
    }
}



