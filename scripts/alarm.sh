#!/bin/bash

LOG="/var/log/sms/alarmhandler.log"
###CONTROLFILE="/var/lib/smsd/application/control"

# $1 the keyword ALARM
# $2 a date in the format yyyy-mm-dd
# $3 a time in the format hh:mm:ss
# $4 the alarm severity (1 digit number)
# $5 the modem name or SMSD
# $6 the alarm text

echo "$2 $3,$4, $5: $6" >> $LOG

if echo -n "$6" | grep "Modem is not ready to answer commands" >/dev/null; then
  DATE=`date +"%d.%m.%Y alle ore: %T"`
  echo "${DATE},1, $4 - $5 - $6: Alarmhandler riavvierà il servizio sms3. " >> $LOG
  /bin/sleep 30
  systemctl restart sms3
fi
 
if echo -n "$6" | grep "Input/output error" >/dev/null; then
  DATE=`date +"%d.%m.%Y alle ore: %T"`
  echo "${DATE},1, $4 - $5 - $6: Alarmhandler riavvierà il servizio sms3. " >> $LOG
  /bin/sleep 30
  systemctl restart sms3
fi
 
