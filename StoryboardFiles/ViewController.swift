//  ViewController.swift, is the main view controller of the app
//  Responsible for connecting to the database and reading current temperature & heater status
//  Responsible for sending notifications when temperature is out of range
//  Created by Asdaq on 2/20/23.

import UIKit
import Firebase
import SwiftUI
import QuartzCore

var ref:DatabaseReference!
var ub = Double() //Stores the upperBound value
var lb = Double() //Stores the lowerBound alue
var temp = Double() //Variable to store the current temp


class ViewController: UIViewController {
    
    @IBOutlet weak var heaterLabel: UILabel!      //Label that displays the current status of the heater
    @IBOutlet weak var currentTempLabel: UILabel! //Label that displays the value of the current temperature
    @ObservedObject var data = Temperature()
    var lowTempNotificationTime: Date?            //Stores last time notification for low temp was sent, so that it isn't repetitive
    var highTempNotificationTime: Date?           //Stores last time notification for low temp was sent, so that it isn't repetitive
    
    //Settings button that takes you to the settings screen
    @IBAction func buttonSettings(_ sender: Any){
        _ = SwiftUIView()
        let hostingController = UIHostingController(rootView: SwiftUIView())
        present(hostingController, animated: true)
    }

    
    //Sets UI background of Main as a gradient color
    //Checks notification permissions
    //Fetches the current temperature value
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.28, green: 0.52, blue: 0.28, alpha: 1.00).cgColor,UIColor(red: 0.47, green: 0.87, blue: 0.47, alpha: 1.00).cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)

        //Pop up asking user to enable notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
        }
        
        //Database initialization
        var databaseHandle:DatabaseHandle
        //Database address
        ref = Database.database(url:"https://segp-a1804-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        //Reading the current temperature value from the database by listening for any changes to the child node
        databaseHandle = (ref?.child("Thermocouple/temperature").observe(.childChanged, with: { snapshot in
            
            if let doubleValue = snapshot.value as? Double {
                temp = doubleValue
                self.currentTempLabel.text = ("\(temp)°C")
                
                //Fetches last lowerbound value from userdefaults
                if let lowerTemp = UserDefaults.standard.object(forKey: "lowerTemp") as? Double {
                    lb = lowerTemp
                }
                //Fetches last upperbound value from userdefaults
                if let upperTemp = UserDefaults.standard.object(forKey: "upperTemp") as? Double {
                    ub = upperTemp
                }
                
                //if temp is greater than the upper bound
                if temp > ub {
                    self.lowTempNotificationTime = Date().addingTimeInterval(-20)//Increasing the time for when the notification was last sent
                    self.currentTempLabel.textColor = UIColor(red: 0.92, green: 0.90, blue: 0.85, alpha: 1.00)
                    
                    //Changing color of background
                    gradientLayer.colors = [
                        UIColor(red: 1, green: 0.0, blue: 0.0, alpha: 1).cgColor,
                        UIColor(red: 1.00, green: 0.41, blue: 0.38, alpha: 1.00).cgColor
                    ]
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Temperature Alert"
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "customnotification.wav"))
                    content.body = "The temperature has exceeded the upper bound."
                    
                    //Setting notification trigger
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    // Create the request for notification
                    let request = UNNotificationRequest(identifier: "temperatureAlert", content: content, trigger: trigger)
                    //Don't schedule notification & return if executed in the last 20 seconds
                    if let highTempNotificationTime = self.highTempNotificationTime, Date().timeIntervalSince(highTempNotificationTime) < 20 {
                        print("Skipping notification because it was already executed recently.")
                        return
                    }
                    // Schedule the notification with the notification center
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error adding notification: \(error.localizedDescription)")
                        } else {
                            print("Notification added successfully.")
                            //Record the time at which notification was executed
                            self.highTempNotificationTime = Date()
                        }
                    }
                }
                
                //if temp is in range
                else if temp <= ub && temp >= lb {
                    self.highTempNotificationTime = Date().addingTimeInterval(-20) //Make notification ready to execute immedately next time
                    self.lowTempNotificationTime = Date().addingTimeInterval(-20)  //Make notification ready to execute immedately next time
                    self.currentTempLabel.textColor = UIColor(red: 0.92, green: 0.90, blue: 0.85, alpha: 1.00)
                    
                    //Changing color of background
                    gradientLayer.colors = [UIColor(red: 0.28, green: 0.52, blue: 0.28, alpha: 1.00).cgColor,UIColor(red: 0.47, green: 0.87,blue: 0.47, alpha: 1.00).cgColor]
                }
                
                //if temp is below lower bound
                else {
                    self.highTempNotificationTime = Date().addingTimeInterval(-20)
                    
                    //Changing color of background
                    self.currentTempLabel.textColor = UIColor(red: 0.92, green: 0.90, blue: 0.85, alpha: 1.00)
                    gradientLayer.colors = [UIColor(red: 0.31, green: 0.47, blue: 0.67, alpha: 1.00).cgColor,
                                            UIColor(red: 0.47, green: 0.68, blue: 0.83, alpha: 1.00).cgColor
                        ]
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Temperature Alert"
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "customnotification.wav"))
                    content.body = "The temperature has exceeded the lower bound."
                    // Set the notification trigger
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    // Create the request for the notification
                    let request = UNNotificationRequest(identifier: "temperatureAlert", content: content, trigger: trigger)
                    // Schedule the notification with the notification center
                    // Check if enough time has passed since the last notification
                    if let lowTempNotificationTime = self.lowTempNotificationTime, Date().timeIntervalSince(lowTempNotificationTime) < 20 {
                        print("Skipping notification because it was already executed recently.")
                        return
                    }

                    // Schedule the notification with the notification center
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error adding notification: \(error.localizedDescription)")
                        } else {
                            print("Notification added successfully.")
                            // Record the time the notification was executed
                            self.lowTempNotificationTime = Date()
                        }
                    }
                }
            }
            else {
                print("Failed to read integer value from database")
                self.currentTempLabel.text = ("ERROR")
            }
        }))!
        
        //Code to display the current heater status, i.e; whether it is off or on
        databaseHandle = ref.child("Heater").observe(.value, with: { snapshot in
                if let heaterValue = snapshot.value as? Bool {
                    if(String(heaterValue) == "false"){
                        self.heaterLabel.text = ("Heater is Off")
                    }
                    else{
                        self.heaterLabel.text = ("Heater is On")
                    }
                } else {
                    print("Failed to read heater status from database")
                }
            })
    }
}


