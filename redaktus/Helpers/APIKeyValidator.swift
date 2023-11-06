//
//  APIKeyValidator.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation

struct APIKeyValidator {
    static func isValidKey(_ key: String) -> Bool {
        let pattern = "^[A-Za-z0-9]{40}$" // Assuming the OpenAI API key is 40 alphanumeric characters
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: key.utf16.count)
        return regex.firstMatch(in: key, options: [], range: range) != nil
    }
}

// Usage example within some Settings management context
class SettingsManager {
    static let shared = SettingsManager()

    private init() {}

    func saveAPIKey(_ key: String) {
        guard APIKeyValidator.isValidKey(key) else {
            print("Fucking invalid API key format. Try again.")
            return
        }
        UserDefaults.standard.set(key, forKey: "OpenAI_APIKey")
        print("API Key saved. Hopefully, you didn't screw it up.")
    }

    func loadAPIKey() -> String? {
        return UserDefaults.standard.string(forKey: "OpenAI_APIKey")
    }
}
