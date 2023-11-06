//
//  SettingsViewModel.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation

class SettingsViewModel {
    // Use UserDefaults for simplicity. For a production app, consider a more secure storage mechanism.
    private let defaults = UserDefaults.standard
    
    // Define keys for the settings
    private enum SettingsKey: String {
        case enableAutocorrect
        case enableSmartSuggestions
        // Add other settings keys here
    }
    
    // Properties for each setting that can be bound to UI components
    var enableAutocorrect: Bool {
        get { defaults.bool(forKey: SettingsKey.enableAutocorrect.rawValue) }
        set { defaults.set(newValue, forKey: SettingsKey.enableAutocorrect.rawValue) }
    }
    
    var enableSmartSuggestions: Bool {
        get { defaults.bool(forKey: SettingsKey.enableSmartSuggestions.rawValue) }
        set { defaults.set(newValue, forKey: SettingsKey.enableSmartSuggestions.rawValue) }
    }
    
    // Initialization
    init() {
        registerDefaults()
    }
    
    // Register default settings values
    private func registerDefaults() {
        defaults.register(defaults: [
            SettingsKey.enableAutocorrect.rawValue: true,
            SettingsKey.enableSmartSuggestions.rawValue: true
            // Register other default values here
        ])
    }
    
}
