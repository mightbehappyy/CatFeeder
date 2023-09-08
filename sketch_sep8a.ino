#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "alarm.cpp"

#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2


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

}

void initializeAlarms(){
  for(uint8_t i = 0; i < 5; i++) {
    alarms[i] = Alarm();
  }
}
