import SwiftUI

struct SummaryView: View {
    let summary: String
    @Environment(\.dismiss) var dismiss
    @ObservedObject var document : Document
    
    var body: some View {
        
        ZStack{
            Color(.systemTeal)
                .ignoresSafeArea()
            
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding()
        }
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


// MARK: - Preview
struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        // Create sample data for the preview
        let samplePDFData = Data() // Placeholder data for pdfData
        let sampleDocument = Document(name: "Sample Document", pdfData: samplePDFData)
        
        return NavigationView {
            SummaryView(summary: "This is a summary of the document.", document: sampleDocument)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper preview layout
    }
}

// MARK: - Document Model
class Documents: ObservableObject {
    let name: String
    let pdfData: Data // Required property
    
    init(name: String, pdfData: Data) {
        self.name = name
        self.pdfData = pdfData
    }
}
