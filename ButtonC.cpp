#include "Arduino.h"
#include "Alarm.h"
#include "ButtonC.h"
#include "Button.h"

ButtonC::ButtonC(const unsigned char pin)
  : Button(pin) {}

uint8_t ButtonC::switchScreen(uint8_t currentModeIndex) {
  if (!getButtonState() && !isPressed()) {
    setIsButtonPressed(true); 
    if (currentModeIndex < 2) {
      currentModeIndex++; 
    } else {
      currentModeIndex = 0; 
    }
  } else if (getButtonState()) {
    setIsButtonPressed(false); 
  }
  return currentModeIndex;
}

void ButtonC::toggleAlarmTimeUnit(uint8_t currentAlarmIndex, Alarm *alarms) {
  if (!getButtonState() && !isPressed()) {
    alarms[currentAlarmIndex].toggleConfigMode();
  }
}
