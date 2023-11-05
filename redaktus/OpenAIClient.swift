//
//  OpenAIClient.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

class OpenAIClient {
    static let shared = OpenAIClient()

    private var apiKey: String?

    private init() {} // Private initializer to ensure singleton usage

    func setAPIKey(_ key: String) {
        self.apiKey = key
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
