//
//  KeyboardListener.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Carbon
import Cocoa

class KeyboardListener {
    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID: EventHotKeyID
    private let signature: OSType
    private var eventHandler: EventHandlerRef?
    private let correctionHandler: () -> Void

    init(correctionHandler: @escaping () -> Void) {
        self.correctionHandler = correctionHandler
        self.signature = KeyboardListener.signatureFrom(string: "rdkt")
        self.hotKeyID = EventHotKeyID(signature: signature, id: UInt32(1)) // 1 is just a unique identifier, can be any UInt32
        registerHotKey()
        installEventHandler()
    }
    
    deinit {
        unregisterHotKey()
        removeEventHandler()
    }
    
    private func registerHotKey() {
        // Default hotkey is Command + Option + C (kVK_ANSI_C)
        let hotKey = UInt32(kVK_ANSI_C)
        let hotKeyModifiers = UInt32(cmdKey | optionKey)
        RegisterEventHotKey(hotKey, hotKeyModifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }
    
    private func installEventHandler() {
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (handlerCallRef, event, userData) -> OSStatus in
            let mySelf = Unmanaged<KeyboardListener>.fromOpaque(userData!).takeUnretainedValue()
            mySelf.correctionHandler()
            return noErr
        }, 1, &eventType, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), &eventHandler)
    }
    
    private func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
    }
    
    private func removeEventHandler() {
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }
    
    // Static function to create a FourCharCode from a String
    private static func signatureFrom(string: String) -> FourCharCode {
        var result: FourCharCode = 0
        if let data = string.data(using: .macOSRoman, allowLossyConversion: true) {
            for i in 0..<min(4, data.count) {
                result |= FourCharCode(data[i]) << (8 * (3 - i))
            }
        }
        return result
    }
}
