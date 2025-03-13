//
//  GoogleTTSService.swift
//  Yasir
//
//  Created by Yomna Eisa on 11/03/2025.
//

import Foundation
import AVFoundation

class GoogleTTSService {
    private let apiKey: String = " " // Replace with your Google TTS API key
    private let ttsURL = "https://texttospeech.googleapis.com/v1/text:synthesize"

    func synthesizeSpeech(text: String, completion: @escaping (URL?) -> Void) {
        print("Synthesizing speech for text: \(text)") // Debug log

        let requestBody: [String: Any] = [
            "input": [
                "text": text
            ],
            "voice": [
                "languageCode": "en-US",
                "name": "en-US-Studio-O"
            ],
            "audioConfig": [
                "audioEncoding": "MP3"
            ]
        ]

        guard let url = URL(string: "\(ttsURL)?key=\(apiKey)") else {
            print("Invalid URL") // Debug log
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)") // Debug log
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received") // Debug log
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("API Response: \(json)") // Debug log
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let audioContent = json["audioContent"] as? String,
                  let audioData = Data(base64Encoded: audioContent) else {
                print("Invalid response format") // Debug log
                completion(nil)
                return
            }

            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("podcast.mp3")
            do {
                try audioData.write(to: fileURL)
                print("Audio saved to: \(fileURL)") // Debug log
                completion(fileURL)
            } catch {
                print("Error saving audio file: \(error.localizedDescription)") // Debug log
                completion(nil)
            }
        }

        task.resume()
    }
}
