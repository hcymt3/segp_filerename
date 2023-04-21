//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Megan Teoh-John on 15/11/2022.
//

import SwiftUI
import FirebaseCore

@main
struct TempControllerApplication: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let contentV = ContentView()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Register for remote notifications
                UIApplication.shared.registerForRemoteNotifications()

                // Set the UNUserNotificationCenter delegate
                UNUserNotificationCenter.current().delegate = self

        return true
    }
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           // Show the notification alert and badge
           completionHandler([.alert, .sound])
       }

       // Handle notification events while the app is in the background
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           // Handle the notification
           completionHandler()
       }

}
