//
//  GeminiService.swift
//  Yasir
//
//  Created by Whyyy on 04/03/2025.
//


import Foundation

class GeminiService {
    private let apiKey: String = "AIzaSyBot7gWxANXlg1vIZ3wcIZKNSB064YzWOM"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    
    func processText(content: String, type: ProcessType) async throws -> String {
        let isArabic = content.range(of: "\\p{Arabic}", options: .regularExpression) != nil
        var prompt: String

        switch type {
        case .summary:
            if isArabic {
                prompt = """
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
                prompt = """
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
            
        case .questions:
            if isArabic {
                prompt = """
                ا生成 10 أسئلة اختيار من متعدد باللغة العربية بناءً على النص التالي. لكل سؤال:
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
                prompt = """
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
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        let responseText = response.candidates?.first?.content.parts.first?.text ?? "No response generated"
        
        // Remove any ** from the final output
        return responseText.replacingOccurrences(of: "**", with: "")
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
