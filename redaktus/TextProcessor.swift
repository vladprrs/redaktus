//
//  TextProcessor.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

class TextProcessor {

    // Function to correct grammar in a given text
    func correctGrammar(in text: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Use the OpenAIClient to send the text for correction
        OpenAIClient.shared.sendGrammarCorrectionRequest(text: text) { result in
            switch result {
            case .success(let correctionResponse):
                // Assuming the API response includes a corrected text, otherwise adjust accordingly.
                // We just take the first choice for simplicity.
                if let correctedText = correctionResponse.choices.first?.text {
                    completion(.success(correctedText))
                } else {
                    completion(.failure(AppError.processingError(reason: "No correction received.")))
                }
            case .failure(let error):
                // Handle the error
                ErrorHandler.handleError(error)
                completion(.failure(error))
            }
        }
    }

    // Add more text processing methods as needed
}
