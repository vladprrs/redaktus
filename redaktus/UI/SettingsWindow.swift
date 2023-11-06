//
//  SettingsWindow.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import SwiftUI

struct SettingsWindow: View {
    @ObservedObject private var viewModel = SettingsViewModel()
    @State private var apiKey: String = ""
    @State private var showingAlert = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter OpenAI API Key", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    self.apiKey = UserSettings.shared.retrieveApiKeyFromKeychain() ?? ""
                }
                .onChange(of: apiKey) { newValue in
                    if UserSettings.shared.isValidApiKey(newValue) {
                        UserSettings.shared.storeApiKeyInKeychain(apiKey: newValue)
                    } else {
                        showingAlert = true
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Invalid API Key"), message: Text("Please enter a valid OpenAI API Key."), dismissButton: .default(Text("OK")))
                }

            Button("Save") {
                if UserSettings.shared.isValidApiKey(apiKey) {
                    UserSettings.shared.apiKey = apiKey
                } else {
                    showingAlert = true
                }
            }
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
