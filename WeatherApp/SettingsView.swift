//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Megan Teoh-John on 23/01/2023.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State var editUB = false
    @State var editLB = false
    
    @State private var UB = ""
    @State private var LB = ""
    
    @ObservedObject var data = Temperature()
    
    var body: some View{
        
        ZStack {
            
            Color.white
                .edgesIgnoringSafeArea(.all)
                        
            VStack{
                
                //heading
                HStack{
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 40))
                                                        
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Spacer()

                    
                }
                
                Text("Tap to adjust upper and lower limits")
        
                //to separate contents
                Spacer()
                    .frame(height: 80)
                
                
                //UPPER BOUND SETTINGS
                
                if !editUB{ //if no edits are being made
                    
                    Button(action: {
                        //allow user to edit temperature value
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
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .padding(50)
                    
                }
                
                //edit screen
                if editUB {
                    
                    VStack{
                        
                        HStack{
                            
                            TextField(" Enter upperBound", text: $UB)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 60)
                                .keyboardType(.numberPad)
                            
                        }
                        .padding(EdgeInsets(top: 50, leading: 0, bottom: 10, trailing: 0))
                        
                        Button("Done") {
                            
                            if ( Double(UB) ?? data.upperBound > data.lowerBound)
                            {
                                data.upperBound = Double(UB) ?? data.upperBound
                            }
                            
                            editUB = false
                            
                        }
                        .padding(30)
                                    
                }
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .padding(50)
    
                }
            
                                

//                Spacer()
//                    .frame(height: 80)
//
                
                //LOWER BOUND SETTINGS
                
                if !editLB{ //if no edits are being made
                    
                    Button(action: {
                        //allow user to edit temperature value
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
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .padding(50)
                    
                }
                
                //edit screen
                if editLB {
                    
                    VStack{
                        
                        HStack{
                            
                            TextField(" Enter lowerBound", text: $UB)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 60)
                                .keyboardType(.numberPad)
                            
                        }
                        .padding(EdgeInsets(top: 50, leading: 0, bottom: 10, trailing: 0))
                        
                        Button("Done") {
                            
                            if ( Double(LB) ?? data.lowerBound < data.upperBound)
                            {
                                data.lowerBound = Double(LB) ?? data.lowerBound
                            }
                            
                            editLB = false
                            
                        }
                        .padding(30)
                                    
                }
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .padding(50)
    
                }

                
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
