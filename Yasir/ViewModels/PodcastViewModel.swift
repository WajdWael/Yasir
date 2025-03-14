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
        
        // Reset the player completely
        resetPlayer()
        
        // Initialize the player
        player = AVPlayer(url: finalAudioURL)
        player?.volume = volume
        player?.rate = playbackRate
        
        // Log the player's initial state
        if let player = player {
            print("Player initialized with current time: \(player.currentTime().seconds)")
        }
        
        // Seek to the beginning with zero tolerance
        player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            if finished {
                print("Player successfully seeked to the beginning.")
                self?.startTimeObserver()
            } else {
                print("Failed to seek to the beginning.")
            }
        }
        
        print("Player initialized successfully with new podcast at \(finalAudioURL)")
    }

    private func resetPlayer() {
        stopTimeObserver()
        player?.pause()
        player = nil
        print("Player reset successfully")
        
        // Add a small delay to ensure the player is fully reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Player reset completed.")
        }
    }

    func playAudio() {
        initializePlayer() // Ensure the player is initialized
        
        // Add a small delay to ensure the player is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if let player = self.player {
                if player.currentTime().seconds > 0 {
                    player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
                        if finished {
                            player.play()
                            self.isPlaying = true
                            print("Player started playing at time: \(player.currentTime().seconds)")
                        } else {
                            print("Failed to seek to the beginning before playback.")
                        }
                    }
                } else {
                    player.play()
                    self.isPlaying = true
                    print("Player started playing at time: \(player.currentTime().seconds)")
                }
            }
        }
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
        print("Combined audio file duration: \(duration) seconds")
        
        // Check if the duration is valid
        guard duration > 0 else {
            print("Invalid audio file: duration is zero or negative.")
            return false
        }
        
        // Check if the file is playable
        var isPlayable = false
        let semaphore = DispatchSemaphore(value: 0)
        
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            if asset.statusOfValue(forKey: "playable", error: nil) == .loaded {
                isPlayable = asset.isPlayable
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if !isPlayable {
            print("Audio file is not playable.")
        }
        
        return isPlayable
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
                                self.errorMessage = "Failed to generate or verify audio."
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
                    
                    // Log the duration of each audio file
                    let duration = CMTimeGetSeconds(asset.duration)
                    print("Inserting audio file: \(fileURL), duration: \(duration), insert time: \(CMTimeGetSeconds(insertTime))")
                    
                    guard let track = asset.tracks(withMediaType: .audio).first else {
                        print("Skipping invalid audio file at \(fileURL)")
                        continue
                    }
                    
                    let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                    
                    try compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: track, at: insertTime)
                    
                    insertTime = CMTimeAdd(insertTime, asset.duration)
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
