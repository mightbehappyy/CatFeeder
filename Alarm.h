#ifndef Alarm_h
#define Alarm_h

#include "Arduino.h"

class Alarm {
public:
  Alarm();
  void setAlarmHour(uint8_t hour);
  void setAlarmMinute(uint8_t minute);
  void setIsAlarmActive(bool isAlarmActive);
  bool getIsAlarmActive();
  uint8_t getAlarmHour();
  uint8_t getAlarmMinute();
  const char* getFormattedHour();
  void updateFormattedHour();
  const char* getFormattedMinute();
  void updateFormattedMinute();
  bool isAlarmTimeNow(uint8_t hour, uint8_t minute);
  bool getConfigMode();
  void toggleConfigMode();
  void toggleIsAlarmActive();
  void timeIncrementManager();
  void timeDecreaseManager();
  void increaseAlarmHour();
  void increaseAlarmMinute();
  void decreaseAlarmHour();
  void decreaseAlarmMinute();
  bool isValid();
private:
  uint8_t alarmHour;
  uint8_t alarmMinute;
  bool timeUnitIsHour;
  bool isAlarmActive;
  char formattedHour[3];
  char formattedMinute[3];
};



#endif