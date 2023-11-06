//
//  StatusBarIcon.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import SwiftUI
import AppKit

@main
struct StatusBarIconApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            Text("Settings")
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "StatusBarIcon") // Make sure the damn icon is set in your Assets.xcassets
            button.action = #selector(self.statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        constructMenu()
    }

    @objc func statusBarButtonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            constructMenu()
            statusBarItem.menu?.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
        } else {
            statusBarItem.menu = nil // Hide the damn menu when the icon is clicked
            // Here you can toggle the active/inactive state or perform any action
            print("StatusBar icon clicked")
        }
    }

    func constructMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Settings", action: #selector(AppDelegate.openSettings), keyEquivalent: "S"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Close Application", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusBarItem.menu = menu
    }

    @objc func openSettings() {
        // Open your damn settings window here
        print("Settings clicked")
    }
}
