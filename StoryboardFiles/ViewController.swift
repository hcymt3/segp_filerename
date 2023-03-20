//  ViewController.swift, is the main view controller of the app
//  ArduinoPID
//  Created by Asdaq on 2/20/23.
//

import UIKit
import Firebase
import SwiftUI
import QuartzCore


var ref:DatabaseReference!
var ub = Double() //Stores the upperBound value
var lb = Double() //Stores the lowerBound alue
var temp = Double() //Variable to store the current temp

class ViewController: UIViewController {
    
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @ObservedObject var data = Temperature()
    
    //Settings button that takes you to the settings screen
    @IBAction func buttonSettings(_ sender: Any){
        _ = SwiftUIView()
        let hostingController = UIHostingController(rootView: SwiftUIView())
        present(hostingController, animated: true)
    }

    
    //Checks notification permissions
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.4, blue: 1.0, alpha: 1).cgColor,
            UIColor.systemMint.cgColor
        ]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)


        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
        }
        
        //Database initialization
        var databaseHandle:DatabaseHandle
        ref = Database.database(url:"https://segp-a1804-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        databaseHandle = (ref?.child("Thermocouple/temperature").observe(.childAdded, with: { snapshot in
            
            if let doubleValue = snapshot.value as? Double {
                temp = doubleValue
                self.currentTempLabel.text = ("\(temp)")
                
                if let lowerTemp = UserDefaults.standard.object(forKey: "lowerTemp") as? Double {
                    lb = lowerTemp
                }
                if let upperTemp = UserDefaults.standard.object(forKey: "upperTemp") as? Double {
                    ub = upperTemp
                }
                
                //if temp is greater than the upper bound
                if temp > ub {
                    self.currentTempLabel.textColor = UIColor.red //Change label color to red
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Temperature Alert"
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "customnotification.mp3"))
                    content.body = "The temperature has exceeded the upper bound."
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Set the notification trigger
                    let request = UNNotificationRequest(identifier: "temperatureAlert", content: content, trigger: trigger) // Create the request for the notification
                    // Schedule the notification with the notification center
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error adding notification: \(error.localizedDescription)")
                        } else {
                            print("Notification added successfully.")
                        }
                    }
                }
                
                //if temp is in range
                else if temp <= ub && temp >= lb {
                    self.currentTempLabel.textColor = UIColor(red: 0.92, green: 0.90, blue: 0.85, alpha: 1.00)
                }
                
                //if temp is below lower bound
                else {
                    self.currentTempLabel.textColor = UIColor.blue
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Temperature Alert"
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "customnotification.mp3"))
                    content.body = "The temperature has exceeded the lower bound."
                    // Set the notification trigger
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    // Create the request for the notification
                    let request = UNNotificationRequest(identifier: "temperatureAlert", content: content, trigger: trigger)
                    // Schedule the notification with the notification center
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error adding notification: \(error.localizedDescription)")
                        }
                        else {
                            print("Notification added successfully.")
                        }}
                }
            }
            else {
                print("Failed to read integer value from database")
                self.currentTempLabel.text = ("Error in reading temperature from the database")
            }
        }))!
    }
}


