#ifndef ButtonC_H
#define ButtonC_H

#include "Button.h"
#include "Alarm.h"

class ButtonC : public Button {
public:
  ButtonC(const unsigned char pin);

  uint8_t ButtonC::switchScreen(uint8_t currentModeIndex);
  void ButtonC::toggleAlarmTimeUnit(uint8_t currentAlarmIndex, Alarm *alarms);
};

#endif