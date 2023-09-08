#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "alarm.cpp"

#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2


LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

void setup() {
  lcd.init();
  lcd.backlight();
  lcd.clear();
}

void loop() {
  delay(1000);

}
