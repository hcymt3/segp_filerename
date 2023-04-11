#include "max6675.h"                     //Thermocouple
#include <LiquidCrystal_I2C.h>           //LCD
#include <Firebase_Arduino_WiFiNINA.h>   //Firebase
#include <SPI.h>                         // Wifi
#include <WiFiNINA.h>                    // Wifi

//Firebase
#define FIREBASE_HOST "segp-a1804-default-rtdb.asia-southeast1.firebasedatabase.app"
#define FIREBASE_AUTH "S0zJ0mzZxQKAinFTIzu3IxPMoGnzxguY0gkXORzB"
#define WIFI_SSID "SSID"
#define WIFI_PASSWORD "SSID_Password"

FirebaseData firebaseData;


//WiFi
char ssid[] = "SSID";        // your network SSID (name)
char pass[] = "SSID_Password";    // your network password (use for WPA, or use as key for WEP)
int status = WL_IDLE_STATUS;
WiFiServer server(80);

//LCD
LiquidCrystal_I2C lcd(0x27, 16, 2); 

//Thermocouple
int thermoDO = 4;
int thermoCS = 5;
int thermoCLK = 6;
MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);
String pathThermo = "/Thermocouple"; //Firebase path to temperature
String pathLB = "/lowerBound"; //Firebase path to lower bound
String pathUB = "/upperBound"; //Firebase path to upper bound
String pathHeater = "/Heater";
float lowerBound, upperBound;
String jsonStr;

//Heating Element
const int RELAY_PIN = A5;  // the Arduino pin, which connects to the IN pin of relay

void setup() {

  wifiSetUp(); // Wifi connection
  server.begin(); // start the web server on port 80
  printWifiStatus(); // you're connected now, so print out the status
  
  
  Serial.begin(9600); //Serial Monitor
  Serial.println("MAX6675 test");
  // wait for MAX chip to stabilize
  delay(500);

  lcd.init();           //Turns off screen, resets prev values
  lcd.backlight();      // Turns screen back on after init
  
  // Print a message on both lines of the LCD.
  lcd.setCursor(2,0);   //Set cursor to character 2 on line 0
  lcd.print("Hello world!");
  delay(2000);
  lcd.clear();

//Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASSWORD);
  Firebase.reconnectWiFi(true);

  //Heating Element
  pinMode(RELAY_PIN, OUTPUT);
}

void loop() {
  // basic readout test, just print the current temp to LCD
  lcd.print("C = "); 
  lcd.println(thermocouple.readCelsius());
  digitalWrite(RELAY_PIN, HIGH); // turn on heating element

  float temperature = thermocouple.readCelsius();

    // Send data to Firebase with specific path
    if (Firebase.setFloat(firebaseData, pathThermo + "/temperature/X", temperature)) {
      Serial.println(firebaseData.dataPath() + " = " + temperature);
      Serial.println("in loop fr sending data");

    }
   //Retrieve Lower Bound
  if (Firebase.getFloat(firebaseData, pathLB)){
    // Convert the string to a float
    lowerBound = firebaseData.floatData();
    // Print the value to the serial monitor
    Serial.print("Lower Bound : ");
    Serial.println(lowerBound);
  } else {
    String errorReason = firebaseData.errorReason();
    Serial.print("Failed to get temperature from Firebase: ");
    Serial.println(errorReason);
  }
   //Retrive Upper Bound
  if (Firebase.getFloat(firebaseData, pathUB)){
    // Convert the string to a float
    upperBound = firebaseData.floatData();
    // Print the value to the serial monitor
    Serial.print("Upper Bound : ");
    Serial.println(upperBound);
  } else {
    String errorReason = firebaseData.errorReason();
    Serial.print("Failed to get temperature from Firebase: ");
    Serial.println(errorReason);
  }


if (temperature > upperBound){ //exceed upper temperature limit
  digitalWrite(RELAY_PIN, LOW);  // turn off heating element
  Firebase.setBool(firebaseData, pathHeater, false);
}
if (temperature < lowerBound){ //
  digitalWrite(RELAY_PIN, HIGH); // turn on heating element  
  Firebase.setBool(firebaseData, pathHeater, true);

}

    // Push data using pushJSON
    jsonStr = "{\"X\":" + String(temperature,6) + "}";

    if (Firebase.pushJSON(firebaseData, pathThermo + "/2-pushJSON", jsonStr)) {
      Serial.println(firebaseData.dataPath() + " = " + firebaseData.pushName());
            Serial.println("in JSON loop");

    }
    else {
      Serial.println("Error: " + firebaseData.errorReason());
    }

    Serial.println("passed Firebase");
;
    Serial.println();
    delay(2000);
    lcd.clear();


}

void wifiSetUp(){
//Method for connecting to wifi  
  Serial.begin(9600);      // initialize serial communication
  pinMode(9, OUTPUT);      // set the LED pin mode

  // check for the WiFi module:
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    // don't continue
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) {
    Serial.println("Please upgrade the firmware");
  }

  // attempt to connect to WiFi network:
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   // print the network name (SSID);

    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);
    // wait 10 seconds for connection:
    delay(10000);
  }
}

void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
  // print where to go in a browser:
  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}