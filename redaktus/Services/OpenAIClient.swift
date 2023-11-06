//
//  OpenAIClient.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation

class OpenAIClient {

    static let shared = OpenAIClient()
    
    private let baseURL = URL(string: "https://api.openai.com")!
    private var apiKey: String?
    
    private init() {}
    
    func setAPIKey(key: String) {
        self.apiKey = key
    }
    
    func correctText(_ text: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API Key is not set."])))
            return
        }
        
        guard text.count <= 1024 else {
            completion(.failure(NSError(domain: "", code: 413, userInfo: [NSLocalizedDescriptionKey: "Text exceeds the 1024 character limit."])))
            return
        }
        
        let endpoint = baseURL.appendingPathComponent("/v1/engines/davinci-codex/completions")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["prompt": text, "max_tokens": 1]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200..<300 ~= response.statusCode else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid server response."])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let correctedText = json["choices"] as? [[String: Any]],
                   let firstChoice = correctedText.first,
                   let text = firstChoice["text"] as? String {
                    completion(.success(text))
                } else {
                    completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse the response."])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
