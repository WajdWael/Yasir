import SwiftUI
struct PodcastView: View {
    @StateObject private var viewModel: PodcastViewModel

    init(document: Document) {
        self._viewModel = StateObject(wrappedValue: PodcastViewModel(document: document))
    }

    var body: some View {
        VStack(spacing: 20) {
            // Display the script only when the audio is ready to play
            if viewModel.finalAudioURL != nil && !viewModel.generatedPodcast.isEmpty {
                ScrollView {
                    Text(viewModel.generatedPodcast)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
            } else {
                // Show "Generating Podcast..." when the audio is being prepared
                ScrollView {
                    ProgressView("Generating Podcast...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                        .padding(.top, 170)
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }

            // Progress Slider
            Slider(value: $viewModel.progress, in: 0...1, onEditingChanged: { editing in
                if !editing {
                    viewModel.seek(to: viewModel.progress)
                }
            })
            .tint(.teal)
            .padding(.horizontal)

            // Time Labels
            HStack {
                Text(viewModel.currentTime)
                    .font(.caption)
                Spacer()
                Text(viewModel.remainingTime)
                    .font(.caption)
            }
            .padding(.horizontal)

            // Playback Speed Button
            Button(action: viewModel.changePlaybackRate) {
                Text("\(String(format: "%.1fx", viewModel.playbackRate))")
                    .font(.headline)
                    .foregroundColor(.teal)
                    .cornerRadius(10)
            }

            // Skip Buttons
            HStack {
                Button(action: { viewModel.skipBackward(seconds: 10) }) {
                    Image(systemName: "gobackward.10")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.teal)
                }

                Spacer()

                // Play/Pause Button
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.teal)
                }

                Spacer()

                Button(action: { viewModel.skipForward(seconds: 10) }) {
                    Image(systemName: "goforward.10")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.teal)
                }
            }
            .padding(.horizontal)

            // Volume Slider
            HStack {
                Image(systemName: "speaker.fill")
                Slider(value: $viewModel.volume, in: 0...1)
                    .tint(.teal)
                Image(systemName: "speaker.wave.3.fill")
            }
            .padding(.horizontal)
            .foregroundStyle(.teal)

            // Error Message
            if viewModel.showError, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Podcast")
        .onAppear {
            // Automatically generate the podcast when the view appears
            if let text = viewModel.document.extractedText {
                viewModel.generateAndPlayPodcast(text: text)
            } else {
                viewModel.errorMessage = "No text found in the document."
                viewModel.showError = true
            }
        }
        .onDisappear {
            // Pause audio when the view disappears
            viewModel.pauseAudio()
        }
    }
}
