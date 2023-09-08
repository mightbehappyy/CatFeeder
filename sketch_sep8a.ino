#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include "alarm.cpp"

#define LCD_ADDRESS 0x3F
#define LCD_COLUMNS 16
#define LCD_ROWS 2

char a[] = "a";
Alarm alarm1(1, 56);
const char* formattedMinute = alarm1.getFormattedMinute();
const char* formattedHour = alarm1.getFormattedHour();
LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

void setup() {
  lcd.init();
  lcd.backlight();
  lcd.clear();
}

void loop() {
  delay(1000);
    lcd.setCursor(0, 1);
    lcd.print(String(formattedHour) + ":" + String(formattedMinute));
    lcd.setCursor(0, 1);

}
