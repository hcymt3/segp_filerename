# REMOTE REACTION MONITORING

This software contains the basic set up for remote montioring of temperature sensitive reactions. 

## COMPONENTS

Arduino Temperature Controller (Written in C++)
iOS App (Writen in Swift)

# ARDUINO 

Download the IDE here: https://www.arduino.cc/en/software

In order for this program to work, the following components are needed:

Arduino Uno Wifi Rev2
K Type Thermocouple
MAX6675 Amplifier
PTC Heating Plate
Relay
I2C LCD screen
Breadboard
Male to male jumper wires
Male to female jumper wires

##Wire Connection
Connect voltage and ground pins to the respective pins. Use breadboard to extend the number of VCC and GND pins
MAX6675 Amplifier : SCK needs a SPI clock pin, CS needs SPI data pin, SO needs a digital pin
I2C LCD : Connect the SDA and SCL pins accordingly to the matching pin on the Arduino
Relay : Connect IN to an analogue pin

After assembling the components together, load the code provided to the aruino.

## Changes to be made:

- Match the relay pin in the code to the pin used in your hardware set up
- Change the WiFi details to match the username and password of the WiFi available on site
- Match the link of the database to your own firebase data.


# iOS App

Download the IDE here: https://developer.apple.com/xcode/
Note that only updated macOS systems can run Xcode

Load the files provided in the IDE. There are two ways to run the program
- use the built in simulator 
- connect an iPhone (make sure developer mode is switched on) to the laptop/computer and 










