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
//<<<<<<< Updated upstream
    @Environment(\.dismiss) var dismiss

//=======
    @ObservedObject var document : Document
    
//>>>>>>> Stashed changes
    var body: some View {
        
        ZStack{
            Color(.systemTeal).ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 10){
                
                Text(document.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                Text("Summary:")
                    .font(.callout)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                VStack{
                ScrollView {
                    
                   
                        Text(summary)
                            .padding()
                            .foregroundColor(.black)
                    }
                    
                .frame(width: 356.38, height: 542)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.top, 5)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                   // .padding()
                    .padding(.horizontal)
                
                Spacer()
            }
            
            .padding(.horizontal)
            .padding()
        }
//<<<<<<< Updated upstream
       
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

//#Preview {
//    SummaryView(summary: "This is a sample summary of the document. It should contain a brief and concise description of the content.")
//}
//=======}


//struct SummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        SummaryView(summary: "This is a sample summary of the document. It should contain a brief and concise description of the content.")
//    }
//}
//>>>>>>> Stashed changes
