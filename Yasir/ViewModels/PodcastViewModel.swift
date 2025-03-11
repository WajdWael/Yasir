
import Foundation
import AVFoundation

class PodcastViewModel: ObservableObject {
    @Published var generatedPodcast: String = ""
    @Published var isLoading: Bool = false
    @Published var isPlaying: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    @Published var volume: Float = 1.0 {
        didSet {
            audioPlayer?.volume = volume // Update volume when the slider changes
        }
    }
    @Published var playbackRate: Float = 1.0
    @Published var progress: Double = 0.0 // Progress slider value (0.0 to 1.0)
    @Published var currentTime: String = "00:00" // Current playback time
    @Published var duration: String = "00:00" // Total duration of the audio

    var document: Document

    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer? // Timer to update progress and time labels
    private let geminiService = GeminiService()
    private let googleTTSService = GoogleTTSService()

    init(document: Document) {
        self.document = document
    }

    // MARK: - Audio Controls

    // Play/Pause functionality
    func togglePlayPause() {
        if isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }

    // Skip forward by 10 seconds
    func skipForward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        player.currentTime = min(player.currentTime + seconds, player.duration)
        updateProgress()
    }

    // Skip backward by 10 seconds
    func skipBackward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        player.currentTime = max(player.currentTime - seconds, 0)
        updateProgress()
    }

    // Change playback speed
    func changePlaybackRate() {
        guard let player = audioPlayer else { return }
        switch playbackRate {
        case 0.5:
            playbackRate = 1.0
        case 1.0:
            playbackRate = 1.5
        case 1.5:
            playbackRate = 2.0
        case 2.0:
            playbackRate = 0.5
        default:
            playbackRate = 1.0
        }
        player.rate = playbackRate
    }

    // Seek to a specific time in the audio
    func seek(to progress: Double) {
        guard let player = audioPlayer else { return }
        player.currentTime = progress * player.duration
        updateProgress()
    }

    // Update progress and time labels
    private func updateProgress() {
        guard let player = audioPlayer else { return }
        progress = player.currentTime / player.duration
        currentTime = formatTime(player.currentTime)
        duration = formatTime(player.duration)
    }

    // Format time (e.g., 125.0 -> "02:05")
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Start a timer to update progress and time labels
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateProgress()
        }
    }

    // Stop the timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Existing Functions

    func generateAndPlayPodcast(text: String) {
        isLoading = true
        showError = false
        errorMessage = nil

        Task {
            do {
                let podcastScript = try await geminiService.processText(content: text, type: .podcast)
                DispatchQueue.main.async {
                    self.generatedPodcast = podcastScript
                }

                self.googleTTSService.synthesizeSpeech(text: podcastScript) { fileURL in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let fileURL = fileURL {
                            self.playAudio(from: fileURL)
                        } else {
                            self.errorMessage = "Failed to generate audio."
                            self.showError = true
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Failed to generate podcast: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }

    func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.enableRate = true
            audioPlayer?.rate = playbackRate
            audioPlayer?.play()
            isPlaying = true
            startTimer() // Start the timer to update progress
        } catch {
            errorMessage = "Failed to play audio: \(error.localizedDescription)"
            showError = true
        }
    }

    func playAudio() {
        audioPlayer?.play()
        isPlaying = true
        startTimer() // Start the timer to update progress
    }

    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer() // Stop the timer when paused
    }
}

