import Foundation
import AVFoundation
import Combine

class PodcastViewModel: ObservableObject {
    @Published var generatedPodcast: String = ""
    @Published var isLoading: Bool = false
    @Published var isPlaying: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    @Published var volume: Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    @Published var playbackRate: Float = 1.0
    @Published var progress: Double = 0.0
    @Published var currentTime: String = "00:00"
    @Published var remainingTime: String = "00:00"
    @Published var duration: String = "00:00"

    var document: Document

    private var player: AVPlayer?
    private var timeObserver: Any?
    @Published var finalAudioURL: URL?
    private var cancellables = Set<AnyCancellable>()
    private let geminiService = GeminiService()
    private let googleTTSService = GoogleTTSService()

    init(document: Document) {
        self.document = document
    }

    // MARK: - Audio Controls

    private func initializePlayer() {
        guard let finalAudioURL = finalAudioURL else {
            print("Final audio URL is nil!")
            return
        }
        
        // Initialize the player only if it hasn't been initialized yet
        if player == nil {
            player = AVPlayer(url: finalAudioURL)
            player?.volume = volume
            player?.rate = playbackRate
            startTimeObserver()
            print("Player initialized successfully with new podcast at \(finalAudioURL)")
        }
    }

    private func resetPlayer() {
        stopTimeObserver()
        player?.pause()
        player = nil
        print("Player reset successfully")
    }

    func playAudio() {
        initializePlayer() // Ensure the player is initialized
        player?.play()
        isPlaying = true
        print("Player started playing at time: \(player?.currentTime().seconds ?? 0)")
    }

