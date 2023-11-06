//
//  AppMenu.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Cocoa

class AppMenu: NSObject {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let menu = NSMenu()
    
    override init() {
        super.init()
        setupMenu()
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("StatusBarIcon"))
            button.action = #selector(toggleMenu(_:))
            button.target = self
        }
    }
    
    private func setupMenu() {
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Close Application", action: #selector(closeApplication(_:)), keyEquivalent: "q"))
    }
    
    @objc func toggleMenu(_ sender: Any?) {
        statusItem.menu = menu // This will hold the menu to the status bar icon
        statusItem.button?.performClick(nil) // Open the menu
    }
    
    @objc private func openSettings(_ sender: NSMenuItem) {
        // Logic to open settings window/modal
        print("Settings opened.")
    }
    
    @objc private func closeApplication(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}

