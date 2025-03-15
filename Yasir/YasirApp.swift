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

/*
import SwiftUI
import SwiftData

@main
struct YasirApp: App {
    @StateObject private var examHistory = ExamHistory()
    
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
                    .environmentObject(examHistory)
            }
            .modelContainer(sharedModelContainer) // Attach the container
        }
}
*/

import SwiftUI
import SwiftData

@main
struct YasirApp: App {
    @StateObject private var examHistory = ExamHistory()
    @StateObject private var summaryViewModel = SummaryViewModel()
  //  @StateObject private var podcastViewModel = PodcastViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var isSplashActive = true
    
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: Document.self) // Ensure `Document` is registered
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSplashActive = false
                        }
                    }
            } else {
                if hasSeenOnboarding {
                    FilesView(modelContext: sharedModelContainer.mainContext)
                        .environmentObject(examHistory)
                        .environmentObject(summaryViewModel)
                    //    .environmentObject(podcastViewModel)
                } else {
                    OnBoardingView()
                }
            }
        }
        .modelContainer(sharedModelContainer) // Attach the container
    }
}

