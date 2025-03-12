import SwiftUI

struct OnBoardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentIndex = 0

    let onboardingData: [(title: String, subtitle: String, icon: String)] = [
        ("Podcast", "Create an audio podcast \n from any written file you \n have", "airpods.max"),
        ("Summary", "Transform a long file into a useful summary", "list.clipboard"),
        ("Exam", "Transform a long file into a useful Exam", "text.document")
    ]

    
    
    var body: some View {
        ZStack{
            // ### ICONS ###
            ZStack {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    let icon = onboardingData[currentIndex].icon
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.white.opacity(0.3))
                        .position(
                            x: UIScreen.main.bounds.width * (
                                index == 0 ? 0.90 : index == 1 ? 0.80 : 0.90
                            ),
                            y: UIScreen.main.bounds.height * (
                                index == 0 ? 0.33 : index == 1 ? 0.47 : 0.60
                            )
                        )
                }
            }
            
            VStack {
                // ### SKIP BUTTON ###
                HStack {
                    Spacer()
                    
                    // ### SKIP BUTTON ###
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        HStack(spacing: 4) {
                            Text("Skip")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }

                }

                // ### SWIPING VIEWS ###
                TabView(selection: $currentIndex) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        VStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(onboardingData[index].title)
                                    .font(.system(size: 64))
                                    .foregroundStyle(.white)
                                    .fontWeight(.heavy)
                                    .fontDesign(.rounded)
                                    .opacity(0.2)
                                    .padding(.bottom, -10)
                                    .kerning(3)

                                Text(onboardingData[index].title)
                                    .font(.system(size: 64))
                                    .foregroundStyle(.white)
                                    .fontWeight(.heavy)
                                    .fontDesign(.rounded)
                                    .opacity(0.5)
                                    .padding(.bottom, -10)
                                    .kerning(3)

                                Text(onboardingData[index].title)
                                    .font(.system(size: 64))
                                    .foregroundStyle(.white)
                                    .fontWeight(.heavy)
                                    .fontDesign(.rounded)
                                    .padding(.bottom, -10)
                                    .kerning(3)

                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack{
                                VStack{
                                    Text(onboardingData[index].subtitle)
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .fontDesign(.rounded)
                                        .fontWeight(.semibold)
                                        .padding()
                                }
                                .padding(.top, 40)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                // ### COUNTINUE BUTTON ###
                Text("Continue")
                    .font(.title3)
                    .foregroundColor(.teal)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.white)
                    .cornerRadius(10)
                    .bold()
                    .padding()
                    .onTapGesture {
                        if currentIndex < onboardingData.count - 1 {
                            currentIndex += 1
                        } else {
                            hasSeenOnboarding = true
                        }
                    }
            }

        }
        .background(Color.teal.edgesIgnoringSafeArea(.all))
     }
}


#Preview {
    OnBoardingView()
}

