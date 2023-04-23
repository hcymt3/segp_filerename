//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Megan Teoh-John on 23/01/2023.
//

import SwiftUI

//this file displays the settings menu for the app. Written in SwiftUI
//one section of the code manipulates the upper bound, and the other, the lower bound


struct SwiftUIView: View {
    
    enum FF{
        case dec
    }
    
    //variables to trigger the editing functions
    
    @State var editUB = false
    @State var editLB = false
    
    //showWarning promts user to input the correct conditions (upperbound must be > lowerbound)
    @State var showWarning = false
    
    @State private var UB = "" //Store upperbound
    @State private var LB = "" //Store lowerbound
    
    @FocusState private var focusedField: FF?

    //get the current temperature values
    @ObservedObject var data = Temperature()

    var body: some View{
        
        ZStack {
            
            Color.white.edgesIgnoringSafeArea(.all)
                        
            VStack{
                Spacer()

                //heading
                HStack{
                         
                    Text("Settings")
                        .font(.system(size: 40))
                        .foregroundColor(.black)
                                                                
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                
                //instructions
                Text("Tap to adjust upper and lower limits")
                    .foregroundColor(.black)
                
                //show promt for user to input an appropriate upperbound/lowerbound
                if(showWarning){
                    
                    Text("Upper Bound > Lower Bound ") 
                        .foregroundColor(.red)
                }
                else{
                        Text(".....")
                        .foregroundColor(.white)
                }
                                        
                //UPPER BOUND SETTINGS
                //if no edits are being made                      
                
                if !editUB{ 
                    
                    Button(action: {
                        editUB = true
                        
                    }) {
                        // content of the button
                        HStack{
                            Text("Upper Bound")
                                .foregroundColor(Color.black)
                                .font(.largeTitle)
                            
                            let formattedUpper = String(format: "%.1f", data.upperBound)
                            
                            Spacer()
                            
                            Text(" \(formattedUpper) ºC")
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                        
                        }
                        .padding(EdgeInsets(top: 50, leading: 30, bottom: 50, trailing: 30))
                        
                    }
                    .background(Gradient(colors: [Color.cyan, Color.blue]))
                    .cornerRadius(10)
                    .padding()
                    
                }
                
                //edit screen, to be displayed when user taps on upperbound
                if editUB {
                    
                    VStack{
                        
                        HStack{
                            
                            //Text area and keyboard is digits only
                            TextField("Enter Upper Bound", text: $UB)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(
                                                VStack {
                                                    Spacer()
                                                    Color(UIColor.white)
                                                        .frame(height: 2)
                                                }
                                            )
                                .padding(.horizontal, 60)
                                .focused($focusedField, equals: .dec)
                                .keyboardType(.decimalPad)

                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                        
                        Button("Done") {
                            
                            //if settings inputted by the user does not satisfy the requirements

                            if ( Double(UB) ?? data.upperBound > data.lowerBound)
                            {
                                data.upperBound = Double(UB) ?? data.upperBound
                                editUB = false
                                showWarning = false


                            }
                            else
                            {
                                showWarning = true
                            }


                        }
                        .padding(37)
                                    
                }
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)
                .padding()
    
                }
                
             
                //LOWER BOUND SETTINGS
                //if no edits are being made
                
                if !editLB{ 
                    
                    Button(action: {
                       
                        editLB = true
                        
                    }) {
                        // content of the button
                        HStack{
                            Text("Lower Bound")
                                .foregroundColor(Color.black)
                                .font(.largeTitle)
                            
                            let formattedLower = String(format: "%.1f", data.lowerBound)
                            
                            Spacer()
                            
                            Text(" \(formattedLower) ºC")
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                            

                        }
                        .padding(EdgeInsets(top: 50, leading: 30, bottom: 50, trailing: 30))
                        
                    }
                    .background(Gradient(colors: [Color.cyan, Color.blue]))
                    .cornerRadius(10)
                    .padding()
                    
                }
                
                    
                //edit screen, to be displayed when user taps on lowerbound
                
                if editLB {
                    
                    VStack{
                        
                        HStack{
                            
                            TextField(" Enter Lower Bound", text: $LB)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(
                                                VStack {
                                                    Spacer()
                                                    Color(UIColor.white)
                                                        .frame(height: 2)
                                                }
                                            )
                                .padding(.horizontal, 60)
                                .focused($focusedField, equals: .dec)
                                .keyboardType(.decimalPad)
               
                            }
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                        
                        Button("Done") {
                            
                            //if settings inputted by the user satisfies requirements, save the settings

                            if ( Double(LB) ?? data.lowerBound < data.upperBound)
                            {
                                data.lowerBound = Double(LB) ?? data.lowerBound
                                editLB = false
                                showWarning = false
                                

                            }
                            else
                            {
                                //else show the prompt 
                                showWarning = true
                                
                            }


                        }
                        .padding(37)
                            
                }
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)
                .padding()
    
                }
                
                Spacer()
                
            }
        }
        
        //cause settings display to enable editing
        
        .onTapGesture {
            self.focusedField = nil
        }

    }
}

//display view
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView() 
    }
}
