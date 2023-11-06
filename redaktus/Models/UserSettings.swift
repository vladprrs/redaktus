//
//  UserSettings.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation
import Security

class UserSettings {
    
    static let shared = UserSettings()
    private let apiKeyUserDefaultsKey = "OpenAI_APIKey"
    
    var apiKey: String? {
        get {
            // Attempt to retrieve from keychain first
            return retrieveApiKeyFromKeychain()
        }
        set {
            guard let newKey = newValue, isValidApiKey(newKey) else {
                print("Invalid API Key format or length.")
                return
            }
            // Store new key in UserDefaults and Keychain
            UserDefaults.standard.set(newKey, forKey: apiKeyUserDefaultsKey)
            storeApiKeyInKeychain(apiKey: newKey)
            print("API Key updated successfully.")
        }
    }

    private init() {}
    
    internal func isValidApiKey(_ key: String) -> Bool {
        // Basic validation for OpenAI API key structure - adjust the logic according to actual key format
        let pattern = #"^[A-Za-z0-9]{10,}$"#
        let result = key.range(of: pattern, options: .regularExpression) != nil
        return result
    }
    
    // Securely store the API Key in Keychain
    // For a real application, consider storing sensitive information like API keys in the Keychain
    func storeApiKeyInKeychain(apiKey: String) {
        let query: [String: Any] = [kSecValueData as String: apiKey.data(using: .utf8)!,
                                    kSecAttrAccount as String: apiKeyUserDefaultsKey,
                                    kSecClass as String: kSecClassGenericPassword]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error storing API key in keychain.")
            return
        }
        print("API Key stored successfully in the keychain.")
    }
    
    func retrieveApiKeyFromKeychain() -> String? {
        let query: [String: Any] = [kSecAttrAccount as String: apiKeyUserDefaultsKey,
                                    kSecClass as String: kSecClassGenericPassword,
                                    kSecReturnData as String: kCFBooleanTrue!,
                                    kSecMatchLimit as String: kSecMatchLimitOne]
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let apiKey = String(data: data, encoding: .utf8) {
                return apiKey
            }
        }
        print("Error retrieving API key from keychain.")
        return nil
    }
    
    func deleteApiKeyFromKeychain() {
        let query: [String: Any] = [kSecAttrAccount as String: apiKeyUserDefaultsKey,
                                    kSecClass as String: kSecClassGenericPassword]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Error deleting API key from keychain.")
            return
        }
        print("API Key deleted successfully from the keychain.")
    }
}
