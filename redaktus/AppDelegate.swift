//
//  AppDelegate.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Cocoa
import Carbon.HIToolbox.Events
import OSLog

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var hotKeyRef: EventHotKeyRef?
    var openAIClient = OpenAIClient()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        registerHotKey()
        loadSettings()
        openAIClient.validateAPIKey()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        unregisterHotKey()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIconActive") // Assuming active icon is the default
            constructMenu()
        }
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Redaktus", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        statusItem.menu = menu
    }
    
    @objc private func openSettings() {
        // Assuming there's a function to open settings window/modal
        openSettingsWindow()
    }
    
    private func registerHotKey() {
        let hotKeyID = EventHotKeyID(signature: UInt32('htk1'), id: 1)
        let hotKeyRegisterEvent = RegisterEventHotKey(UInt32(kVK_ANSI_C), UInt32(cmdKey | optionKey), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        if hotKeyRegisterEvent != noErr {
            NSLog("Failed to register global hotkey")
        }
    }
    
    private func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
    }
    
    private func loadSettings() {
        let settings = UserDefaults.standard
        // Load settings and apply them
        if let apiKey = settings.string(forKey: "OpenAI_API_Key") {
            openAIClient.apiKey = apiKey
        }
    }
    
    // MARK: - Hotkey Handler
    
    private func handleGlobalHotkeyPress(keyCode: UInt16) {
        guard keyCode == UInt16(kVK_ANSI_C) && NSEvent.modifierFlags.contains([.command, .option]) else { return }
        // Perform the text correction flow
        attemptTextCorrection()
    }
    
    private func attemptTextCorrection() {
        // Assuming there's a function that performs the text correction
        correctSelectedText()
    }
}
