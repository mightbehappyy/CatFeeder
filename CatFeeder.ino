#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "Alarm.h"
#include <RTClib.h>
#include "ButtonB.h"
#include "ButtonD.h"
#include "ButtonC.h"
#include "ButtonA.h"
#include "relay.cpp"
#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2

#define pinChangeModeButton 13
#define pinConfigButton 12
#define pinActiveAlarm 11
#define pinActiveConfigModeButton 10

#define relayPin 9
bool configButtonState;

RTC_DS1307 rtc;
LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);
Relay motorRelay(relayPin, LOW);

ButtonB buttonB(pinActiveAlarm);
ButtonC buttonC(pinChangeModeButton);
ButtonD buttonD(pinActiveConfigModeButton);
ButtonA buttonA(pinConfigButton);

Alarm alarms[5];
uint8_t currentAlarmIndex = 0;
uint8_t currentModeIndex = 0;
uint8_t portionAmount = 0;
bool configState = false;

void setup() {
  buttonB.setPinMode();
  buttonD.setPinMode();
  buttonC.setPinMode();
  buttonA.setPinMode();
  motorRelay.setPinMode();
  pinMode(pinConfigButton, INPUT_PULLUP);
  lcd.init();
  lcd.backlight();
  lcd.clear();
  initializeAlarms();
  Serial.begin(9600);
#ifndef ESP8266
  while (!Serial);  // wait for serial port to connect. Needed for native USB
#endif

  if (!rtc.begin()) {
    Serial.println("Couldn't find RTC");
    Serial.flush();
    while (1) delay(10);
  }

  if (!rtc.isrunning()) {
    Serial.println("RTC is NOT running, let's set the time!");

    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  }
}

void loop() {
  delay(100);
  DateTime now = rtc.now();
  displayConfigMode();
  if (!configState) {
    handleUserModeChange();
    handleUserConfigChange();
    handleUserActiveAlarm();
    handleDisplayMode(now);
    checkForAlarmTime();
  } else {
    handleUserInputForAlarm();
    displayAlarmInfo();
  }
}

void initializeAlarms() {
  for (uint8_t i = 0; i < 5; i++) {
    alarms[i] = Alarm();
  }
}

void displayAlarmInfo() {
  lcd.setCursor(0, 0);
  lcd.print("Alarm ");
  lcd.print(currentAlarmIndex + 1);

  lcd.setCursor(8, 0);
  if (alarms[currentAlarmIndex].getIsAlarmActive()) {
    lcd.print("Active  ");
  } else {

    lcd.print("Inactive");
  }

  if (configState) {
    if (alarms[currentAlarmIndex].getConfigMode()) {
      lcd.setCursor(6, 1);
      lcd.print(" ");
      lcd.setCursor(0, 1);
      lcd.print(">");
    } else {
      lcd.setCursor(0, 1);
      lcd.print(" ");
      lcd.setCursor(6, 1);
      lcd.print("<");
    }
  } else {
    lcd.setCursor(0, 1);
    lcd.print(" ");
    lcd.setCursor(6, 1);
    lcd.print(" ");
  }

  lcd.setCursor(1, 1);

  lcd.print(alarms[currentAlarmIndex].getFormattedHour());

  lcd.print(":");

  lcd.print(alarms[currentAlarmIndex].getFormattedMinute());

  lcd.setCursor(8, 1);
  if (configState) {
    lcd.print("Config");
  } else {
    lcd.print("          ");
  }
}

void checkForAlarmTime() {
  for (uint8_t i = 0; i < 5; i++) {
    if (alarms[i].getIsAlarmActive() && alarms[i].isAlarmTimeNow(rtc.now().hour(), rtc.now().minute())) {
      while (rtc.now().second() < portionAmount + 1) {
        Serial.println("Alarm:");
        Serial.print(i);
        Serial.print("is ringing");
        motorRelay.activate();
      }
      motorRelay.deactivate();
    }
    
  }
}

Alarm checkForNextAlarm() {
  Alarm closestAlarm;
  DateTime now = rtc.now();

  int closestTimeDifference = 9999;

  for (uint8_t i = 0; i < 5; i++) {
    if (alarms[i].getIsAlarmActive()) {
      int hourDifference = alarms[i].getAlarmHour() - now.hour();
      int minuteDifference = alarms[i].getAlarmMinute() - now.minute();
      if (hourDifference <= 0 && minuteDifference < 0) {
        hourDifference = 23 + hourDifference;
        if (minuteDifference <= 0) {
          minuteDifference = 60 + minuteDifference;
        }
      }

      int absoluteDifference = abs(hourDifference * 60 + minuteDifference);
      if (absoluteDifference < closestTimeDifference) {
        closestTimeDifference = absoluteDifference;
        closestAlarm = alarms[i];
      }
    }
  }
  

  return closestAlarm;
}



void displayNextAlarmAndTime(DateTime date) {

  lcd.setCursor(0, 1);
  lcd.print(F("Next Meal: "));
  Alarm nextAlarm = checkForNextAlarm();

  if (nextAlarm.isValid()) {
    lcd.print(nextAlarm.getFormattedHour());
    lcd.print(":");
    lcd.print(nextAlarm.getFormattedMinute());
  } else {
    lcd.print("None");
  }

  lcd.setCursor(0, 0);
  if (date.hour() < 10) {
    lcd.print("0");
  }
  lcd.print(date.hour());
  if (date.second() % 2 == 0) {
    lcd.print(" ");
  } else {
    lcd.print(":");
  }
  if (date.minute() < 10) {
    lcd.print("0");
  }
  lcd.print(date.minute());
}

void displayPortionAmount() {
  lcd.setCursor(0, 0);
  lcd.print(F("Portion size:"));
  lcd.print(F(" "));
  lcd.print(portionAmount);
}

void handleDisplayMode(DateTime date) {
  static uint8_t previousModeIndex = 255;

  if (currentModeIndex != previousModeIndex) {
    lcd.clear();
    previousModeIndex = currentModeIndex;
  }
  if (currentModeIndex == 0) {
    displayNextAlarmAndTime(date);
  } else if (currentModeIndex == 1) {
    displayAlarmInfo();
  } else {
    displayPortionAmount();
  }
}

void handleUserConfigChange() {
    configButtonState = digitalRead(pinConfigButton);
    if (configButtonState == LOW) {
      if (currentModeIndex == 1) {
        if (currentAlarmIndex < 4) {
          currentAlarmIndex++;
        } else {
          currentAlarmIndex = 0;
        }
      } else if (currentModeIndex == 2) {
        if (portionAmount < 5) {
          portionAmount++;
        } else {
          portionAmount = 0;
        }
      }
    }
  }

void handleUserModeChange() {  
    currentModeIndex = buttonC.switchScreen(currentModeIndex);
  }

void handleUserActiveAlarm() {
  buttonB.activateAlarm(currentModeIndex, currentAlarmIndex, alarms);
}

void displayConfigMode() {
  configState = buttonD.switchToConfigMode(configState, currentModeIndex);
}

void handleUserInputForAlarm() {  
  buttonC.toggleAlarmTimeUnit(currentAlarmIndex, alarms);
  buttonB.decreaseAlarmTime(currentAlarmIndex, alarms);
  buttonA.increaseAlarmTime(currentAlarmIndex, alarms);
}