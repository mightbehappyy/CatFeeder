#include "Arduino.h"
#include "Alarm.h"
#include "ButtonA.h"
#include "Button.h"

ButtonA::ButtonA(const unsigned char pin)
  : Button(pin) {}

void ButtonA::increaseAlarmTime(uint8_t currentAlarmIndex, Alarm *alarms) {
  if (!getButtonState() && !isPressed()) {
    alarms[currentAlarmIndex].timeIncrementManager();
  }
}
