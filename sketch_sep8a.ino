#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "Alarm.cpp" 

#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2

#define pinChangeModeButton 13
#define pinConfigButton 12
#define bounceTime 50

unsigned char previousButtonState = "HIGH";
bool buttonState;
static unsigned long buttonDelay = 0;

// Initializing LCD, address can change according to the Arduino/display you are using.
LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

Alarm alarms[5];
uint8_t currentAlarmIndex = 0;
uint8_t currentModeIndex = 0; 
uint8_t portionAmount = 0;    

void setup() {
  pinMode(pinChangeModeButton, INPUT_PULLUP);
  pinMode(pinConfigButton, INPUT_PULLUP);
  lcd.init();
  lcd.backlight();
  lcd.clear();
  initializeAlarms();
  Serial.begin(9600);
}

void loop() {
  delay(150);
  handleUserModeChange();
  handleUserConfigChange();
  handleDisplayMode();
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

  lcd.setCursor(0, 1);
  lcd.print("Hour: ");
  lcd.print(alarms[currentAlarmIndex].getFormattedHour());

  lcd.setCursor(9, 1);
  lcd.print("Min: ");
  lcd.print(alarms[currentAlarmIndex].getFormattedMinute());
}

void displayNextAlarmAndTime() {
  lcd.setCursor(0, 0);
  lcd.print(F("Nxt Alarm:"));

  lcd.setCursor(0, 1);
  lcd.print(F("Time:"));
}

void displayPortionAmount() {
  lcd.setCursor(0, 0);
  lcd.print(F("Portion size:"));
  lcd.print(F(" "));
  lcd.print(portionAmount);
}

void handleDisplayMode() {
  static uint8_t previousModeIndex = 255; 

  if (currentModeIndex != previousModeIndex) {
    lcd.clear();
    previousModeIndex = currentModeIndex;
  }
  if (currentModeIndex == 0) {
    displayNextAlarmAndTime();
  } else if (currentModeIndex == 1) {
    displayAlarmInfo();
  } else {
    displayPortionAmount();
  }
}

void handleUserModeChange() {
  if ((millis() - buttonDelay) > bounceTime) {
    buttonState = digitalRead(pinChangeModeButton);    
    if (buttonState == LOW && previousButtonState) {
      if (currentModeIndex < 2){
        currentModeIndex++;
      } else {
        currentModeIndex = 0;
      }
      buttonDelay = millis();
    }
    
  }
}

void handleUserConfigChange() {
  if ((millis() - buttonDelay) > bounceTime) {
    buttonState = digitalRead(pinConfigButton);
     if (buttonState == LOW && previousButtonState) {
      if (currentModeIndex == 1){
        if (currentAlarmIndex < 4){
          currentAlarmIndex++;
        } else {
          currentAlarmIndex = 0;
        }
       
      } else if (currentModeIndex == 2) {
        if (portionAmount < 5){
          portionAmount++;
        } else {
          portionAmount = 0;
        }
      }
      buttonDelay = millis();
    }
    buttonState = previousButtonState;
  }
}
