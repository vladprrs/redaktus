//
//  UserPreferences.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

struct UserPreferences {
    
    private enum Keys {
        static let apiKey = "UserPreferencesAPIKey"
        static let hotKey = "UserPreferencesHotKey"
        // Add a new key for grammar correction preferences
        static let grammarCorrectionEnabled = "UserPreferencesGrammarCorrectionEnabled"
    }
    
    static var apiKey: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.apiKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.apiKey)
        }
    }
    
    static var hotKey: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.hotKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hotKey)
        }
    }
    
    // New property for enabling or disabling grammar correction
    static var grammarCorrectionEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.grammarCorrectionEnabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.grammarCorrectionEnabled)
        }
    }
    
    // Add more preferences here as needed
    
    static func registerDefaults() {
        let defaultValues = [
            Keys.apiKey: "",
            Keys.hotKey: "",
            // Set default value for grammar correction preference
            Keys.grammarCorrectionEnabled: false
        ]
        UserDefaults.standard.register(defaults: defaultValues)
    }
}
