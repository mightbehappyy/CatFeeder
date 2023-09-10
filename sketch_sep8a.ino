#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "Alarm.cpp" 

#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2

#define pinChangeModeButton 13
#define pinConfigButton 12
#define pinActiveAlarm 11
#define pinActiveConfigModeButton 10
#define bounceTime 50

unsigned char previousModeButtonState = HIGH;
unsigned char previousActiveAlarmButtonState = HIGH;
unsigned char previousConfigButtonState = HIGH;
unsigned char previousActiveConfigModeButtonState = HIGH;
bool configButtonState;
bool activeAlarmButtonState;
bool modeButtonState;
bool configModeButtonState;
static unsigned long buttonDelay = 0;

unsigned long previousMillis = 0;
const long interval = 500; 
bool showSpaces = true; 

// Initializing LCD, address can change according to the Arduino/display you are using.
LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

Alarm alarms[5];
uint8_t currentAlarmIndex = 0;
uint8_t currentModeIndex = 0; 
uint8_t portionAmount = 0; 
bool configState = false;   

void setup() {
  pinMode(pinChangeModeButton, INPUT_PULLUP);
  pinMode(pinConfigButton, INPUT_PULLUP);
  pinMode(pinActiveAlarm, INPUT_PULLUP);
  pinMode(pinActiveConfigModeButton, INPUT_PULLUP);
  lcd.init();
  lcd.backlight();
  lcd.clear();
  initializeAlarms();
  Serial.begin(9600);
}

void loop() {
  delay(150);
  displayConfigMode();
  if (!configState) {
    handleUserModeChange();
    handleUserConfigChange();
    handleUserActiveAlarm();
    handleDisplayMode();
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
  if (alarms[currentAlarmIndex].getIsAlarmActive()){
    lcd.print("Active  ");
  } else {

    lcd.print("Unactive");
  }
  lcd.setCursor(0, 1);

  lcd.print(alarms[currentAlarmIndex].getFormattedHour());

  lcd.print(":");
  
  lcd.print(alarms[currentAlarmIndex].getFormattedMinute());

  lcd.setCursor(6,1);
  if (configState) {
    lcd.print("ConfigMode");
  } else {
    lcd.print("          ");
  }
}

void clearSpecificArea(LiquidCrystal_I2C &lcd, uint8_t col, uint8_t row, uint8_t numChars) {
  lcd.setCursor(col, row);
  for (uint8_t i = 0; i < numChars; i++) {
    lcd.print(" "); // Print spaces to clear the area
  }
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
    modeButtonState = digitalRead(pinChangeModeButton);    
    if (modeButtonState == LOW && previousModeButtonState) {
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
    configButtonState = digitalRead(pinConfigButton);
     if (configButtonState == LOW && previousModeButtonState == HIGH) {
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
    configButtonState = previousModeButtonState;
  }
}

void handleUserActiveAlarm() {
  if((millis() - buttonDelay) > bounceTime) {
    activeAlarmButtonState = digitalRead(pinActiveAlarm);
    if (activeAlarmButtonState == LOW  && previousActiveAlarmButtonState) {
      if (currentModeIndex == 1) {
        alarms[currentAlarmIndex].toggleIsAlarmActive();
      } 
    }
  }
}
void displayConfigMode() {
  if ((millis() - buttonDelay) > bounceTime) {
    configModeButtonState = digitalRead(pinActiveConfigModeButton);
    if (configModeButtonState == LOW && previousActiveConfigModeButtonState) {
      if (currentModeIndex == 1) {
        configState = !configState;
        buttonDelay = millis();
      }
    }
  }
}

void handleUserInputForAlarm() {
  if ((millis() - buttonDelay) > bounceTime) {
    modeButtonState = digitalRead(pinChangeModeButton);
    configButtonState = digitalRead(pinConfigButton);
    if (modeButtonState == LOW && previousModeButtonState) {
      alarms[currentAlarmIndex].toggleConfigMode();
      buttonDelay = millis();
    }
    if (configButtonState == LOW && previousConfigButtonState) {
      alarms[currentAlarmIndex].timeIncrementManager();
      buttonDelay = millis();
    }
  }
}

