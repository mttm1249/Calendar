//
//  Notifications.swift
//  Calendar
//
//  Created by Денис on 21.06.2022.
//

import UIKit
import UserNotifications

class Notifications: UNNotificationServiceExtension, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let userDefaults = UserDefaults(suiteName: "group.mttm1249.calendar")

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationText: String, hours: Int, minutes: Int, year: Int, month: Int, day: Int, identifier: String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        var count: Int = userDefaults?.value(forKey: "count") as! Int
        
        content.title = "Напоминание!"
        content.body =  notificationText
        content.sound = UNNotificationSound.default
        content.badge = count as NSNumber
        count = count + 1
        userDefaults?.set(count, forKey: "count")
        content.categoryIdentifier = userAction
        
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
                                Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
        
}
