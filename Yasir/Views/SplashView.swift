import SwiftUI
import RiveRuntime

//struct SplashView: View {
//    var body: some View {
//        ZStack {
//            Color.teal.edgesIgnoringSafeArea(.all)
//            Text("My App")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//        }
//    }
//}
//#Preview {
//    SplashView()
//}
struct Splash_Screen: View {
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
