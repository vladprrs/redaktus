//
//  MenuController.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Cocoa

class MenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    private var statusItem: NSStatusItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(Constants.UI.statusItemIconName))
        }
        statusItem.menu = statusMenu
    }
    
    @IBAction func openSettingsMenuItemSelected(_ sender: NSMenuItem) {
        // Code to open the settings window
        NotificationCenter.default.post(name: Notification.Name(Constants.Notifications.settingsChanged), object: nil)
    }
    
    @IBAction func checkGrammarMenuItemSelected(_ sender: NSMenuItem) {
        // Code to trigger the main feature of the app, like checking grammar
    }
    
    @IBAction func quitAppMenuItemSelected(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // Additional menu-related functions as needed
}

