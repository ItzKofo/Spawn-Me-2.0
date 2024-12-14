// NotificationManager.swift
// by @d7c3g6

import Foundation
import UserNotifications

struct Notification {
    let title: String
    let message: String
    let delay: TimeInterval
}

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func scheduleNotification(notification: Notification) {
        // Požádat o oprávnění
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
                return
            }
            
            if granted {
                // Vytvořit obsah notifikace
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.message
                content.sound = .default
                
                // Nastavení zpoždění
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.delay, repeats: false)
                
                // Vytvořit a přidat notifikaci
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully!")
                    }
                }
            } else {
                print("Notifications permission denied.")
            }
        }
    }
}