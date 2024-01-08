#include "Arduino.h"
#include "Alarm.h"
#include "ButtonD.h"
#include "Button.h"

ButtonD::ButtonD(const unsigned char pin)
  : Button(pin) {}

bool ButtonD::switchToConfigMode(bool isInConfigMode, uint8_t currentModeIndex) {
  if (!getButtonState() && currentModeIndex == 1 && !isPressed()) {
    setIsButtonPressed(true);
    return !isInConfigMode;

  } else if (getButtonState()) {
    setIsButtonPressed(false);
  }
  return isInConfigMode;
}
