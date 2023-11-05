//
//  OpenAIClient.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

class OpenAIClient {

    // Singleton instance for global access
    static let shared = OpenAIClient()

    private let session: URLSession
    private let apiKey: String

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    // Function to send text for grammar correction
    func sendGrammarCorrectionRequest(text: String, completion: @escaping (Result<GrammarCorrectionResponse, Error>) -> Void) {
        // Construct the request model
        let requestModel = GrammarCorrectionRequest(
            prompt: text,
            temperature: 0.5, // You can adjust this value as needed
            maxTokens: 60,    // You can adjust this value as needed
            topP: 1.0,
            frequencyPenalty: 0.0,
            presencePenalty: 0.0
        )
        
        // Serialize the request model to JSON data
        guard let requestData = try? JSONEncoder().encode(requestModel) else {
            completion(.failure(AppError.processingError(reason: "Failed to encode request data.")))
            return
        }
        
        // Create the URL for the API request
        guard let url = URL(string: Constants.API.baseURL) else {
            completion(.failure(AppError.networkError(description: "Invalid API URL.")))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.addValue("Bearer \(self.apiKey)", forHTTPHeaderField: Constants.API.apiKeyHeaderField)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Start the network task
        let task = session.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                completion(.failure(AppError.networkError(description: error.localizedDescription)))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(AppError.apiError(code: (response as? HTTPURLResponse)?.statusCode ?? 500, message: "Invalid response from server.")))
                return
            }
            
            // Parse the JSON data
            guard let data = data else {
                completion(.failure(AppError.internalError(message: "No data received from server.")))
                return
            }
            
            // Decode the response
            do {
                let responseModel = try JSONDecoder().decode(GrammarCorrectionResponse.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(AppError.processingError(reason: "Failed to decode response.")))
            }
        }
        
        task.resume()
    }

    // Add more API interaction methods as needed
}

