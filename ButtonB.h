#ifndef ButtonB_H
#define ButtonB_H

#include "Button.h"
#include "Alarm.h"

class ButtonB : public Button {
public:
  ButtonB(const unsigned char pin);

  void activateAlarm(uint8_t currentModeIndex, uint8_t currentAlarmIndex, Alarm *alarms);
  void decreaseAlarmTime(uint8_t currentAlarmIndex, Alarm *alarms);
};

#endif