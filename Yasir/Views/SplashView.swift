import SwiftUI
import RiveRuntime

struct SplashView: View {
    @State private var riveViewModel = RiveViewModel(fileName: "walk_demo-9") // No need for animation name

    var body: some View {
        ZStack {
            Color(.teal).ignoresSafeArea(edges: .all)
            VStack {
                Image("logo")
                    riveViewModel.view()
                    .frame(width: 300, height: 300)
            }
        }
    }
}
