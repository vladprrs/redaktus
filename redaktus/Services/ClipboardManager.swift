//
//  ClipboardManager.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Cocoa

class ClipboardManager {
    static let shared = ClipboardManager()
    private init() {}  // Singleton pattern

    func readStringFromClipboard() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }
    
    func writeStringToClipboard(_ string: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
    }
}
