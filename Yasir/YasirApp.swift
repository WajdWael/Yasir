//import SwiftUI
//
//@main
//struct YasirApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
import SwiftUI
import SwiftData

@main
struct YasirApp: App {
    var sharedModelContainer: ModelContainer = {
            do {
                return try ModelContainer(for: Document.self) // Ensure `Document` is registered
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }()
        
        var body: some Scene {
            WindowGroup {
                FilesView(modelContext: sharedModelContainer.mainContext) // Pass modelContext
            }
            .modelContainer(sharedModelContainer) // Attach the container
        }
}
