#include "Arduino.h"
#include "Alarm.h"
#include "ButtonB.h"
#include "Button.h"

ButtonB::ButtonB(const unsigned char pin)
  : Button(pin) {}

void ButtonB::activateAlarm(uint8_t currentModeIndex, uint8_t currentAlarmIndex, Alarm *alarms) {
  if (!getButtonState() && currentModeIndex == 1 && !isPressed()) {
    alarms[currentAlarmIndex].toggleIsAlarmActive();
    setIsButtonPressed(true);
  } else if (getButtonState()) {
    setIsButtonPressed(false);
  }
}
void ButtonB::decreaseAlarmTime(uint8_t currentAlarmIndex, Alarm *alarms) {
  if (!getButtonState() && !isPressed()) {
    alarms[currentAlarmIndex].timeDecreaseManager();
  }
}
