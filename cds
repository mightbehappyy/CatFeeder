[33mcommit 692cbf56e6851e3e76cb966ab7afa62542230cf7[m[33m ([m[1;36mHEAD -> [m[1;32mmain[m[33m, [m[1;31morigin/main[m[33m)[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Sat Sep 9 21:21:51 2023 -0300

    Configure mode added, user is able to configure up to 5 alarms and active them, active button is a bit slow

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 5aa6b48..0ae3b1e 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -9,10 +9,17 @@[m
 #define pinChangeModeButton 13[m
 #define pinConfigButton 12[m
 #define pinActiveAlarm 11[m
[32m+[m[32m#define pinActiveConfigModeButton 10[m
 #define bounceTime 50[m
 [m
[31m-unsigned char previousButtonState = "HIGH";[m
[31m-bool buttonState;[m
[32m+[m[32munsigned char previousModeButtonState = HIGH;[m
[32m+[m[32munsigned char previousActiveAlarmButtonState = HIGH;[m
[32m+[m[32munsigned char previousConfigButtonState = HIGH;[m
[32m+[m[32munsigned char previousActiveConfigModeButtonState = HIGH;[m
[32m+[m[32mbool configButtonState;[m
[32m+[m[32mbool activeAlarmButtonState;[m
[32m+[m[32mbool modeButtonState;[m
[32m+[m[32mbool configModeButtonState;[m
 static unsigned long buttonDelay = 0;[m
 [m
 // Initializing LCD, address can change according to the Arduino/display you are using.[m
[36m@@ -21,12 +28,14 @@[m [mLiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
 Alarm alarms[5];[m
 uint8_t currentAlarmIndex = 0;[m
 uint8_t currentModeIndex = 0; [m
[31m-uint8_t portionAmount = 0;    [m
[32m+[m[32muint8_t portionAmount = 0;[m[41m [m
[32m+[m[32mbool configState = false;[m[41m   [m
 [m
 void setup() {[m
   pinMode(pinChangeModeButton, INPUT_PULLUP);[m
   pinMode(pinConfigButton, INPUT_PULLUP);[m
   pinMode(pinActiveAlarm, INPUT_PULLUP);[m
[32m+[m[32m  pinMode(pinActiveConfigModeButton, INPUT_PULLUP);[m
   lcd.init();[m
   lcd.backlight();[m
   lcd.clear();[m
[36m@@ -36,10 +45,17 @@[m [mvoid setup() {[m
 [m
 void loop() {[m
   delay(150);[m
[31m-  handleUserModeChange();[m
[31m-  handleUserConfigChange();[m
[31m-  handleDisplayMode();[m
[31m-  handleUserActiveAlarm();[m
[32m+[m[32m  displayConfigMode();[m
[32m+[m[32m  if (!configState) {[m
[32m+[m[32m    handleUserModeChange();[m
[32m+[m[32m    handleUserConfigChange();[m
[32m+[m[32m    handleDisplayMode();[m
[32m+[m[32m    handleUserActiveAlarm();[m
[32m+[m[32m  } else {[m
[32m+[m[32m    handleUserInputForAlarm();[m
[32m+[m[32m    displayAlarmInfo();[m
[32m+[m[32m  }[m
[32m+[m
 }[m
 [m
 void initializeAlarms() {[m
[36m@@ -61,12 +77,18 @@[m [mvoid displayAlarmInfo() {[m
     lcd.print("Unactive");[m
   }[m
   lcd.setCursor(0, 1);[m
[31m-  lcd.print("Hour: ");[m
   lcd.print(alarms[currentAlarmIndex].getFormattedHour());[m
 [m
[31m-  lcd.setCursor(9, 1);[m
[31m-  lcd.print("Min: ");[m
[32m+[m[32m  lcd.print(":");[m
[32m+[m[41m  [m
   lcd.print(alarms[currentAlarmIndex].getFormattedMinute());[m
[32m+[m
[32m+[m[32m  lcd.setCursor(6,1);[m
[32m+[m[32m  if (configState) {[m
[32m+[m[32m    lcd.print("ConfigMode");[m
[32m+[m[32m  } else {[m
[32m+[m[32m    lcd.print("          ");[m
[32m+[m[32m  }[m
 }[m
 [m
 void displayNextAlarmAndTime() {[m
[36m@@ -102,8 +124,8 @@[m [mvoid handleDisplayMode() {[m
 [m
 void handleUserModeChange() {[m
   if ((millis() - buttonDelay) > bounceTime) {[m
[31m-    buttonState = digitalRead(pinChangeModeButton);    [m
[31m-    if (buttonState == LOW && previousButtonState) {[m
[32m+[m[32m    modeButtonState = digitalRead(pinChangeModeButton);[m[41m    [m
[32m+[m[32m    if (modeButtonState == LOW && previousModeButtonState) {[m
       if (currentModeIndex < 2){[m
         currentModeIndex++;[m
       } else {[m
[36m@@ -117,8 +139,8 @@[m [mvoid handleUserModeChange() {[m
 [m
 void handleUserConfigChange() {[m
   if ((millis() - buttonDelay) > bounceTime) {[m
[31m-    buttonState = digitalRead(pinConfigButton);[m
[31m-     if (buttonState == LOW && previousButtonState) {[m
[32m+[m[32m    configButtonState = digitalRead(pinConfigButton);[m
[32m+[m[32m     if (configButtonState == LOW && previousModeButtonState == HIGH) {[m
       if (currentModeIndex == 1){[m
         if (currentAlarmIndex < 4){[m
           currentAlarmIndex++;[m
[36m@@ -135,17 +157,44 @@[m [mvoid handleUserConfigChange() {[m
       }[m
       buttonDelay = millis();[m
     }[m
[31m-    buttonState = previousButtonState;[m
[32m+[m[32m    configButtonState = previousModeButtonState;[m
   }[m
 }[m
[32m+[m
 void handleUserActiveAlarm() {[m
   if((millis() - buttonDelay) > bounceTime) {[m
[31m-    buttonState = digitalRead(pinActiveAlarm);[m
[31m-    if (buttonState == LOW  && previousButtonState) {[m
[31m-      Serial.print("Active");[m
[32m+[m[32m    activeAlarmButtonState = digitalRead(pinActiveAlarm);[m
[32m+[m[32m    if (activeAlarmButtonState == LOW  && previousActiveAlarmButtonState) {[m
       if (currentModeIndex == 1) {[m
         alarms[currentAlarmIndex].toggleIsAlarmActive();[m
       } [m
     }[m
   }[m
 }[m
[32m+[m[32mvoid displayConfigMode() {[m
[32m+[m[32m  if ((millis() - buttonDelay) > bounceTime) {[m
[32m+[m[32m    configModeButtonState = digitalRead(pinActiveConfigModeButton);[m
[32m+[m[32m    if (configModeButtonState == LOW && previousActiveConfigModeButtonState) {[m
[32m+[m[32m      if (currentModeIndex == 1) {[m
[32m+[m[32m        configState = !configState;[m
[32m+[m[32m        buttonDelay = millis();[m
[32m+[m[32m      }[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid handleUserInputForAlarm() {[m
[32m+[m[32m  if ((millis() - buttonDelay) > bounceTime) {[m
[32m+[m[32m    modeButtonState = digitalRead(pinChangeModeButton);[m
[32m+[m[32m    configButtonState = digitalRead(pinConfigButton);[m
[32m+[m[32m    if (configButtonState == LOW && previousConfigButtonState) {[m
[32m+[m[32m      alarms[currentAlarmIndex].toggleConfigMode();[m
[32m+[m[32m      buttonDelay = millis();[m
[32m+[m[32m    }[m
[32m+[m[32m    if (modeButtonState == LOW && previousModeButtonState) {[m
[32m+[m[32m      alarms[currentAlarmIndex].timeIncrementManager();[m
[32m+[m[32m      buttonDelay = millis();[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[41m+[m

[33mcommit ec9b4de8794214313a16324af9bc284f11dce495[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Sat Sep 9 15:44:49 2023 -0300

    Added active/unactive alarm button

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 5e32f94..5aa6b48 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -8,6 +8,7 @@[m
 [m
 #define pinChangeModeButton 13[m
 #define pinConfigButton 12[m
[32m+[m[32m#define pinActiveAlarm 11[m
 #define bounceTime 50[m
 [m
 unsigned char previousButtonState = "HIGH";[m
[36m@@ -25,6 +26,7 @@[m [muint8_t portionAmount = 0;[m
 void setup() {[m
   pinMode(pinChangeModeButton, INPUT_PULLUP);[m
   pinMode(pinConfigButton, INPUT_PULLUP);[m
[32m+[m[32m  pinMode(pinActiveAlarm, INPUT_PULLUP);[m
   lcd.init();[m
   lcd.backlight();[m
   lcd.clear();[m
[36m@@ -37,6 +39,7 @@[m [mvoid loop() {[m
   handleUserModeChange();[m
   handleUserConfigChange();[m
   handleDisplayMode();[m
[32m+[m[32m  handleUserActiveAlarm();[m
 }[m
 [m
 void initializeAlarms() {[m
[36m@@ -50,6 +53,13 @@[m [mvoid displayAlarmInfo() {[m
   lcd.print("Alarm ");[m
   lcd.print(currentAlarmIndex + 1);[m
 [m
[32m+[m[32m  lcd.setCursor(8, 0);[m
[32m+[m[32m  if (alarms[currentAlarmIndex].getIsAlarmActive()){[m
[32m+[m[32m    lcd.print("Active  ");[m
[32m+[m[32m  } else {[m
[32m+[m
[32m+[m[32m    lcd.print("Unactive");[m
[32m+[m[32m  }[m
   lcd.setCursor(0, 1);[m
   lcd.print("Hour: ");[m
   lcd.print(alarms[currentAlarmIndex].getFormattedHour());[m
[36m@@ -128,3 +138,14 @@[m [mvoid handleUserConfigChange() {[m
     buttonState = previousButtonState;[m
   }[m
 }[m
[32m+[m[32mvoid handleUserActiveAlarm() {[m
[32m+[m[32m  if((millis() - buttonDelay) > bounceTime) {[m
[32m+[m[32m    buttonState = digitalRead(pinActiveAlarm);[m
[32m+[m[32m    if (buttonState == LOW  && previousButtonState) {[m
[32m+[m[32m      Serial.print("Active");[m
[32m+[m[32m      if (currentModeIndex == 1) {[m
[32m+[m[32m        alarms[currentAlarmIndex].toggleIsAlarmActive();[m
[32m+[m[32m      }[m[41m [m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m}[m

[33mcommit 825ef34e221ee2f58cea04bf3a9156ca760ea15c[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Sat Sep 9 01:09:03 2023 -0300

    limited portions to up to 5

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 7143b6e..5e32f94 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -33,7 +33,7 @@[m [mvoid setup() {[m
 }[m
 [m
 void loop() {[m
[31m-[m
[32m+[m[32m  delay(150);[m
   handleUserModeChange();[m
   handleUserConfigChange();[m
   handleDisplayMode();[m
[36m@@ -70,7 +70,7 @@[m [mvoid displayNextAlarmAndTime() {[m
 void displayPortionAmount() {[m
   lcd.setCursor(0, 0);[m
   lcd.print(F("Portion size:"));[m
[31m-  lcd.print(" ");[m
[32m+[m[32m  lcd.print(F(" "));[m
   lcd.print(portionAmount);[m
 }[m
 [m
[36m@@ -117,7 +117,11 @@[m [mvoid handleUserConfigChange() {[m
         }[m
        [m
       } else if (currentModeIndex == 2) {[m
[31m-        portionAmount++;[m
[32m+[m[32m        if (portionAmount < 5){[m
[32m+[m[32m          portionAmount++;[m
[32m+[m[32m        } else {[m
[32m+[m[32m          portionAmount = 0;[m
[32m+[m[32m        }[m
       }[m
       buttonDelay = millis();[m
     }[m

[33mcommit 8ecc5e567fb00b1b03a96a0815b396d79d0d62ea[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Sat Sep 9 01:00:26 2023 -0300

    fixed lcd blinking

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 4e1ba45..7143b6e 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -8,8 +8,9 @@[m
 [m
 #define pinChangeModeButton 13[m
 #define pinConfigButton 12[m
[31m-#define bounceTime 25[m
[32m+[m[32m#define bounceTime 50[m
 [m
[32m+[m[32munsigned char previousButtonState = "HIGH";[m
 bool buttonState;[m
 static unsigned long buttonDelay = 0;[m
 [m
[36m@@ -32,11 +33,10 @@[m [mvoid setup() {[m
 }[m
 [m
 void loop() {[m
[31m-  delay(1000);[m
[32m+[m
   handleUserModeChange();[m
   handleUserConfigChange();[m
   handleDisplayMode();[m
[31m-  delay(1000);[m
 }[m
 [m
 void initializeAlarms() {[m
[36m@@ -46,7 +46,6 @@[m [mvoid initializeAlarms() {[m
 }[m
 [m
 void displayAlarmInfo() {[m
[31m-  lcd.clear();[m
   lcd.setCursor(0, 0);[m
   lcd.print("Alarm ");[m
   lcd.print(currentAlarmIndex + 1);[m
[36m@@ -61,7 +60,6 @@[m [mvoid displayAlarmInfo() {[m
 }[m
 [m
 void displayNextAlarmAndTime() {[m
[31m-  lcd.clear();[m
   lcd.setCursor(0, 0);[m
   lcd.print(F("Nxt Alarm:"));[m
 [m
[36m@@ -70,7 +68,6 @@[m [mvoid displayNextAlarmAndTime() {[m
 }[m
 [m
 void displayPortionAmount() {[m
[31m-  lcd.clear();[m
   lcd.setCursor(0, 0);[m
   lcd.print(F("Portion size:"));[m
   lcd.print(" ");[m
[36m@@ -78,6 +75,12 @@[m [mvoid displayPortionAmount() {[m
 }[m
 [m
 void handleDisplayMode() {[m
[32m+[m[32m  static uint8_t previousModeIndex = 255;[m[41m [m
[32m+[m
[32m+[m[32m  if (currentModeIndex != previousModeIndex) {[m
[32m+[m[32m    lcd.clear();[m
[32m+[m[32m    previousModeIndex = currentModeIndex;[m
[32m+[m[32m  }[m
   if (currentModeIndex == 0) {[m
     displayNextAlarmAndTime();[m
   } else if (currentModeIndex == 1) {[m
[36m@@ -89,19 +92,13 @@[m [mvoid handleDisplayMode() {[m
 [m
 void handleUserModeChange() {[m
   if ((millis() - buttonDelay) > bounceTime) {[m
[31m-    buttonState = digitalRead(pinChangeModeButton);[m
[31m-    [m
[31m-    Serial.print("Button State: ");[m
[31m-    Serial.println(buttonState);[m
[31m-    [m
[31m-    if (buttonState == LOW) {[m
[32m+[m[32m    buttonState = digitalRead(pinChangeModeButton);[m[41m    [m
[32m+[m[32m    if (buttonState == LOW && previousButtonState) {[m
       if (currentModeIndex < 2){[m
         currentModeIndex++;[m
       } else {[m
         currentModeIndex = 0;[m
       }[m
[31m-[m
[31m-      Serial.println("Mode Changed!");[m
       buttonDelay = millis();[m
     }[m
     [m
[36m@@ -111,11 +108,7 @@[m [mvoid handleUserModeChange() {[m
 void handleUserConfigChange() {[m
   if ((millis() - buttonDelay) > bounceTime) {[m
     buttonState = digitalRead(pinConfigButton);[m
[31m-    [m
[31m-    Serial.print("Button State: ");[m
[31m-    Serial.println(buttonState);[m
[31m-    [m
[31m-     if (buttonState == LOW) {[m
[32m+[m[32m     if (buttonState == LOW && previousButtonState) {[m
       if (currentModeIndex == 1){[m
         if (currentAlarmIndex < 4){[m
           currentAlarmIndex++;[m
[36m@@ -126,10 +119,8 @@[m [mvoid handleUserConfigChange() {[m
       } else if (currentModeIndex == 2) {[m
         portionAmount++;[m
       }[m
[31m-[m
[31m-      Serial.println("Mode Changed!");[m
       buttonDelay = millis();[m
     }[m
[31m-    [m
[32m+[m[32m    buttonState = previousButtonState;[m
   }[m
 }[m

[33mcommit a1aa5dbc7cd2abd4f2aee7322d423e849012eddb[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Sat Sep 9 00:48:30 2023 -0300

    button change mode and config button added

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 3b66e1a..4e1ba45 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -1,10 +1,18 @@[m
 #include <LiquidCrystal_I2C.h>[m
 #include <Wire.h>[m
 #include "Alarm.cpp" [m
[32m+[m
 #define LCD_ADDRESS 0x3F[m
 #define LCD_COLUMNS 16[m
 #define LCD_ROWS 2[m
 [m
[32m+[m[32m#define pinChangeModeButton 13[m
[32m+[m[32m#define pinConfigButton 12[m
[32m+[m[32m#define bounceTime 25[m
[32m+[m
[32m+[m[32mbool buttonState;[m
[32m+[m[32mstatic unsigned long buttonDelay = 0;[m
[32m+[m
 // Initializing LCD, address can change according to the Arduino/display you are using.[m
 LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
 [m
[36m@@ -14,19 +22,19 @@[m [muint8_t currentModeIndex = 0;[m
 uint8_t portionAmount = 0;    [m
 [m
 void setup() {[m
[32m+[m[32m  pinMode(pinChangeModeButton, INPUT_PULLUP);[m
[32m+[m[32m  pinMode(pinConfigButton, INPUT_PULLUP);[m
   lcd.init();[m
   lcd.backlight();[m
   lcd.clear();[m
   initializeAlarms();[m
[32m+[m[32m  Serial.begin(9600);[m
 }[m
 [m
 void loop() {[m
   delay(1000);[m
[31m-  if (currentModeIndex < 2) {[m
[31m-    currentModeIndex++;[m
[31m-  } else {[m
[31m-    currentModeIndex = 0;[m
[31m-  }[m
[32m+[m[32m  handleUserModeChange();[m
[32m+[m[32m  handleUserConfigChange();[m
   handleDisplayMode();[m
   delay(1000);[m
 }[m
[36m@@ -79,6 +87,49 @@[m [mvoid handleDisplayMode() {[m
   }[m
 }[m
 [m
[31m-void handleUserInput() {[m
[32m+[m[32mvoid handleUserModeChange() {[m
[32m+[m[32m  if ((millis() - buttonDelay) > bounceTime) {[m
[32m+[m[32m    buttonState = digitalRead(pinChangeModeButton);[m
[32m+[m[41m    [m
[32m+[m[32m    Serial.print("Button State: ");[m
[32m+[m[32m    Serial.println(buttonState);[m
[32m+[m[41m    [m
[32m+[m[32m    if (buttonState == LOW) {[m
[32m+[m[32m      if (currentModeIndex < 2){[m
[32m+[m[32m        currentModeIndex++;[m
[32m+[m[32m      } else {[m
[32m+[m[32m        currentModeIndex = 0;[m
[32m+[m[32m      }[m
 [m
[32m+[m[32m      Serial.println("Mode Changed!");[m
[32m+[m[32m      buttonDelay = millis();[m
[32m+[m[32m    }[m
[32m+[m[41m    [m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid handleUserConfigChange() {[m
[32m+[m[32m  if ((millis() - buttonDelay) > bounceTime) {[m
[32m+[m[32m    buttonState = digitalRead(pinConfigButton);[m
[32m+[m[41m    [m
[32m+[m[32m    Serial.print("Button State: ");[m
[32m+[m[32m    Serial.println(buttonState);[m
[32m+[m[41m    [m
[32m+[m[32m     if (buttonState == LOW) {[m
[32m+[m[32m      if (currentModeIndex == 1){[m
[32m+[m[32m        if (currentAlarmIndex < 4){[m
[32m+[m[32m          currentAlarmIndex++;[m
[32m+[m[32m        } else {[m
[32m+[m[32m          currentAlarmIndex = 0;[m
[32m+[m[32m        }[m
[32m+[m[41m       [m
[32m+[m[32m      } else if (currentModeIndex == 2) {[m
[32m+[m[32m        portionAmount++;[m
[32m+[m[32m      }[m
[32m+[m
[32m+[m[32m      Serial.println("Mode Changed!");[m
[32m+[m[32m      buttonDelay = millis();[m
[32m+[m[32m    }[m
[32m+[m[41m    [m
[32m+[m[32m  }[m
 }[m

[33mcommit 252c3c5b167bd054689db1c7e63bd0e825ed82e8[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Fri Sep 8 22:29:27 2023 -0300

    added display mode next Alarm And Time screen and portion configuration

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex a041bc7..3b66e1a 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -1,16 +1,17 @@[m
 #include <LiquidCrystal_I2C.h>[m
 #include <Wire.h>[m
[31m-#include "alarm.cpp"[m
[31m-[m
[32m+[m[32m#include "Alarm.cpp"[m[41m [m
 #define LCD_ADDRESS 0x3F[m
 #define LCD_COLUMNS 16[m
 #define LCD_ROWS 2[m
 [m
[31m-// Initializing LCD, address can change according to the arduino/display you are using.[m
[32m+[m[32m// Initializing LCD, address can change according to the Arduino/display you are using.[m
 LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
 [m
 Alarm alarms[5];[m
 uint8_t currentAlarmIndex = 0;[m
[32m+[m[32muint8_t currentModeIndex = 0;[m[41m [m
[32m+[m[32muint8_t portionAmount = 0;[m[41m    [m
 [m
 void setup() {[m
   lcd.init();[m
[36m@@ -21,18 +22,17 @@[m [mvoid setup() {[m
 [m
 void loop() {[m
   delay(1000);[m
[31m-  displayAlarmInfo();[m
[31m-  delay(1000);[m
[31m-  if(currentAlarmIndex < 4) {[m
[31m-    currentAlarmIndex++;[m
[32m+[m[32m  if (currentModeIndex < 2) {[m
[32m+[m[32m    currentModeIndex++;[m
   } else {[m
[31m-    currentAlarmIndex = 0;[m
[32m+[m[32m    currentModeIndex = 0;[m
   }[m
[32m+[m[32m  handleDisplayMode();[m
   delay(1000);[m
 }[m
 [m
[31m-void initializeAlarms(){[m
[31m-  for(uint8_t i = 0; i < 5; i++) {[m
[32m+[m[32mvoid initializeAlarms() {[m
[32m+[m[32m  for (uint8_t i = 0; i < 5; i++) {[m
     alarms[i] = Alarm();[m
   }[m
 }[m
[36m@@ -50,7 +50,33 @@[m [mvoid displayAlarmInfo() {[m
   lcd.setCursor(9, 1);[m
   lcd.print("Min: ");[m
   lcd.print(alarms[currentAlarmIndex].getFormattedMinute());[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid displayNextAlarmAndTime() {[m
[32m+[m[32m  lcd.clear();[m
[32m+[m[32m  lcd.setCursor(0, 0);[m
[32m+[m[32m  lcd.print(F("Nxt Alarm:"));[m
 [m
[32m+[m[32m  lcd.setCursor(0, 1);[m
[32m+[m[32m  lcd.print(F("Time:"));[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid displayPortionAmount() {[m
[32m+[m[32m  lcd.clear();[m
[32m+[m[32m  lcd.setCursor(0, 0);[m
[32m+[m[32m  lcd.print(F("Portion size:"));[m
[32m+[m[32m  lcd.print(" ");[m
[32m+[m[32m  lcd.print(portionAmount);[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid handleDisplayMode() {[m
[32m+[m[32m  if (currentModeIndex == 0) {[m
[32m+[m[32m    displayNextAlarmAndTime();[m
[32m+[m[32m  } else if (currentModeIndex == 1) {[m
[32m+[m[32m    displayAlarmInfo();[m
[32m+[m[32m  } else {[m
[32m+[m[32m    displayPortionAmount();[m
[32m+[m[32m  }[m
 }[m
 [m
 void handleUserInput() {[m

[33mcommit 08ed0332f7bc7006db6d3688b66122aef8bdbbd9[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Fri Sep 8 15:00:37 2023 -0300

    Added method displayAlarmInfo, it's being tested on the loop mehtod

[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex c8e2ae0..a041bc7 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -6,7 +6,7 @@[m
 #define LCD_COLUMNS 16[m
 #define LCD_ROWS 2[m
 [m
[31m-[m
[32m+[m[32m// Initializing LCD, address can change according to the arduino/display you are using.[m
 LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
 [m
 Alarm alarms[5];[m
[36m@@ -21,7 +21,14 @@[m [mvoid setup() {[m
 [m
 void loop() {[m
   delay(1000);[m
[31m-[m
[32m+[m[32m  displayAlarmInfo();[m
[32m+[m[32m  delay(1000);[m
[32m+[m[32m  if(currentAlarmIndex < 4) {[m
[32m+[m[32m    currentAlarmIndex++;[m
[32m+[m[32m  } else {[m
[32m+[m[32m    currentAlarmIndex = 0;[m
[32m+[m[32m  }[m
[32m+[m[32m  delay(1000);[m
 }[m
 [m
 void initializeAlarms(){[m
[36m@@ -29,3 +36,23 @@[m [mvoid initializeAlarms(){[m
     alarms[i] = Alarm();[m
   }[m
 }[m
[32m+[m
[32m+[m[32mvoid displayAlarmInfo() {[m
[32m+[m[32m  lcd.clear();[m
[32m+[m[32m  lcd.setCursor(0, 0);[m
[32m+[m[32m  lcd.print("Alarm ");[m
[32m+[m[32m  lcd.print(currentAlarmIndex + 1);[m
[32m+[m
[32m+[m[32m  lcd.setCursor(0, 1);[m
[32m+[m[32m  lcd.print("Hour: ");[m
[32m+[m[32m  lcd.print(alarms[currentAlarmIndex].getFormattedHour());[m
[32m+[m
[32m+[m[32m  lcd.setCursor(9, 1);[m
[32m+[m[32m  lcd.print("Min: ");[m
[32m+[m[32m  lcd.print(alarms[currentAlarmIndex].getFormattedMinute());[m
[32m+[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid handleUserInput() {[m
[32m+[m
[32m+[m[32m}[m

[33mcommit be2df045f1f2c96267c9685f401dc3c55bb51a76[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Fri Sep 8 14:37:38 2023 -0300

    added alarm method initializer, user can configure up to 5 alarms

[1mdiff --git a/alarm.cpp b/alarm.cpp[m
[1mindex a3ea087..31aef0e 100644[m
[1m--- a/alarm.cpp[m
[1m+++ b/alarm.cpp[m
[36m@@ -11,9 +11,9 @@[m [mprivate:[m
     char formattedMinute[3];[m
 [m
 public:[m
[31m-    Alarm(uint8_t hour, uint8_t minute) {[m
[31m-        this->alarmHour = hour;[m
[31m-        this->alarmMinute = minute;[m
[32m+[m[32m    Alarm() {[m
[32m+[m[32m        this->alarmHour = 0;[m
[32m+[m[32m        this->alarmMinute = 0;[m
         this->timeUnitIsHour = true;[m
         this->isAlarmActive = false;[m
         updateFormattedHour();[m
[36m@@ -33,7 +33,7 @@[m [mpublic:[m
     }[m
 [m
     bool getIsAlarmActive(){[m
[31m-        return this->isAlarmActive();[m
[32m+[m[32m        return this->isAlarmActive;[m
     }[m
 [m
     uint8_t getAlarmHour() {[m
[36m@@ -45,11 +45,11 @@[m [mpublic:[m
     }[m
 [m
     const char* getFormattedHour() {[m
[31m-        return formattedHour;[m
[32m+[m[32m        return this->formattedHour;[m
     }[m
 [m
     void updateFormattedHour() {[m
[31m-        sprintf(formattedHour, "%02d", this->alarmHour);[m
[32m+[m[32m        sprintf(this->formattedHour, "%02d", this->alarmHour);[m
     }[m
 [m
     const char* getFormattedMinute() {[m
[36m@@ -75,7 +75,7 @@[m [mpublic:[m
     void toggleIsAlarmActive(){[m
         this->isAlarmActive = !this->isAlarmActive;[m
     }[m
[31m-    [m
[32m+[m
     void timeIncrementManager() {[m
         if (getConfigMode()) {[m
             increaseAlarmHour();[m
[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 003b9c3..c8e2ae0 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -9,13 +9,23 @@[m
 [m
 LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
 [m
[32m+[m[32mAlarm alarms[5];[m
[32m+[m[32muint8_t currentAlarmIndex = 0;[m
[32m+[m
 void setup() {[m
   lcd.init();[m
   lcd.backlight();[m
   lcd.clear();[m
[32m+[m[32m  initializeAlarms();[m
 }[m
 [m
 void loop() {[m
   delay(1000);[m
 [m
 }[m
[32m+[m
[32m+[m[32mvoid initializeAlarms(){[m
[32m+[m[32m  for(uint8_t i = 0; i < 5; i++) {[m
[32m+[m[32m    alarms[i] = Alarm();[m
[32m+[m[32m  }[m
[32m+[m[32m}[m

[33mcommit bf11e0abce1f2a9957719f2e3632d8511e1f960b[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Fri Sep 8 14:13:04 2023 -0300

    added isAlarmActive and timeIncrementManager method

[1mdiff --git a/alarm.cpp b/alarm.cpp[m
[1mindex 84cbbba..a3ea087 100644[m
[1m--- a/alarm.cpp[m
[1m+++ b/alarm.cpp[m
[36m@@ -1,74 +1,105 @@[m
 #include <stdio.h>[m
 #include <string.h>[m
[31m-class Alarm{[m
[31m-    private:[m
[31m-        uint8_t alarmHour;[m
[31m-        uint8_t alarmMinute;[m
[31m-        bool timeUnitIsHour;[m
[31m-        char formattedHour[3];[m
[31m-        char formattedMinute[3];[m
[31m-    public:[m
[31m-        Alarm(uint8_t hour, uint8_t minute){[m
[31m-            this->alarmHour = hour;[m
[31m-            this-> alarmMinute = minute;[m
[31m-            this-> timeUnitIsHour = true;[m
[31m-            updateFormattedHour();  [m
[31m-            updateFormattedMinute();[m
[31m-        }[m
[31m-        void setAlarmHour(uint8_t hour){[m
[31m-            this->alarmHour = hour;[m
[31m-        }[m
[31m-        void setAlarmMinute(uint8_t minute){[m
[31m-            this->alarmMinute = minute;[m
[31m-        }[m
[31m-        uint8_t getAlarmHour(){[m
[31m-            return this->alarmHour;[m
[31m-        }[m
[31m-        uint8_t getAlarmMinute(){[m
[31m-            return this->alarmMinute;[m
[31m-        }[m
[31m-        const char* getFormattedHour(){[m
[31m-          return formattedHour;[m
[31m-        }[m
[31m-        void updateFormattedHour(){[m
[31m-          sprintf(formattedHour, "%02d", this->alarmHour);[m
[31m-        }[m
[31m-        const char* getFormattedMinute() {[m
[32m+[m
[32m+[m[32mclass Alarm {[m
[32m+[m[32mprivate:[m
[32m+[m[32m    uint8_t alarmHour;[m
[32m+[m[32m    uint8_t alarmMinute;[m
[32m+[m[32m    bool timeUnitIsHour;[m
[32m+[m[32m    bool isAlarmActive;[m
[32m+[m[32m    char formattedHour[3];[m
[32m+[m[32m    char formattedMinute[3];[m
[32m+[m
[32m+[m[32mpublic:[m
[32m+[m[32m    Alarm(uint8_t hour, uint8_t minute) {[m
[32m+[m[32m        this->alarmHour = hour;[m
[32m+[m[32m        this->alarmMinute = minute;[m
[32m+[m[32m        this->timeUnitIsHour = true;[m
[32m+[m[32m        this->isAlarmActive = false;[m
[32m+[m[32m        updateFormattedHour();[m
[32m+[m[32m        updateFormattedMinute();[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void setAlarmHour(uint8_t hour) {[m
[32m+[m[32m        this->alarmHour = hour;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void setAlarmMinute(uint8_t minute) {[m
[32m+[m[32m        this->alarmMinute = minute;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void setIsAlarmActive(bool isAlarmActive) {[m
[32m+[m[32m        this->isAlarmActive = isAlarmActive;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    bool getIsAlarmActive(){[m
[32m+[m[32m        return this->isAlarmActive();[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    uint8_t getAlarmHour() {[m
[32m+[m[32m        return this->alarmHour;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    uint8_t getAlarmMinute() {[m
[32m+[m[32m        return this->alarmMinute;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    const char* getFormattedHour() {[m
[32m+[m[32m        return formattedHour;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void updateFormattedHour() {[m
[32m+[m[32m        sprintf(formattedHour, "%02d", this->alarmHour);[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    const char* getFormattedMinute() {[m
         return formattedMinute;[m
     }[m
[31m-        void updateFormattedMinute() {[m
[32m+[m
[32m+[m[32m    void updateFormattedMinute() {[m
         sprintf(formattedMinute, "%02d", this->alarmMinute);[m
[31m-    } [m
[31m-        bool isAlarmTimeNow(uint8_t hour, uint8_t minute){[m
[31m-            if(this->alarmHour == hour && this->alarmMinute == minute){[m
[31m-                return true;[m
[31m-            }[m
[31m-            return false;[m
[31m-        }[m
[32m+[m[32m    }[m
 [m
[31m-        bool getConfigMode(){[m
[31m-            return this->timeUnitIsHour;[m
[31m-        }[m
[31m-         void toggleConfigMode(){[m
[31m-            this->timeUnitIsHour = !this->timeUnitIsHour;[m
[32m+[m[32m    bool isAlarmTimeNow(uint8_t hour, uint8_t minute) {[m
[32m+[m[32m        return this->alarmHour == hour && this->alarmMinute == minute;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    bool getConfigMode() {[m
[32m+[m[32m        return this->timeUnitIsHour;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void toggleConfigMode() {[m
[32m+[m[32m        this->timeUnitIsHour = !this->timeUnitIsHour;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void toggleIsAlarmActive(){[m
[32m+[m[32m        this->isAlarmActive = !this->isAlarmActive;[m
[32m+[m[32m    }[m
[32m+[m[41m    [m
[32m+[m[32m    void timeIncrementManager() {[m
[32m+[m[32m        if (getConfigMode()) {[m
[32m+[m[32m            increaseAlarmHour();[m
[32m+[m[32m        } else {[m
[32m+[m[32m            increaseAlarmMinute();[m
         }[m
[31m-        void increaseAlarmHour(){[m
[31m-            if(this->alarmHour == 23){[m
[31m-                this->alarmHour = 0;[m
[31m-                updateFormattedHour();[m
[31m-            }else{[m
[31m-                this->alarmHour++;[m
[31m-                updateFormattedHour();[m
[31m-[m
[31m-            }[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void increaseAlarmHour() {[m
[32m+[m[32m        if (this->alarmHour == 23) {[m
[32m+[m[32m            this->alarmHour = 0;[m
[32m+[m[32m            updateFormattedHour();[m
[32m+[m[32m        } else {[m
[32m+[m[32m            this->alarmHour++;[m
[32m+[m[32m            updateFormattedHour();[m
         }[m
[31m-        void increaseAlarmMinute(){[m
[31m-            if(this->alarmMinute == 59){[m
[31m-                updateFormattedMinute();[m
[31m-                this->alarmMinute = 0;[m
[31m-            }else{[m
[31m-                updateFormattedMinute();[m
[31m-                this->alarmMinute++;[m
[31m-            }[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    void increaseAlarmMinute() {[m
[32m+[m[32m        if (this->alarmMinute == 59) {[m
[32m+[m[32m            this->alarmMinute = 0;[m
[32m+[m[32m        } else {[m
[32m+[m[32m            this->alarmMinute++;[m
         }[m
[31m-};[m
\ No newline at end of file[m
[32m+[m[32m        updateFormattedMinute();[m
[32m+[m[32m    }[m
[32m+[m[32m};[m
[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mindex 07ff499..003b9c3 100644[m
[1m--- a/sketch_sep8a.ino[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -6,10 +6,7 @@[m
 #define LCD_COLUMNS 16[m
 #define LCD_ROWS 2[m
 [m
[31m-char a[] = "a";[m
[31m-Alarm alarm1(1, 56);[m
[31m-const char* formattedMinute = alarm1.getFormattedMinute();[m
[31m-const char* formattedHour = alarm1.getFormattedHour();[m
[32m+[m
 LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
 [m
 void setup() {[m
[36m@@ -20,8 +17,5 @@[m [mvoid setup() {[m
 [m
 void loop() {[m
   delay(1000);[m
[31m-    lcd.setCursor(0, 1);[m
[31m-    lcd.print(String(formattedHour) + ":" + String(formattedMinute));[m
[31m-    lcd.setCursor(0, 1);[m
 [m
 }[m

[33mcommit a74bca01b09b336070bde1f728f25f3a6a687365[m
Merge: 2e5e1a9 985a806
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Fri Sep 8 03:16:38 2023 -0300

    Merge branch 'main' of https://github.com/mightbehappyy/CatFeeder

[33mcommit 2e5e1a9ad1107376dc26f63850eae1e1cf027d77[m[33m ([m[1;32mmaster[m[33m)[m
Author: Pedro <pedroluiz0201690@gmail.com>
Date:   Fri Sep 8 03:08:52 2023 -0300

    working lcd display and alarm class

[1mdiff --git a/alarm.cpp b/alarm.cpp[m
[1mnew file mode 100644[m
[1mindex 0000000..84cbbba[m
[1m--- /dev/null[m
[1m+++ b/alarm.cpp[m
[36m@@ -0,0 +1,74 @@[m
[32m+[m[32m#include <stdio.h>[m
[32m+[m[32m#include <string.h>[m
[32m+[m[32mclass Alarm{[m
[32m+[m[32m    private:[m
[32m+[m[32m        uint8_t alarmHour;[m
[32m+[m[32m        uint8_t alarmMinute;[m
[32m+[m[32m        bool timeUnitIsHour;[m
[32m+[m[32m        char formattedHour[3];[m
[32m+[m[32m        char formattedMinute[3];[m
[32m+[m[32m    public:[m
[32m+[m[32m        Alarm(uint8_t hour, uint8_t minute){[m
[32m+[m[32m            this->alarmHour = hour;[m
[32m+[m[32m            this-> alarmMinute = minute;[m
[32m+[m[32m            this-> timeUnitIsHour = true;[m
[32m+[m[32m            updateFormattedHour();[m[41m  [m
[32m+[m[32m            updateFormattedMinute();[m
[32m+[m[32m        }[m
[32m+[m[32m        void setAlarmHour(uint8_t hour){[m
[32m+[m[32m            this->alarmHour = hour;[m
[32m+[m[32m        }[m
[32m+[m[32m        void setAlarmMinute(uint8_t minute){[m
[32m+[m[32m            this->alarmMinute = minute;[m
[32m+[m[32m        }[m
[32m+[m[32m        uint8_t getAlarmHour(){[m
[32m+[m[32m            return this->alarmHour;[m
[32m+[m[32m        }[m
[32m+[m[32m        uint8_t getAlarmMinute(){[m
[32m+[m[32m            return this->alarmMinute;[m
[32m+[m[32m        }[m
[32m+[m[32m        const char* getFormattedHour(){[m
[32m+[m[32m          return formattedHour;[m
[32m+[m[32m        }[m
[32m+[m[32m        void updateFormattedHour(){[m
[32m+[m[32m          sprintf(formattedHour, "%02d", this->alarmHour);[m
[32m+[m[32m        }[m
[32m+[m[32m        const char* getFormattedMinute() {[m
[32m+[m[32m        return formattedMinute;[m
[32m+[m[32m    }[m
[32m+[m[32m        void updateFormattedMinute() {[m
[32m+[m[32m        sprintf(formattedMinute, "%02d", this->alarmMinute);[m
[32m+[m[32m    }[m[41m [m
[32m+[m[32m        bool isAlarmTimeNow(uint8_t hour, uint8_t minute){[m
[32m+[m[32m            if(this->alarmHour == hour && this->alarmMinute == minute){[m
[32m+[m[32m                return true;[m
[32m+[m[32m            }[m
[32m+[m[32m            return false;[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        bool getConfigMode(){[m
[32m+[m[32m            return this->timeUnitIsHour;[m
[32m+[m[32m        }[m
[32m+[m[32m         void toggleConfigMode(){[m
[32m+[m[32m            this->timeUnitIsHour = !this->timeUnitIsHour;[m
[32m+[m[32m        }[m
[32m+[m[32m        void increaseAlarmHour(){[m
[32m+[m[32m            if(this->alarmHour == 23){[m
[32m+[m[32m                this->alarmHour = 0;[m
[32m+[m[32m                updateFormattedHour();[m
[32m+[m[32m            }else{[m
[32m+[m[32m                this->alarmHour++;[m
[32m+[m[32m                updateFormattedHour();[m
[32m+[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m        void increaseAlarmMinute(){[m
[32m+[m[32m            if(this->alarmMinute == 59){[m
[32m+[m[32m                updateFormattedMinute();[m
[32m+[m[32m                this->alarmMinute = 0;[m
[32m+[m[32m            }else{[m
[32m+[m[32m                updateFormattedMinute();[m
[32m+[m[32m                this->alarmMinute++;[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m};[m
\ No newline at end of file[m
[1mdiff --git a/sketch_sep8a.ino b/sketch_sep8a.ino[m
[1mnew file mode 100644[m
[1mindex 0000000..07ff499[m
[1m--- /dev/null[m
[1m+++ b/sketch_sep8a.ino[m
[36m@@ -0,0 +1,27 @@[m
[32m+[m[32m#include <LiquidCrystal_I2C.h>[m
[32m+[m[32m#include <Wire.h>[m
[32m+[m[32m#include "alarm.cpp"[m
[32m+[m
[32m+[m[32m#define LCD_ADDRESS 0x3F[m
[32m+[m[32m#define LCD_COLUMNS 16[m
[32m+[m[32m#define LCD_ROWS 2[m
[32m+[m
[32m+[m[32mchar a[] = "a";[m
[32m+[m[32mAlarm alarm1(1, 56);[m
[32m+[m[32mconst char* formattedMinute = alarm1.getFormattedMinute();[m
[32m+[m[32mconst char* formattedHour = alarm1.getFormattedHour();[m
[32m+[m[32mLiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);[m
[32m+[m
[32m+[m[32mvoid setup() {[m
[32m+[m[32m  lcd.init();[m
[32m+[m[32m  lcd.backlight();[m
[32m+[m[32m  lcd.clear();[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid loop() {[m
[32m+[m[32m  delay(1000);[m
[32m+[m[32m    lcd.setCursor(0, 1);[m
[32m+[m[32m    lcd.print(String(formattedHour) + ":" + String(formattedMinute));[m
[32m+[m[32m    lcd.setCursor(0, 1);[m
[32m+[m
[32m+[m[32m}[m

[33mcommit 985a8061df6ce086c74647ad828e8db569ac9238[m
Author: Pedro <97134972+mightbehappyy@users.noreply.github.com>
Date:   Fri Sep 8 03:00:34 2023 -0300

    Initial commit

[1mdiff --git a/README.md b/README.md[m
[1mnew file mode 100644[m
[1mindex 0000000..8bef3a7[m
[1m--- /dev/null[m
[1m+++ b/README.md[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32m# CatFeeder[m
\ No newline at end of file[m
