//
//  NotificationManager.swift
//  redaktus
//
//  Created by Владислав Прищепов on 05.11.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // Request permission to show notifications
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    // Schedule a notification
    func scheduleNotification(title: String, body: String, identifier: String = UUID().uuidString) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        // Create the trigger for the notification. In this case, it'll fire immediately.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create the request object.
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the request to the notification center.
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                ErrorHandler.handleError(error)
                // Optionally schedule a notification for the error itself
                self.scheduleErrorNotification(for: error)
            }
        }
    }

    // Handle incoming notification when the app is in the foreground.
    func handleNotificationReceived() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Schedule a notification for an error
    private func scheduleErrorNotification(for error: Error) {
        let title = Constants.ErrorMessages.generalErrorTitle
        let body = error.localizedDescription
        scheduleNotification(title: title, body: body)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // Handle the notification while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Here you can customize what to do when a notification is received while the app is open.
        // You may show an alert, badge, or play a sound.
        completionHandler([.alert, .badge, .sound])
    }
    
    // Handle the user's interaction with the notification (e.g., tapping on it)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // You can determine what to do when the user interacts with the notification (e.g., open a specific view or window)
        
        completionHandler()
    }
}
