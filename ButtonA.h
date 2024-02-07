#ifndef ButtonA_H
#define ButtonA_H

#include "Button.h"
#include "Alarm.h"

class ButtonA : public Button {
public:
  ButtonA(const unsigned char pin);

  void increaseAlarmTime(uint8_t currentAlarmIndex, Alarm *alarms);
};

#endif