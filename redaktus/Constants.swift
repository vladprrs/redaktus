//
//  Constants.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

struct Constants {
    
    // MARK: - API Related
    struct API {
        static let baseURL = "https://api.openai.com/v1/engines/davinci-codex/completions"
        static let apiKeyHeaderField = "Authorization"
        // Include any other API-related constants here.
    }
    
    // MARK: - User Defaults Keys
    struct UserDefaults {
        static let apiKey = "UserDefaultsAPIKey"
        static let hotKey = "UserDefaultsHotKey"
        // Define additional keys as needed.
    }
    
    // MARK: - Notification Identifiers
    struct Notifications {
        static let settingsChanged = "SettingsChangedNotification"
        // Add more notification identifiers if needed.
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let generalErrorTitle = "An Error Occurred"
        static let generalErrorMessage = "Something went wrong. Please try again later."
        static let networkErrorMessage = "There was a problem connecting to the server. Check your internet connection and try again."
        // You can add other specific error messages here.
    }
    
    // MARK: - UI Related
    struct UI {
        static let statusItemIconName = "StatusBarIcon"
        static let defaultHotKey = "Command+Shift+R"
        // Add any other UI-related constants, such as view identifiers.
    }
    
    // MARK: - Accessibility
    struct Accessibility {
        static let settingsWindow = "SettingsWindowAccessibilityIdentifier"
        // Include additional accessibility identifiers as necessary.
    }
    
    // MARK: - Miscellaneous
    static let applicationName = "Redaktus"
    // You can include any other miscellaneous constants that you may need.
    
    // Perhaps include a section for any default settings or configuration details
    // MARK: - Default Settings
    struct DefaultSettings {
        static let language = "en"
        // Include defaults for temperature, maxTokens, topP, etc., if they are standard.
    }
}

// You can extend the Constants struct to include more specific or additional settings, such as:
// API paths, timeout durations, default values for API requests, and so on.
