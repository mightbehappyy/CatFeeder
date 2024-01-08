#ifndef ButtonD_H
#define ButtonD_H

#include "Button.h" 
#include "Alarm.h"  

class ButtonD : public Button {
public:
  ButtonD(const unsigned char pin);

  bool switchToConfigMode(bool isInConfigMode, uint8_t currentModeIndex);
};

#endif