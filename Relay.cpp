#include <Arduino.h>

class Relay {
  private:
    unsigned char pin; 
    unsigned char activation; 
    volatile unsigned char state; 
  public:
    Relay(const unsigned char pin, const unsigned char activation) { 
      this->pin = pin; 
      this->activation = activation; 
      this->deactivate(); 
    }
    void activate() { 
      this->state = this->activation; 
      digitalWrite(this->pin, this->state);
    }
    void deactivate() { 
      this->state = !(this->activation); 
      digitalWrite(this->pin, this->state);
    }

    void setPinMode() {
      pinMode(this->pin, OUTPUT);
    }
};