//
//  SettingsWindowController.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var apiKeyTextField: NSTextField!
    @IBOutlet weak var hotKeyTextField: NSTextField!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("SettingsWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self // Set the window delegate to the controller
        
        // Load settings from UserDefaults
        loadSettings()
    }
    
    private func loadSettings() {
        // Assuming that you have user defaults keys defined in your Constants.swift file
        let defaults = UserDefaults.standard
        apiKeyTextField.stringValue = defaults.string(forKey: Constants.UserDefaults.apiKey) ?? ""
        // For the hotKeyTextField, you will need to convert a hotkey keycode to a string representation
        // This is a simplified example, you might need a converter function
        hotKeyTextField.stringValue = defaults.string(forKey: Constants.UserDefaults.hotKey) ?? Constants.UI.defaultHotKey
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        // Save the settings to UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(apiKeyTextField.stringValue, forKey: Constants.UserDefaults.apiKey)
        // Here you would convert the string representation of the hotkey back to a keycode
        // Again, you might need a converter function
        defaults.set(hotKeyTextField.stringValue, forKey: Constants.UserDefaults.hotKey)
        
        // Post a notification that the settings have changed
        NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.settingsChanged), object: nil)
        
        // Close the window
        self.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        // Close the window without saving
        self.window?.close()
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        // Perform any cleanup if needed before the window closes
    }
    
    // Add more functions as needed for handling other UI elements and actions
    
}
