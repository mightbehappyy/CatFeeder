#include "Arduino.h"
#include "Button.h"

Button::Button(const unsigned char pin) {
  this->pin = pin;
  this->isButtonPressed = false;
}

unsigned char pin;  // current PIN
bool isButtonPressed;


bool Button::getButtonState() {
  return digitalRead(this->pin);
}

void Button::setPinMode() {
  pinMode(this->pin, INPUT_PULLUP);
}
void Button::setIsButtonPressed(bool state) {
  this->isButtonPressed = state;
}
bool Button::isPressed() {
  return this->isButtonPressed;
}
