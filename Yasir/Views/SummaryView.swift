//import SwiftUI
//
//struct SummaryView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    SummaryView()
//}


import SwiftUI

struct SummaryView: View {
    let summary: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            ScrollView {
                Text(summary)
                    .padding()
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
       
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    SummaryView(summary: "This is a sample summary of the document. It should contain a brief and concise description of the content.")
}
