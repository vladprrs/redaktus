//
//  Constants.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation
import Carbon.HIToolbox

struct Constants {
    
    // MARK: - API Client Constants
    static let openAIAPIClientID = "OpenAIAPIClient"
    static let openAIAPISecret = "OpenAIAPISecret"
    
    // OpenAI API Configuration
    static let openAIBaseURL = "https://api.openai.com/v1"
    static let openAIKeyValidationPattern = "sk-\\S{40}"
    
    // MARK: - UserDefaults Keys
    static let userDefaultsAPIKey = "UserDefaultsAPIKey"
    static let userDefaultsHotKey = "UserDefaultsHotKey"
    
    // MARK: - HotKey Defaults
    static let defaultHotKeyCombo = (key: kVK_ANSI_C, modifiers: cmdKey | optionKey)
    static let maxTextLength = 1024
    
    // MARK: - User Interface Constants
    static let statusItemIconName = "StatusBarIconTemplate"
    
    // MARK: - Error Messages
    static let genericErrorMessage = "An unexpected error occurred. Please try again."
    static let networkErrorMessage = "Couldn't connect to the server. Check your connection or try again later."
    static let apiKeyErrorMessage = "Invalid API Key. Please check your input and try again."
    static let textSelectionErrorMessage = "Text selection exceeds the limit of \(Constants.maxTextLength) characters."
    
    // MARK: - Networking Retry Configuration
    static let retryAttempts = 3
    static let retryDelayInSeconds = 2.0
    
    // MARK: - Clipboard Constants
    static let clipboardTimeout = 2.0 // Seconds to wait before restoring clipboard
}
