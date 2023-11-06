//
//  OpenAIClient.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

class OpenAIClient {
    static let shared = OpenAIClient(apiKey: "") // Make sure to handle the apiKey appropriately

    private var apiKey: String?

    private init() {} // Private initializer to ensure singleton usage

    func setAPIKey(_ key: String) {
        self.apiKey = key
    }

    func sendGrammarCorrectionRequest(text: String, completion: @escaping (Result<GrammarCorrectionResponse, Error>) -> Void) {
            // Prepare the request data
            let requestData = GrammarCorrectionRequest(
                prompt: text,
                temperature: 0.5, // You might want these to be parameters or constants
                maxTokens: 60,
                topP: 1.0,
                frequencyPenalty: 0.0,
                presencePenalty: 0.0
            )
            
            // Convert your requestData into JSON
            guard let jsonData = try? JSONEncoder().encode(requestData) else {
                completion(.failure(AppError.processingError(reason: "Could not encode request data.")))
                return
            }
            
            // Create the URL request
            var request = URLRequest(url: URL(string: Constants.API.baseURL)!)
            request.httpMethod = "POST"
            guard let apiKey = self.apiKey else {
                // Handle the case where apiKey is nil, perhaps by calling the completion handler with an error
                completion(.failure(AppError.apiKeyNotSet))
                return
            }
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: Constants.API.apiKeyHeaderField)
            request.httpBody = jsonData

            // Start the URL session task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle the response here
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(AppError.networkError(description: "No data received from the server.")))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(GrammarCorrectionResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }

    
    func performRequest(with text: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = apiKey else {
            completion(.failure(OpenAIError.apiKeyNotSet))
            return
        }

        // Construct the URL and request
        let endpoint = URL(string: Constants.API.baseURL)!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set up the request body with the parameters you need
        let requestBody = ["prompt": text]
        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = requestBodyData
        } catch {
            completion(.failure(error))
            return
        }

        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(OpenAIError.noData))
                return
            }

            do {
                // Assuming you're expecting a JSON response, you would parse it here
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                // Process jsonResponse and call completion with the result
                // For the sake of this example, we're just going to send back the raw JSON
                let jsonText = String(decoding: data, as: UTF8.self)
                completion(.success(jsonText))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
