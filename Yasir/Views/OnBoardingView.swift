import SwiftUI

struct OnBoardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentIndex = 0

    let onboardingData: [(title: String, subtitle: String)] = [
        ("Podcast", "Create an audio podcast from any written file you have"),
        ("Summary", "Transform a long file into a useful summary"),
        ("Exam", "Transform a long file into a useful summary")
    ]

    var body: some View {
        VStack {
            // Skip Button (Navigates to Main App)
            HStack {
                Spacer()
                Button("Skip >") {
                    hasSeenOnboarding = true
                }
                .padding()
                .foregroundColor(.white)
            }

            // Swiping Pages
            TabView(selection: $currentIndex) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    VStack {
                        Text(onboardingData[index].title)
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                        
                        Text(onboardingData[index].subtitle)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fontDesign(.rounded)
                            .padding(.horizontal, 40)
                            .fontDesign(.rounded)

                        Spacer()

                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            // Continue Button
            Button("Continue") {
                if currentIndex < onboardingData.count - 1 {
                    currentIndex += 1
                } else {
                    hasSeenOnboarding = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .foregroundStyle(.teal)
            .padding(.horizontal)
        }
        .background(Color.teal.edgesIgnoringSafeArea(.all))
     }
}


#Preview {
    OnBoardingView()
}

