//
//  HotKeyManager.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation
import Carbon.HIToolbox.Events

// Extension to convert a String to OSType
extension OSType {
    static func from(string: String) -> OSType {
        precondition(string.count == 4, "String must be exactly 4 characters to convert to OSType")
        return string.utf16.reduce(0) { ($0 << 8) + OSType($1) }
    }
}

class HotKeyManager {
    var hotKeyRef: EventHotKeyRef?
    var hotKeyID: EventHotKeyID
    var isRegistered: Bool = false
    
    init(signatureString: String) {
        let signature = OSType.from(string: signatureString)
        self.hotKeyID = EventHotKeyID(signature: signature, id: UInt32(1))
    }
    
    func registerHotKey(keyCode: UInt32, modifierFlags: UInt32) {
        if isRegistered {
            print("HotKey is already registered.")
            return
        }
        
        let status = RegisterEventHotKey(keyCode, modifierFlags, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        
        if status == noErr {
            isRegistered = true
            print("HotKey registered successfully.")
        } else {
            print("Failed to register HotKey with error: \(status).")
        }
    }
    
    func unregisterHotKey() {
        if !isRegistered || hotKeyRef == nil {
            print("HotKey is not registered.")
            return
        }
        
        let status = UnregisterEventHotKey(hotKeyRef)
        
        if status == noErr {
            isRegistered = false
            print("HotKey unregistered successfully.")
        } else {
            print("Failed to unregister HotKey with error: \(status).")
        }
    }
    
    deinit {
        unregisterHotKey()
    }
}
