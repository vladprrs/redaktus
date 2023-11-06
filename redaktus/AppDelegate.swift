//
//  AppDelegate.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var menuController: MenuController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Setup the menu controller if using a status bar app approach
        menuController = MenuController()
        
        // Request Notification Permissions
        NotificationManager.shared.requestAuthorization { granted, error in
            if let error = error {
                ErrorHandler.handleError(error)
            } else if granted {
                // Permissions granted, handle as necessary
            } else {
                // Permissions not granted, handle as necessary
            }
        }
        
        // Setup hotkeys, user preferences, etc.
        setupUserPreferences()
        registerHotKeys()
        
        // Register for settings changed notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingsChanged(_:)),
            name: NSNotification.Name(Constants.Notifications.settingsChanged),
            object: nil
        )
    }
    
    @objc func settingsChanged(_ notification: Notification) {
        // Handle the settings change event, e.g., reload configuration
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: - Setup Methods
    
    private func setupUserPreferences() {
        // Set up user preferences or defaults
        // e.g., UserDefaults.standard.register(defaults: ...)
    }
    
    private func registerHotKeys() {
        // Register global hotkeys
        // e.g., HotKeyListener.shared.registerHotKey(with: ...)
    }

    // MARK: - Core Application Methods
    
    // Add any core application logic methods you need here.
}

// Add any additional AppDelegate extension methods needed for handling application logic.
