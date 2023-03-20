//
//  ContentView.swift
//  WeatherApp
//
//  Created by Megan Teoh-John on 15/11/2022.
//

import Combine
import SwiftUI
import UIKit

class Temperature: ObservableObject {
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func check(_ sender: Any) {
        print(temp)
    }
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var t = temp
    
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
    
    init() {
        self.lowerBound = UserDefaults.standard.double(forKey: "lowerTemp")
        self.upperBound = UserDefaults.standard.double(forKey: "upperTemp")
    }
    //the ideal temperature that we want set up
}

struct ContentView: View {
    @StateObject var data = Temperature()
    var body: some View {
        storyboardview().edgesIgnoringSafeArea(.all);
    }
}

struct MainPage: View{
    @StateObject var temp = Temperature()
    var diff:Double {
        return temp.t - Double(temp.lowerBound)
    }
    
    var body: some View{
        
        ZStack {
            VStack{
                Spacer()
                Text("Current Temperature")
                    .font(.title)
                    .foregroundColor(Color.black)
                Text("\(temp.t) ºC")
                    .font(.system(size: 100))
                    .foregroundColor(Color.black)
                Spacer()
                    .frame(height: 80)
                Text("Deviation")
                    .font(.title)
                    .foregroundColor(Color.black)
                Text("\(diff) ºC")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                // Text(String(temp.ideal) + "ºC")
                Spacer()
            }
        }
    }
}

struct Settings: View{
    
    @ObservedObject var temp = Temperature()
    
    var body: some View{
        
        ZStack {
            
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("Upper Bound")
                    .font(.title)
                    .foregroundColor(Color.white)
                HStack{
                    Button(action:{
                        temp.upperBound -= 1
                    }){
                        Image(systemName:"arrow.left")
                    }
                    
                    VStack{
                        
                        Text(" \(temp.upperBound) ºC")
                            .font(.largeTitle)
                            .colorInvert()
                    }
                    
                    Button(action:{
                        temp.upperBound += 1
                    }){
                        Image(systemName:"arrow.right")
                    }
                }
                
                
                Spacer()
                    .frame(height: 80)
                
                Text("Lower Bound")
                    .font(.title)
                    .colorInvert()
                
                
                HStack{
                    
                    Button(action:{temp.lowerBound -= 1}){
                        Image(systemName:"arrow.left")
                        
                    }
                    
                    VStack{
                        
                        Text(String(temp.lowerBound) + "ºC")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                    }
                    
                    Button(action:{temp.lowerBound += 1}){
                        Image(systemName:"arrow.right")
                        
                    }
                    
                }
                
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

struct storyboardview: UIViewControllerRepresentable{
    
    func makeUIViewController(context content: Context) -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        
        
    }
}

