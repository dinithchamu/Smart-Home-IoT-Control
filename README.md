# IoT Smart Home Control System (ESP32 + Flutter + Firebase)

This project is a real-time Smart Home solution that allows users to control household appliances using a cross-platform mobile application. It features a seamless integration between hardware and software using the power of Firebase Realtime Database.

## Project Overview
Currently, the system is configured as a **prototype using 4 LEDs** to demonstrate the switching logic. However, the design is fully scalable and can be upgraded by connecting a **4-Channel Relay Module** to control high-voltage appliances like a Fridge, Fan, and Lights.

### Tech Stack
* **Microcontroller:** ESP32 (DOIT DevKit V1)
* **Mobile App:** Flutter (Dart)
* **Backend:** Firebase Realtime Database
* **Firmware:** C++ (Arduino Framework with PlatformIO)

## Mobile App Features
* **Real-time Synchronization:** Status updates instantly across devices.
* **Device Dashboard:** A clean GridView UI to control 4 different appliances.
* **Visual Feedback:** Interactive icons and cards that change color based on device status.

## Hardware Configuration
The ESP32 is connected to the output pins as follows:
* **Light 1:** GPIO 2 (D2)
* **Light 2:** GPIO 4 (D4)
* **Fridge:** GPIO 5 (D5)
* **Fan:** GPIO 18 (D18)

*Note: The code is optimized for **Active-Low Relay Modules** to ensure safety during system startup.*

## Project Structure
* `Smart_Home_App/` - Contains the Flutter mobile application code.
* `ESP32_Firmware/` - Contains the ESP32 C++ source code and PlatformIO configuration.

## How to Setup
1.  **Firebase:** Create a Firebase project and enable Realtime Database.
2.  **App:** Replace placeholders in `lib/firebase_options.dart` with your Firebase API keys.
3.  **Firmware:** Update `WIFI_SSID`, `WIFI_PASSWORD`, and `FIREBASE_AUTH` in `main.cpp`.
4.  **Hardware:** Connect the ESP32 to a 4-channel relay or LEDs as per the pinout above.

---
*Developed as an IoT exploration project to master Hardware-Software integration.*