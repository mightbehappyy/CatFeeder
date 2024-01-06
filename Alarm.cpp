#include <stdio.h>
#include <string.h>
#include "Alarm.h"
Alarm::Alarm() {
  this->alarmHour = 0;
  this->alarmMinute = 0;
  this->timeUnitIsHour = true;
  this->isAlarmActive = false;
  updateFormattedHour();
  updateFormattedMinute();
}

void Alarm::setAlarmHour(uint8_t hour) {
  this->alarmHour = hour;
}

void Alarm::setAlarmMinute(uint8_t minute) {
  this->alarmMinute = minute;
}

void Alarm::setIsAlarmActive(bool isAlarmActive) {
  this->isAlarmActive = isAlarmActive;
}

bool Alarm::getIsAlarmActive() {
  return this->isAlarmActive;
}


uint8_t Alarm::getAlarmHour() {
  return this->alarmHour;
}

uint8_t Alarm::getAlarmMinute() {
  return this->alarmMinute;
}

const char* Alarm::getFormattedHour() {
  return this->formattedHour;
}

void Alarm::updateFormattedHour() {
  sprintf(this->formattedHour, "%02d", this->alarmHour);
}

const char* Alarm::getFormattedMinute() {
  return formattedMinute;
}

void Alarm::updateFormattedMinute() {
  sprintf(formattedMinute, "%02d", this->alarmMinute);
}

bool Alarm::isAlarmTimeNow(uint8_t hour, uint8_t minute) {
  return this->alarmHour == hour && this->alarmMinute == minute;
}

bool Alarm::getConfigMode() {
  return this->timeUnitIsHour;
}

void Alarm::toggleConfigMode() {
  this->timeUnitIsHour = !this->timeUnitIsHour;
}

void Alarm::toggleIsAlarmActive() {
  this->isAlarmActive = !this->isAlarmActive;
}

void Alarm::timeIncrementManager() {
  if (getConfigMode()) {
    increaseAlarmHour();
  } else {
    increaseAlarmMinute();
  }
}
void Alarm::timeDecreaseManager() {
  if (getConfigMode()) {
    decreaseAlarmHour();
  } else {
    decreaseAlarmMinute();
  }
}

void Alarm::increaseAlarmHour() {
  if (this->alarmHour == 23) {
    this->alarmHour = 0;
    updateFormattedHour();
  } else {
    this->alarmHour++;
    updateFormattedHour();
  }
}

void Alarm::increaseAlarmMinute() {
  if (this->alarmMinute == 59) {
    this->alarmMinute = 0;
  } else {
    this->alarmMinute++;
  }
  updateFormattedMinute();
}

void Alarm::decreaseAlarmHour() {
  if (this->alarmHour == 0) {
    this->alarmHour = 23;
    updateFormattedHour();
  } else {
    this->alarmHour--;
    updateFormattedHour();
  }
}

void Alarm::decreaseAlarmMinute() {
  if (this->alarmMinute == 0) {
    this->alarmMinute = 59;
  } else {
    this->alarmMinute--;
  }
  updateFormattedMinute();
}


bool Alarm::isValid() {
  // Add your logic here to determine if the alarm is valid or not
  // For example, checking if it's active or if the hour and minute are within valid ranges
  return (getIsAlarmActive() && (getAlarmHour() >= 0 && alarmHour < 24) && (getAlarmMinute() >= 0 && getAlarmMinute() < 60));
}
