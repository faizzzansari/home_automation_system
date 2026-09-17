#define ENABLE_DEBUG

#include <WiFi.h>
#include "BluetoothSerial.h"
#include "SinricPro.h"
#include "SinricProSwitch.h"

BluetoothSerial SerialBT;

// ===== WiFi Credentials (DEMO) =====
#define WIFI_SSID     "YOUR_WIFI_NAME"
#define WIFI_PASS     "YOUR_WIFI_PASSWORD"

// ===== Sinric Pro Credentials (DEMO) =====
#define APP_KEY       "YOUR_APP_KEY"
#define APP_SECRET    "YOUR_APP_SECRET"

// ===== Device IDs (DEMO) =====
#define DEVICE_ID_1   "DEVICE_ID_1" // Bulb 1
#define DEVICE_ID_2   "DEVICE_ID_2" // Bulb 2
#define DEVICE_ID_3   "DEVICE_ID_3" // Tube Light
#define DEVICE_ID_4   "DEVICE_ID_4" // Charging Socket

// ===== Relay Pins (LOW level trigger) =====
int relayPins[4] = {33, 25, 26, 27};

// ===== Relay Control =====
void setRelay(int relay, bool state) {
  digitalWrite(relayPins[relay], state ? LOW : HIGH);

  String feedback = "STATE:";
  feedback += String(relay + 1);
  feedback += state ? ":ON" : ":OFF";

  SerialBT.println(feedback);
}

// ===== Sinric Callback =====
bool onPowerState(const String &deviceId, bool &state) {

  if (deviceId == DEVICE_ID_1) setRelay(0, state);
  else if (deviceId == DEVICE_ID_2) setRelay(1, state);
  else if (deviceId == DEVICE_ID_3) setRelay(2, state);
  else if (deviceId == DEVICE_ID_4) setRelay(3, state);

  return true;
}

void setup() {
  Serial.begin(115200);

  // Relay setup
  for (int i = 0; i < 4; i++) {
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], HIGH); // OFF
  }

  // Bluetooth
  SerialBT.begin("ESP32_Home_Control");

  // WiFi Connection
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  unsigned long startAttemptTime = millis();

  while (WiFi.status() != WL_CONNECTED &&
         millis() - startAttemptTime < 10000) {
    delay(500);
  }

  // ===== SinricPro Device Setup =====
  SinricProSwitch &sw1 = SinricPro[DEVICE_ID_1];
  SinricProSwitch &sw2 = SinricPro[DEVICE_ID_2];
  SinricProSwitch &sw3 = SinricPro[DEVICE_ID_3];
  SinricProSwitch &sw4 = SinricPro[DEVICE_ID_4];

  sw1.onPowerState(onPowerState);
  sw2.onPowerState(onPowerState);
  sw3.onPowerState(onPowerState);
  sw4.onPowerState(onPowerState);

  SinricPro.begin(APP_KEY, APP_SECRET);
  SinricPro.restoreDeviceStates(true);
}

void loop() {

  // Mode indication
  if (WiFi.status() == WL_CONNECTED) {
    SerialBT.println("MODE:CLOUD");
  } else {
    SerialBT.println("MODE:BT");
  }

  // Auto reconnect WiFi
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi Lost! Reconnecting...");
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    delay(5000);
  }

  SinricPro.handle();

  // ===== Bluetooth Control =====
  if (SerialBT.available()) {
    String cmd = SerialBT.readStringUntil('\n');
    cmd.trim();

    if (cmd == "ON1") setRelay(2, true);
    else if (cmd == "OFF1") setRelay(2, false);
    else if (cmd == "ON2") setRelay(0, true);
    else if (cmd == "OFF2") setRelay(0, false);
    else if (cmd == "ON3") setRelay(1, true);
    else if (cmd == "OFF3") setRelay(1, false);
    else if (cmd == "ON4") setRelay(3, true);
    else if (cmd == "OFF4") setRelay(3, false);
  }
}



// #define ENABLE_DEBUG

// #include <WiFi.h>
// #include "BluetoothSerial.h"
// #include "SinricPro.h"
// #include "SinricProSwitch.h"

// BluetoothSerial SerialBT;

