import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.teal.edgesIgnoringSafeArea(.all)
            Text("My App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
#Preview {
    SplashView()
}
