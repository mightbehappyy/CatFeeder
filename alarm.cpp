#include <stdio.h>
#include <string.h>

class Alarm {
private:
    uint8_t alarmHour;
    uint8_t alarmMinute;
    bool timeUnitIsHour;
    bool isAlarmActive;
    char formattedHour[3];
    char formattedMinute[3];

public:
    Alarm() {
        this->alarmHour = 0;
        this->alarmMinute = 0;
        this->timeUnitIsHour = true;
        this->isAlarmActive = false;
        updateFormattedHour();
        updateFormattedMinute();
    }

    void setAlarmHour(uint8_t hour) {
        this->alarmHour = hour;
    }

    void setAlarmMinute(uint8_t minute) {
        this->alarmMinute = minute;
    }

    void setIsAlarmActive(bool isAlarmActive) {
        this->isAlarmActive = isAlarmActive;
    }

    bool getIsAlarmActive(){
        return this->isAlarmActive;
    }

    uint8_t getAlarmHour() {
        return this->alarmHour;
    }

    uint8_t getAlarmMinute() {
        return this->alarmMinute;
    }

    const char* getFormattedHour() {
        return this->formattedHour;
    }

    void updateFormattedHour() {
        sprintf(this->formattedHour, "%02d", this->alarmHour);
    }

    const char* getFormattedMinute() {
        return formattedMinute;
    }

    void updateFormattedMinute() {
        sprintf(formattedMinute, "%02d", this->alarmMinute);
    }

    bool isAlarmTimeNow(uint8_t hour, uint8_t minute) {
        return this->alarmHour == hour && this->alarmMinute == minute;
    }

    bool getConfigMode() {
        return this->timeUnitIsHour;
    }

    void toggleConfigMode() {
        this->timeUnitIsHour = !this->timeUnitIsHour;
    }

    void toggleIsAlarmActive(){
        this->isAlarmActive = !this->isAlarmActive;
    }

    void timeIncrementManager() {
        if (getConfigMode()) {
            increaseAlarmHour();
        } else {
            increaseAlarmMinute();
        }
    }

    void increaseAlarmHour() {
        if (this->alarmHour == 23) {
            this->alarmHour = 0;
            updateFormattedHour();
        } else {
            this->alarmHour++;
            updateFormattedHour();
        }
    }

    void increaseAlarmMinute() {
        if (this->alarmMinute == 59) {
            this->alarmMinute = 0;
        } else {
            this->alarmMinute++;
        }
        updateFormattedMinute();
    }
};
