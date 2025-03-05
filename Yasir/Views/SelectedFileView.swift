//import SwiftUI
//
//struct SelectedFileView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}
//
//#Preview {
//    SelectedFileView()
//}
import SwiftUI
import SwiftData

struct FilesView: View {
    @StateObject private var viewModel: DocumentViewModel
    @State private var searchText: String = ""
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: DocumentViewModel(modelContext: modelContext))
    }
    
    var filteredFiles: [Document] {
        if searchText.isEmpty {
            return viewModel.documents
        } else {
            return viewModel.documents.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.documents.isEmpty {
                    ContentView(viewModel:viewModel) // Show empty state if no files exist
                } else {
                    VStack {
                        // Title and filter icon
                        HStack {
                            Text("Files")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                print("Filter tapped") // Future sorting feature
                            }) {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            Button(action: {
                                print("Voice search tapped")
                            }) {
                                Image(systemName: "mic")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // File List
                        List{
                            ForEach(filteredFiles) {document in
                                
                                NavigationLink(destination:
                                                ServicesView(document: document))/*DocumentDetailView(document: document, viewModel: viewModel))*/ {
                                    HStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.teal)
                                            .frame(width: 40, height: 40)
                                        
                                        VStack(alignment: .leading) {
                                            Text(document.name)
                                                .font(.headline)
                                        }
    //
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .onDelete{ IndexSet in
                                for index in IndexSet{
                                    let documentToDelete = filteredFiles[index]
                                    viewModel.deleteDocument(documentToDelete)
                                }
                            }
                        }
                        
                      
                        
                    }
                }
                
                // Floating "+" Button for Upload
                VStack {
                    Spacer()
                    
                        
                        Button(action: {
                            viewModel.isDocumentPickerPresented = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.teal)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    
                }
            }
            .sheet(isPresented: $viewModel.isDocumentPickerPresented) {
                DocumentPicker { url in
                    viewModel.uploadPDF(from: url)
                }
            }
        }
    }
}


