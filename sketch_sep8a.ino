#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "alarm.cpp"

#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2

// Initializing LCD, address can change according to the arduino/display you are using.
LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

Alarm alarms[5];
uint8_t currentAlarmIndex = 0;

void setup() {
  lcd.init();
  lcd.backlight();
  lcd.clear();
  initializeAlarms();
}

void loop() {
  delay(1000);
  displayAlarmInfo();
  delay(1000);
  if(currentAlarmIndex < 4) {
    currentAlarmIndex++;
  } else {
    currentAlarmIndex = 0;
  }
  delay(1000);
}

void initializeAlarms(){
  for(uint8_t i = 0; i < 5; i++) {
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

void handleUserInput() {

}
