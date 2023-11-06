//
//  OpenAIClient.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation

class OpenAIClient {
    static let shared = OpenAIClient() // Singleton instance
    private let session: URLSession
    private let apiKey: String
    private let endpoint = URL(string: "https://api.openai.com/v1/engines/davinci/corrections")!

    private init(session: URLSession = .shared, apiKey: String = "") {
        self.session = session
        self.apiKey = apiKey // This should be injected or fetched securely, possibly from the Keychain
    }

    func setAPIKey(_ newApiKey: String) {
        // Assuming there's a method to securely save the API key which is out of the scope of this file
    }

    func correctText(_ text: String, completion: @escaping (Result<CorrectionResult, Error>) -> Void) {
        guard !apiKey.isEmpty else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "API key is missing."])))
            return
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = ["text": text]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }

            do {
                let correctionResult = try JSONDecoder().decode(CorrectionResult.self, from: data)
                completion(.success(correctionResult))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
