//
//  HotKeyListener.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Cocoa
import Carbon.HIToolbox

class HotKeyListener {
    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID: EventHotKeyID
    private let signature: OSType
    private let keyCode: UInt32
    private let modifierFlags: UInt32
    private let target: AnyObject
    private let action: Selector

    init(keyCode: UInt32, modifierFlags: UInt32, target: AnyObject, action: Selector) {
        // Generate a random signature for the hotkey
        self.signature = OSType(arc4random())
        self.keyCode = keyCode
        self.modifierFlags = modifierFlags
        self.target = target
        self.action = action
        self.hotKeyID = EventHotKeyID(signature: signature, id: UInt32(self.signature))
        
        // Register the hotkey
        registerHotKey()
    }

    deinit {
        // Unregister the hotkey before deallocating
        unregisterHotKey()
    }

    private func registerHotKey() {
        // Define the event type for the hotkey
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

        // Register the hotkey with Carbon
        InstallEventHandler(GetApplicationEventTarget(), { (handlerCallRef, event, userData) -> OSStatus in
            // Call the action on target when hotkey is pressed
            let hotKey = Unmanaged<HotKeyListener>.fromOpaque(userData!).takeUnretainedValue()
            NSApp.sendAction(hotKey.action, to: hotKey.target, from: nil)
            return noErr
        }, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), nil)

        // Register the hotkey
        let status = RegisterEventHotKey(UInt32(keyCode), UInt32(modifierFlags), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        
        if status != noErr {
            print("Failed to register hotkey with error \(status)")
        }
    }

    private func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
    }
}

