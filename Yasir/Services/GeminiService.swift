//
//  GeminiService.swift
//  Yasir
//
//  Created by Whyyy on 04/03/2025.
//


import Foundation

class GeminiService {
    private let apiKey: String = "API_KEY" // Replace with API_KEY
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    
    func processText(content: String, type: ProcessType) async throws -> String {
        let isArabic = isContentArabic(content)
        var prompt: String
        
        switch type {
        case .summary:
            prompt = createSummaryPrompt(content: content, isArabic: isArabic)
        case .questions:
            prompt = createQuestionPrompt(content: content, isArabic: isArabic)
        case .podcast:
            prompt = createPodcastPrompt(content: content)
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // First check if response is HTTPURLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "APIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }

        // Then check status code
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"])
        }
        
        let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return decodedResponse.candidates?.first?.content.parts.first?.text
            .replacingOccurrences(of: "**", with: "") ?? "No response generated"
    }
    
    // MARK: - Private Helper Methods
    private func isContentArabic(_ content: String) -> Bool {
        let minLength = 50
        guard content.utf16.count >= minLength else { return false }
        
        let arabicRegex = try! NSRegularExpression(pattern: "\\p{Arabic}", options: [])
        let matches = arabicRegex.matches(in: content, range: NSRange(location: 0, length: content.utf16.count))
        let arabicCount = Double(matches.count)
        let total = Double(content.utf16.count)
        return (arabicCount / total) > 0.6
    }
    
    private func createSummaryPrompt(content: String, isArabic: Bool) -> String {
        if isArabic {
            return """
            لخّص النص التالي بإيجاز مع التركيز على الجوهر، ليكون بمثابة ملاحظات دراسية منظمة. هيكل الملخص كالتالي:

            [أدخل عنوانًا واضحًا دون استخدام أي تنسيق أو علامات مثل **] 
            [أدخل عنوانًا فرعيًا موجزًا يعطي سياقًا دون تنسيق] 
            
            النقاط الأساسية:  
            - [أول نقطة أساسية]  \n
            - [ثاني نقطة أساسية]  \n
            - [نقاط أساسية إضافية]  \n
            - [نقاط أساسية إضافية]  \n

            \(content)
            """
        } else {
            return """
            Summarize the following text concisely, capturing the core of the text for the user to study. Structure the summary with plain text only (no markdown or **):

            [Provide a clear title]
            [Give a brief contextual subheading]

            Key Points:  
            - [First core point]  \n
            - [Second core point]  \n
            - [Additional core points]  \n
            - [Additional core points]  \n

            \(content)
            """
        }
    }
    
    private func createQuestionPrompt(content: String, isArabic: Bool) -> String {
        if isArabic {
            return """
            10 أسئلة اختيار من متعدد باللغة العربية بناءً على النص التالي. لكل سؤال:
            1. إنشاء إجابة صحيحة واحدة بالعربية
            2. إنشاء ثلاث إجابات خاطئة ولكن معقولة بالعربية
            3. تنسيق الرد كمجموعة JSON مع الحفاظ على المفاتيح بالإنجليزية:
            [
                {
                    "question": "نص السؤال؟",
                    "correctAnswer": "الإجابة الصحيحة",
                    "incorrectAnswers": ["إجابة خاطئة 1", "إجابة خاطئة 2", "إجابة خاطئة 3"]
                }
            ]

            النص المراد تحليله:
            \(content)
            """
        } else {
            return """
            Generate 10 multiple-choice questions based on the following text. For each question:
            1. Create one correct answer
            2. Create three incorrect but plausible answers
            3. Format the response as a JSON array like this:
            [
                {
                    "question": "Question text?",
                    "correctAnswer": "Correct answer",
                    "incorrectAnswers": ["Wrong 1", "Wrong 2", "Wrong 3"]
                }
            ]
            
            Text to analyze:
            \(content)
            """
        }
    }
    
    private func createPodcastPrompt(content: String) -> String {
        return """
        Write a fun and engaging podcast script for Yassir's podcast in a conversational tone. Keep it light, humorous, and easy to follow for a general audience. Focus on key points while keeping it concise. Exclude intros, outros, titles, names, and any use of asterisks. Ensure the total byte size (including the prompt and script) does not exceed 5000 bytes

        Text:
        \(content)
        """
    }
}

// MARK: - Response Models
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
    case podcast
}
