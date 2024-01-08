#ifndef BUTTON_H
#define BUTTON_H

#include "Arduino.h"

class Button {
private:
  unsigned char pin;     // current PIN
  bool isButtonPressed;

public:
  Button(const unsigned char pin);

  bool getButtonState();
  void setPinMode();
  bool isPressed();
  void setIsButtonPressed(bool state);
};

#endif // BUTTON_H