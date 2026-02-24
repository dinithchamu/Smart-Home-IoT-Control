#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// 1. WIFI DETAILS - Replace with your credentials
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"

// 2. FIREBASE DETAILS - Replace with your credentials
#define FIREBASE_HOST "YOUR_PROJECT_ID-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "YOUR_FIREBASE_SECRET_KEY" 

// 3. PIN OUTPUTS
#define LIGHT1_PIN 2   // D2
#define LIGHT2_PIN 4   // D4
#define FRIDGE_PIN 5   // D5
#define FAN_PIN    18  // D18


FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// RELAY CONTROL FUNCTION
void updateRelay(String path, int pin) {
  if (Firebase.RTDB.getInt(&fbdo, path)) {
    int status = fbdo.intData();
    
    if (status == 1) {
      digitalWrite(pin, HIGH);
    } else {
      digitalWrite(pin, LOW);
    }
  }
}

void setup() {
  Serial.begin(115200);

  // SET PIN OUTPUTS
  pinMode(LIGHT1_PIN, OUTPUT);
  pinMode(LIGHT2_PIN, OUTPUT);
  pinMode(FRIDGE_PIN, OUTPUT);
  pinMode(FAN_PIN, OUTPUT);

  // START WITH ALL RELAYS OFF
  digitalWrite(LIGHT1_PIN, LOW);
  digitalWrite(LIGHT2_PIN, LOW);
  digitalWrite(FRIDGE_PIN, LOW);
  digitalWrite(FAN_PIN, LOW);

  // CONNECT TO WIFI
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi!");

  // CONNECT TO FIREBASE
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  Serial.println("Firebase Initialized!");
}

void loop() {
  // CHECK FIREBASE FOR UPDATES AND CONTROL RELAYS
  if (Firebase.ready()) {
    updateRelay("/light1_status", LIGHT1_PIN);
    updateRelay("/light2_status", LIGHT2_PIN);
    updateRelay("/fridge_status", FRIDGE_PIN);
    updateRelay("/fan_status", FAN_PIN);
  }
  
  delay(1000); // CHECK FIREBASE EVERY 1 SECOND
}