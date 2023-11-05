//
//  APIModels.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

// MARK: - API Request Models

/// Represents the request body for sending text to the OpenAI API for grammar correction.
struct GrammarCorrectionRequest: Codable {
    let prompt: String
    let temperature: Double
    let maxTokens: Int
    let topP: Double
    let frequencyPenalty: Double
    let presencePenalty: Double
}

// You might also have other request models if your application interacts with different OpenAI API endpoints.

// MARK: - API Response Models

/// Represents the response received from the OpenAI API for grammar correction.
struct GrammarCorrectionResponse: Codable {
    struct Choice: Codable {
        let text: String
        let index: Int
        let logprobs: LogProbs?
        let finishReason: String
    }
    
    struct LogProbs: Codable {
        // Define the properties of LogProbs based on the API documentation
        // Example:
        // let tokens: [String]
        // let tokenLogprobs: [Double]
        // let topLogprobs: [[String: Double]]
        // ...
    }
    
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

// In case you expect different types of responses, you could define multiple structures here.

// MARK: - Error Models

/// Represents the error object returned by the OpenAI API.
enum OpenAIError: Error {
    case apiKeyNotSet
    case noData
    case customError(String)
}

struct ErrorDetail: Codable {
    let message: String
    let type: String
    let param: String?
    let code: Int?
}

// Define additional error-handling logic if needed, such as converting this to a user-friendly error message.
extension OpenAIError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString("OpenAI Error: \(error.message)", comment: "Error message returned from OpenAI API")
    }
}
