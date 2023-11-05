//
//  redaktusApp.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import SwiftUI

@main
struct RedaktusApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 200)
        }
        .commands {
            RedaktusCommands()
        }

        // Register other app scenes as needed, such as settings or additional windows
    }
}

struct ContentView: View {
    var body: some View {
        // This would be the primary view of your app
        Text("Welcome to Redaktus!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RedaktusCommands: Commands {
    var body: some Commands {
        // Here you can define command menus and keyboard shortcuts
        CommandMenu("Redaktus") {
            Button("Check for Updates...") {
                // Implement update checking logic
            }.keyboardShortcut(",", modifiers: .command)
        }
    }
}
