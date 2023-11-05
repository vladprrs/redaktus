//
//  ClipboardManager.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Cocoa

class ClipboardManager {
    
    static let shared = ClipboardManager()
    private let textProcessor = TextProcessor()
    private init() {} // Private initialization to ensure singleton instance
    
    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    func readFromClipboard() -> String? {
        let pasteboard = NSPasteboard.general
        return pasteboard.string(forType: .string)
    }
    
    // Example of a new method that corrects the grammar of the text in the clipboard.
    func correctGrammarInClipboard(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let text = readFromClipboard() else {
            completion(.failure(AppError.internalError(message: "No text found in clipboard.")))
            return
        }
        
        textProcessor.correctGrammar(in: text) { [weak self] result in
            switch result {
            case .success(let correctedText):
                self?.copyToClipboard(correctedText)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // ...existing methods for handling rich text or other types...
}
