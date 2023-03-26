//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Megan Teoh-John on 23/01/2023.
//

import SwiftUI

struct SwiftUIView: View {
    
    enum FF{
        case dec
    }
    
    @State var editUB = false
    @State var editLB = false
    
    @State private var UB = ""
    @State private var LB = ""
    
    @FocusState private var focusedField: FF?

    
    @ObservedObject var data = Temperature()
    //data.data.data.data.upperBound
    //data.data.lowerBound
    
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
                
                
                Text("Tap to adjust upper and lower limits")
                    .foregroundColor(.black)
                
                if(showWarning){
                    
                    Text("Upper Bound > Lower Bound ")
                        .foregroundColor(.red)
                }
                else{
                    
                        Text(".....")
                        .foregroundColor(.white)
                }
                

               // Spacer()
                        
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
                    .background(Gradient(colors: [Color.cyan, Color.blue]))
                    .cornerRadius(10)
                    .padding()
                    
                }
                
                //edit screen
                if editUB {
                    
                    VStack{
                        
                        HStack{
                            
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
                                .toolbar {
                                    ToolbarItem(placement: .keyboard) {
                                        
                                        Button("Done") {
                                            if ( Double(LB) ?? data.lowerBound < data.upperBound)
                                            {
                                                data.lowerBound = Double(LB) ?? data.lowerBound
                                            }
                                            
                                            focusedField = nil
                                            editLB = false
                                        }
                                    }
                                }
                                

                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                        
                        Button("Done") {

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
                    .background(Gradient(colors: [Color.cyan, Color.blue]))
                    .cornerRadius(10)
                    .padding()
                    
                }
                
                
            
                //edit screen
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
                                .toolbar {
                                    ToolbarItem(placement: .keyboard) {
                                        Button("Done") {
                                            if ( Double(LB) ?? data.lowerBound < data.upperBound)
                                            {
                                                data.lowerBound = Double(LB) ?? data.lowerBound
                                            }
                                            
                                            focusedField = nil
                                            editLB = false
                                        }
                                    }
                                }
                                }
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                        
                        Button("Done") {
                            
                            

                            if ( Double(LB) ?? data.lowerBound < data.upperBound)
                            {
                                data.lowerBound = Double(LB) ?? data.lowerBound
                                editLB = false
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
                
                Spacer()
                
            }
            
          
            
            
        }
        
        .onTapGesture {
            self.focusedField = nil
        }

    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

