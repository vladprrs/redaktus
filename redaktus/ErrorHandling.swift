//
//  ErrorHandling.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation

// Define the error types that your application can throw.
enum AppError: Error {
    case networkError(description: String)
    case processingError(reason: String)
    case apiError(code: Int, message: String)
    case internalError(message: String)
    case userPreferencesError(reason: String) // Added new error type for user preferences issues
    case authenticationError // Added new error type for authentication issues
}

// Extend the error types with custom descriptions.
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let description):
            return NSLocalizedString("Network error: \(description)", comment: "")
        case .processingError(let reason):
            return NSLocalizedString("Processing error: \(reason)", comment: "")
        case .apiError(let code, let message):
            return NSLocalizedString("API error \(code): \(message)", comment: "")
        case .internalError(let message):
            return NSLocalizedString("Internal error: \(message)", comment: "")
        case .userPreferencesError(let reason):
            return NSLocalizedString("Preferences error: \(reason)", comment: "")
        case .authenticationError:
            return NSLocalizedString("Authentication failed. Please check your credentials.", comment: "")
        }
    }
}


// Utility class for handling errors throughout the app.
class ErrorHandler {
    static func handleError(_ error: Error) {
        // Here, you could handle different errors accordingly, for instance:
        switch error {
        case let appError as AppError:
            print("AppError occurred: \(appError.localizedDescription)")
            // You can add more specific error handling for different AppError cases here
        default:
            print("Unknown Error occurred: \(error.localizedDescription)")
        }
        
        // This could be extended to include UI handling, such as presenting alerts.
    }
}
