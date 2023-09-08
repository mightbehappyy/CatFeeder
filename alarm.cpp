#include <stdio.h>
#include <string.h>
class Alarm{
    private:
        uint8_t alarmHour;
        uint8_t alarmMinute;
        bool timeUnitIsHour;
        char formattedHour[3];
        char formattedMinute[3];
    public:
        Alarm(uint8_t hour, uint8_t minute){
            this->alarmHour = hour;
            this-> alarmMinute = minute;
            this-> timeUnitIsHour = true;
            updateFormattedHour();  
            updateFormattedMinute();
        }
        void setAlarmHour(uint8_t hour){
            this->alarmHour = hour;
        }
        void setAlarmMinute(uint8_t minute){
            this->alarmMinute = minute;
        }
        uint8_t getAlarmHour(){
            return this->alarmHour;
        }
        uint8_t getAlarmMinute(){
            return this->alarmMinute;
        }
        const char* getFormattedHour(){
          return formattedHour;
        }
        void updateFormattedHour(){
          sprintf(formattedHour, "%02d", this->alarmHour);
        }
        const char* getFormattedMinute() {
        return formattedMinute;
    }
        void updateFormattedMinute() {
        sprintf(formattedMinute, "%02d", this->alarmMinute);
    } 
        bool isAlarmTimeNow(uint8_t hour, uint8_t minute){
            if(this->alarmHour == hour && this->alarmMinute == minute){
                return true;
            }
            return false;
        }

        bool getConfigMode(){
            return this->timeUnitIsHour;
        }
         void toggleConfigMode(){
            this->timeUnitIsHour = !this->timeUnitIsHour;
        }
        void increaseAlarmHour(){
            if(this->alarmHour == 23){
                this->alarmHour = 0;
                updateFormattedHour();
            }else{
                this->alarmHour++;
                updateFormattedHour();

            }
        }
        void increaseAlarmMinute(){
            if(this->alarmMinute == 59){
                updateFormattedMinute();
                this->alarmMinute = 0;
            }else{
                updateFormattedMinute();
                this->alarmMinute++;
            }
        }
};