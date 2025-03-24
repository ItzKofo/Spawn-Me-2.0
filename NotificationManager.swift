// NotificationManager.swift
// Handles all notification-related functionality for the app
// Including scheduling, permissions, and delegate methods
// Created by @d7c3g6

import Foundation
import UserNotifications

// MARK: - Notification Model
/// Basic structure for notification data
struct Notification {
    let title: String      // Title of the notification
    let message: String    // Main content/body of the notification
    let delay: TimeInterval // Time delay before showing the notification
}

// MARK: - NotificationManager
/// Singleton class to manage all notification operations
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    // Shared instance for singleton pattern
    static let shared = NotificationManager()
    
    // Private initializer to ensure singleton pattern
    override private init() {
        super.init()
        // Set up notification delegate and request permissions
        UNUserNotificationCenter.current().delegate = self
        requestAuthorization()
    }
    
    // MARK: - Authorization
    /// Request permission from user to send notifications
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    // MARK: - Notification Scheduling
    /// Schedule an immediate notification (with minimal delay)
    /// - Parameters:
    ///   - title: The title of the notification
    ///   - message: The body text of the notification
    func sendImmediateNotification(title: String, message: String) {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        // Create trigger with minimal delay (1 second)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create and schedule the notification request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling immediate notification: \(error)")
            } else {
                print("Immediate notification scheduled!")
            }
        }
    }
    
    /// Schedule a delayed notification
    /// - Parameters:
    ///   - title: The title of the notification
    ///   - message: The body text of the notification
    ///   - delay: Time interval to wait before showing the notification
    func sendDelayedNotification(title: String, message: String, delay: TimeInterval) {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        // Create trigger with specified delay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        // Create and schedule the notification request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling delayed notification: \(error)")
            } else {
                print("Delayed notification scheduled!")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate Methods
    /// Handle notification presentation when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Allow notification to show banner and play sound even when app is in foreground
        completionHandler([.banner, .sound])
    }
    
    /// Handle notification response when user taps on notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap here if needed
        completionHandler()
    }
}
