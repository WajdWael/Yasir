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
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(summary: "This is a sample summary of the document. It should contain a brief and concise description of the content.")
    }
}
