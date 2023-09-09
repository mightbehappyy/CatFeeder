#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "Alarm.cpp" 
#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2

// Initializing LCD, address can change according to the Arduino/display you are using.
LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

Alarm alarms[5];
uint8_t currentAlarmIndex = 0;
uint8_t currentModeIndex = 0; 
uint8_t portionAmount = 0;    

void setup() {
  lcd.init();
  lcd.backlight();
  lcd.clear();
  initializeAlarms();
}

void loop() {
  delay(1000);
  if (currentModeIndex < 2) {
    currentModeIndex++;
  } else {
    currentModeIndex = 0;
  }
  handleDisplayMode();
  delay(1000);
}

void initializeAlarms() {
  for (uint8_t i = 0; i < 5; i++) {
    alarms[i] = Alarm();
  }
}

void displayAlarmInfo() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Alarm ");
  lcd.print(currentAlarmIndex + 1);

  lcd.setCursor(0, 1);
  lcd.print("Hour: ");
  lcd.print(alarms[currentAlarmIndex].getFormattedHour());

  lcd.setCursor(9, 1);
  lcd.print("Min: ");
  lcd.print(alarms[currentAlarmIndex].getFormattedMinute());
}

void displayNextAlarmAndTime() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(F("Nxt Alarm:"));

  lcd.setCursor(0, 1);
  lcd.print(F("Time:"));
}

void displayPortionAmount() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(F("Portion size:"));
  lcd.print(" ");
  lcd.print(portionAmount);
}

void handleDisplayMode() {
  if (currentModeIndex == 0) {
    displayNextAlarmAndTime();
  } else if (currentModeIndex == 1) {
    displayAlarmInfo();
  } else {
    displayPortionAmount();
  }
}

void handleUserInput() {

}
