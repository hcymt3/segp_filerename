//
//  ContentView.swift
//
//  Created by Megan Teoh-John on 15/11/2022.
//

import Combine
import SwiftUI
import UIKit

// the class Temperature is an ObservableObejct that displays the main screen for the app in SwiftUI
// an Observable Object would constantly refresh and retrieve values if they are updated in the settings page

class Temperature: ObservableObject {
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func check(_ sender: Any) {
        print(temp)
    }
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var t = temp
    
    // gets upperbound and lowerbound values
    
    @Published var upperBound : Double {
        didSet {
            UserDefaults.standard.set(upperBound, forKey: "upperTemp")
            ref.child("upperBound").setValue(upperBound)
        }
    }
    @Published var lowerBound: Double {
        didSet {
            UserDefaults.standard.set(lowerBound, forKey: "lowerTemp")
            ref.child("lowerBound").setValue(lowerBound)
        }
    }
    
    //contains the ideal temperature that we want set up

    init() {
        self.lowerBound = UserDefaults.standard.double(forKey: "lowerTemp")
        self.upperBound = UserDefaults.standard.double(forKey: "upperTemp")
    }
}


//display storyboard view, which is situated in ContentView

struct ContentView: View {
    @StateObject var data = Temperature()
    var body: some View {
        storyboardview().edgesIgnoringSafeArea(.all);
    }
}


//displays the ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MyWarningViewController contains the design and view controller for sending alerts to the home page

struct MyWarningViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        
        // Add warning message to the view controller
        let warningLabel = UILabel()
        warningLabel.text = "Warning: Temperature exceeded ideal value!"
        warningLabel.textAlignment = .center
        viewController.view.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor).isActive = true
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}

// contains the storyboard view to be intergrated in SwfitUI

struct storyboardview: UIViewControllerRepresentable{
    
    func makeUIViewController(context content: Context) -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        
    }
}

