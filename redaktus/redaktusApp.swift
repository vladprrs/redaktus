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
        Settings {
            PreferencesView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Инициализация контроллера статус-бара
        statusBar = StatusBarController.init()
    }
}

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover

    init() {
        // Создание статус-бара
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(named: "StatusBarIcon") // Замените на вашу иконку
            statusBarButton.action = #selector(togglePopover(_:))
        }
        
        // Создание и конфигурация popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PreferencesView())
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
