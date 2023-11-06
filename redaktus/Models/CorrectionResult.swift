//
//  CorrectionResult.swift
//  redaktus
//
//  Created by Владислав Прищепов on 06.11.2023.
//

import Foundation

struct CorrectionResult: Codable {
    let correctedText: String
    
    enum CodingKeys: String, CodingKey {
        case correctedText = "choices" // Assuming the corrected text comes under 'choices' in the JSON response
    }
    
    // Custom decoder to handle parsing of nested data if necessary
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var choicesContainer = try container.nestedUnkeyedContainer(forKey: .correctedText)
        let firstChoice = try choicesContainer.nestedContainer(keyedBy: CodingKeys.self)
        correctedText = try firstChoice.decode(String.self, forKey: .correctedText)
    }
    
    // Encoder isn't necessary unless we're sending data back, but Codable requires it
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(correctedText, forKey: .correctedText)
    }
}

