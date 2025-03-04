//
//  GeminiService.swift
//  Yasir
//
//  Created by Whyyy on 04/03/2025.
//


import Foundation

class GeminiService {
    private let apiKey: String = "API_KEY"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    
    func processText(content: String, type: ProcessType) async throws -> String {
        var prompt: String 

        switch type {
        case .summary:
            let isArabic = content.range(of: "\\p{Arabic}", options: .regularExpression) != nil
            if isArabic {
                prompt = """
                لخّص النص التالي بإيجاز مع التركيز على الجوهر، ليكون بمثابة ملاحظات دراسية منظمة. هيكل الملخص كالتالي:

                [أدخل عنوانًا واضحًا] 
                [أدخل عنوانًا فرعيًا موجزًا يعطي سياقًا] 
                
                النقاط الأساسية:  
                - [أول نقطة أساسية]  \n
                - [ثاني نقطة أساسية]  \n
                - [نقاط أساسية إضافية]  \n
                - [نقاط أساسية إضافية]  \n

                \(content)
                """
            } else {
                prompt = """
                Summarize the following text concisely, capturing the core of the text for the user to study, something like study notes. Structure the summary with:

                [Provide a clear title] non-bold
                [Give a brief contextual subheading] non-bold

                Key Points:  
                - [First core point]  \n
                - [Second core point]  \n
                - [Additional core points]  \n
                - [Additional core points]  \n

                \(content)
                """
            }
            
            // Remove the stars from the generated text
            prompt = prompt.replacingOccurrences(of: "**", with: "")
            
        case .questions:
            prompt = """
            Generate 5 multiple-choice questions based on the following text. For each question:
            1. Create one correct answer
            2. Create three incorrect but plausible answers
            3. Format each question as JSON like this:
            {
                "question": "The question text here?",
                "correctAnswer": "The correct answer",
                "incorrectAnswers": ["Wrong answer 1", "Wrong answer 2", "Wrong answer 3"]
            }
            
            Text to analyze:
            \(content)
            """
        }
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        let urlString = "\(baseURL)?key=\(apiKey)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // For debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString)")
        }
        
     
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return response.candidates?.first?.content.parts.first?.text ?? "No response generated"
    }
}

// Updated response models to match the current API structure
struct GeminiResponse: Codable {
    let candidates: [Candidate]?
    let promptFeedback: PromptFeedback?
    
    struct Candidate: Codable {
        let content: Content
        let finishReason: String?
        let index: Int?
        let safetyRatings: [SafetyRating]?
    }
    
    struct Content: Codable {
        let parts: [Part]
        let role: String?
    }
    
    struct Part: Codable {
        let text: String
    }
    
    struct SafetyRating: Codable {
        let category: String
        let probability: String
    }
    
    struct PromptFeedback: Codable {
        let safetyRatings: [SafetyRating]?
    }
}

enum ProcessType {
    case summary
    case questions
}

