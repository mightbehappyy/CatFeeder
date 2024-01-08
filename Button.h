#ifndef Button_H
#define Button_H

#include "Arduino.h"

class Button {
private:
  unsigned char pin;     // current PIN
  bool isButtonPressed;  // To check if the button is being pressed

public:
  Button(const unsigned char pin);

  bool getButtonState();
  void setPinMode();
  bool isPressed();
  void setIsButtonPressed(bool state);
};

#endif