// // ===== WiFi Credentials =====
// #define WIFI_SSID     "Faiz"
// #define WIFI_PASS     "Faiz@123"

// // ===== Sinric Pro Credentials =====
// #define APP_KEY       "ea8f86aa-1769-4789-81e6-0e4d4d977250"
// #define APP_SECRET    "eb55a33e-8401-495d-b5aa-83df294874f2-0beb29f5-115a-444c-8227-beddde388f07"

// // ===== Device IDs =====
// #define DEVICE_ID_1   "696e26b92c0599192ae2ef2b" // bulb 1
// #define DEVICE_ID_2   "696e26b92c0599192ae2ef2b" // Bulb 2
// #define DEVICE_ID_3   "696e263f40cb098d90c26034" // Tube Light 
// #define DEVICE_ID_4   "69b778badafb005af4d5d0ad" // Charging Socket

// // ===== Relay Pins (LOW level trigger) =====
// int relayPins[4] = {33, 25, 26, 27};

// // ===== Relay Control =====
// void setRelay(int relay, bool state) {
//   digitalWrite(relayPins[relay], state ? LOW : HIGH);

//   String feedback = "STATE:";
//   feedback += String(relay + 1);
//   feedback += state ? ":ON" : ":OFF";

//   SerialBT.println(feedback);
// }

// // ===== Sinric Callback =====
// bool onPowerState(const String &deviceId, bool &state) {

//   if (deviceId == DEVICE_ID_1) setRelay(0, state);
//   if (deviceId == DEVICE_ID_2) setRelay(1, state);
//   if (deviceId == DEVICE_ID_3) setRelay(2, state);
//   if (deviceId == DEVICE_ID_4) setRelay(3, state);

//   return true;
// }

// void setup() {
//   Serial.begin(115200);

//   // Relay setup
//   for (int i = 0; i < 4; i++) {
//     pinMode(relayPins[i], OUTPUT);
//     digitalWrite(relayPins[i], HIGH); // OFF
//   }

//   // Bluetooth
//   SerialBT.begin("ESP32_Home_Control");

//   // WiFi
//   WiFi.begin(WIFI_SSID, WIFI_PASS);
//   unsigned long startAttemptTime = millis();
//   while (WiFi.status() != WL_CONNECTED &&
//        millis() - startAttemptTime < 10000) {
//   delay(500);
//   }

//   // ===== SinricPro device objects (THIS FIXES YOUR ERROR) =====
//   SinricProSwitch &sw1 = SinricPro[DEVICE_ID_1];
//   SinricProSwitch &sw2 = SinricPro[DEVICE_ID_2];
//   SinricProSwitch &sw3 = SinricPro[DEVICE_ID_3];
//   SinricProSwitch &sw4 = SinricPro[DEVICE_ID_4];

//   sw1.onPowerState(onPowerState);
//   sw2.onPowerState(onPowerState);
//   sw3.onPowerState(onPowerState);
//   sw4.onPowerState(onPowerState);

//   SinricPro.begin(APP_KEY, APP_SECRET);
//   SinricPro.restoreDeviceStates(true);
// }

// void loop() {
//   if (WiFi.status() == WL_CONNECTED) {
//   SerialBT.println("MODE:CLOUD");
//   } else {
//   SerialBT.println("MODE:BT");
//   }
//   if (WiFi.status() != WL_CONNECTED) {
//   Serial.println("WiFi Lost! Reconnecting...");
//   WiFi.begin(WIFI_SSID, WIFI_PASS);
//   delay(5000);
//   }
//   SinricPro.handle();

//   // ===== Bluetooth Control =====
//   if (SerialBT.available()) {
//     String cmd = SerialBT.readStringUntil('\n');
//     cmd.trim();

//     if (cmd == "ON1") setRelay(2, true);
//     else if (cmd == "OFF1") setRelay(2, false);
//     else if (cmd == "ON2") setRelay(0, true);
//     else if (cmd == "OFF2") setRelay(0, false);
//     else if (cmd == "ON3") setRelay(1, true);
//     else if (cmd == "OFF3") setRelay(1, false);
//     else if (cmd == "ON4") setRelay(3, true);
//     else if (cmd == "OFF4") setRelay(3, false);
//   }
// }