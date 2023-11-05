//
//  ContentView.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage("OPENAI_API_KEY") var apiKey: String = ""
    @AppStorage("prompt") var prompt: String = ""
    @AppStorage("model") var model: String = ""

    var body: some View {
        Form {
            TextField("OpenAI API Key", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Default Prompt", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Model", text: $model)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .frame(width: 400, height: 400)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