    func togglePlayPause() {
        guard let player = player else {
            print("Player is nil!")
            return
        }
        if isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    func skipForward(seconds: TimeInterval = 10) {
        guard let player = player else { return }
        let newTime = CMTimeAdd(player.currentTime(), CMTime(seconds: seconds, preferredTimescale: 1))
        player.seek(to: newTime)
        updateProgress()
    }

    func skipBackward(seconds: TimeInterval = 10) {
        guard let player = player else { return }
        let newTime = CMTimeSubtract(player.currentTime(), CMTime(seconds: seconds, preferredTimescale: 1))
        player.seek(to: newTime)
        updateProgress()
    }

    func changePlaybackRate() {
        guard let player = player else { return }
        switch playbackRate {
        case 0.5: playbackRate = 1.0
        case 1.0: playbackRate = 1.5
        case 1.5: playbackRate = 2.0
        case 2.0: playbackRate = 0.5
        default: playbackRate = 1.0
        }
        player.rate = playbackRate
    }

    func seek(to progress: Double) {
        guard let player = player else { return }
        let duration = player.currentItem?.duration.seconds ?? 0
        let newTime = CMTime(seconds: progress * duration, preferredTimescale: 1)
        player.seek(to: newTime)
        updateProgress()
    }

    private func updateProgress() {
        guard let player = player, let currentItem = player.currentItem else { return }
        let currentTime = player.currentTime().seconds
        let duration = currentItem.duration.seconds
        progress = currentTime / duration
        self.currentTime = formatTime(currentTime)
        self.duration = formatTime(duration)
        
        // Calculate remaining time
        let remaining = duration - currentTime
        self.remainingTime = formatTime(remaining)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        guard !time.isNaN && !time.isInfinite else { return "00:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.updateProgress()
        }
    }

    // MARK: - Podcast Generation

    private func splitScriptIntoChunks(_ script: String, maxChunkSize: Int = 4000) -> [String] {
        var chunks: [String] = []
        var currentChunk = ""

        for sentence in script.split(separator: ".") {
            let sentenceWithDot = sentence + "."
            
            if currentChunk.count + sentenceWithDot.count > maxChunkSize {
                chunks.append(currentChunk.trimmingCharacters(in: .whitespaces))
                print("Chunk added: \(currentChunk.prefix(20))...")
                currentChunk = String(sentenceWithDot)
            } else {
                currentChunk += " " + sentenceWithDot
            }
        }

        if !currentChunk.isEmpty {
            chunks.append(currentChunk.trimmingCharacters(in: .whitespaces))
            print("Final chunk added: \(currentChunk.prefix(20))...")
        }

        return chunks
    }
    
    private func verifyAudioFile(at url: URL) -> Bool {
        let asset = AVURLAsset(url: url)
        let duration = CMTimeGetSeconds(asset.duration)
        print("Audio file duration: \(duration) seconds")
        return duration > 0
    }

    func generateAndPlayPodcast(text: String) {
        isLoading = true
        showError = false
        errorMessage = nil

        resetPlayer()

        Task {
            do {
                let fullScript = try await geminiService.processText(content: text, type: .podcast)
                DispatchQueue.main.async { self.generatedPodcast = fullScript }

                let chunks = splitScriptIntoChunks(fullScript)
                var audioFiles: [URL?] = Array(repeating: nil, count: chunks.count) // Preserve order
                let group = DispatchGroup()

                // Generate audio files in the correct order
                for (index, chunk) in chunks.enumerated() {
                    group.enter()
                    googleTTSService.synthesizeSpeech(text: chunk) { fileURL in
                        if let fileURL = fileURL {
                            print("Generated audio file for chunk \(index): \(chunk.prefix(20))... at \(fileURL)")
                            audioFiles[index] = fileURL // Store in the correct position
                        } else {
                            print("Failed to generate audio for chunk \(index): \(chunk.prefix(20))...")
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    // Filter out nil values and ensure all chunks were generated
                    let validAudioFiles = audioFiles.compactMap { $0 }
                    if validAudioFiles.count != chunks.count {
                        print("Some audio files failed to generate!")
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.errorMessage = "Some audio files failed to generate."
                            self.showError = true
                        }
                        return
                    }

                    // Debug: Print the order of audio files
                    print("Order of audio files:")
                    for (index, fileURL) in validAudioFiles.enumerated() {
                        print("Audio file \(index): \(fileURL)")
                    }

                    // Generate a unique file name for the combined audio
                    let timestamp = Int(Date().timeIntervalSince1970)
                    let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("finalPodcast_\(timestamp).m4a")
                    
                    self.combineAudioFiles(validAudioFiles, outputURL: outputURL) { success in
                        DispatchQueue.main.async {
                            self.isLoading = false
                            if success && self.verifyAudioFile(at: outputURL) {
                                self.finalAudioURL = outputURL
                                self.playAudio()
                            } else {
                                self.errorMessage = "Failed to generate audio."
                                self.showError = true
                            }
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

    private func combineAudioFiles(_ audioFiles: [URL], outputURL: URL, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let composition = AVMutableComposition()
                var insertTime = CMTime.zero
                
                for fileURL in audioFiles {
                    let asset = AVURLAsset(url: fileURL)
                    
                    guard let track = asset.tracks(withMediaType: .audio).first else {
                        print("Skipping invalid audio file at \(fileURL)")
                        continue
                    }
                    
                    let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                    
                    try compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: track, at: insertTime)
                    
                    insertTime = CMTimeAdd(insertTime, asset.duration)
                    
                    print("Inserting audio file: \(fileURL), duration: \(asset.duration.seconds), insert time: \(insertTime.seconds)")
                }
                
                let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
                exporter?.outputURL = outputURL
                exporter?.outputFileType = .m4a
                
                exporter?.exportAsynchronously {
                    DispatchQueue.main.async {
                        if exporter?.status == .completed {
                            print("Audio files combined successfully at: \(outputURL)")
                            completion(true)
                        } else {
                            print("Failed to combine audio files: \(String(describing: exporter?.error))")
                            completion(false)
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error combining audio files: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    func pauseAudio() {
        player?.pause()
        isPlaying = false
    }

    private func stopTimeObserver() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
}
