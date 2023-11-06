//
//  TextReplacementService.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Cocoa

class TextReplacementService {
    static let shared = TextReplacementService()
    private init() {}  // Singleton pattern

    func replaceSelectedText(with correctedText: String) {
        let systemEvents = AXUIElementCreateSystemWide()
        
        var focusedWindow: AnyObject?
        AXUIElementCopyAttributeValue(systemEvents, kAXFocusedWindowAttribute as CFString, &focusedWindow)
        guard let focusedElement = focusedWindow as! AXUIElement? else {
            print("Failed to get focused window.")
            return
        }

        var value: AnyObject?
        AXUIElementCopyAttributeValue(focusedElement, kAXSelectedTextRangeAttribute as CFString, &value)
        guard let axValue = value as! AXValue?, AXValueGetType(axValue) == .cfRange else {
            print("Failed to get selected text range.")
            return
        }

        var selectedTextRange = CFRange()
        let rangeSuccess = AXValueGetValue(axValue, .cfRange, &selectedTextRange)
        guard rangeSuccess else {
            print("Failed to get selected text range.")
            return
        }

        let newRangeValue = AXValueCreate(.cfRange, &selectedTextRange)
        AXUIElementSetAttributeValue(focusedElement, kAXSelectedTextRangeAttribute as CFString, newRangeValue!)
        
        AXUIElementSetAttributeValue(focusedElement, kAXSelectedTextAttribute as CFString, correctedText as CFTypeRef)
        print("Selected text replaced.")
    }
}

