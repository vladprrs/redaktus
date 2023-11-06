//
//  SettingsViewModel.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var apiKey: String = ""
    @Published var isApiKeyValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $apiKey
            .map { $0.count == 40 && $0.allSatisfy({ $0.isLetter || $0.isNumber }) } // API Key validation logic
            .assign(to: \.isApiKeyValid, on: self)
            .store(in: &cancellables)
    }
    
    func saveApiKey() {
        guard isApiKeyValid else {
            print("Failed to save: Invalid API Key.")
            return
        }
        UserDefaults.standard.set(apiKey, forKey: "OpenAI_APIKey")
        print("API Key saved.")
    }
    
    func loadApiKey() {
        apiKey = UserDefaults.standard.string(forKey: "OpenAI_APIKey") ?? ""
    }
}
