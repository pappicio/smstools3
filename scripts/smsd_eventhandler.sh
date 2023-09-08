#!/bin/bash 

###echo test chiamata   $1 - $2 - $3 > /tmp/chiamata_a_prescindere.txt

###  apt-get install procmail

COUNTRY_CODE="+39"
ADMIN_TO="393519182780" # Change this number!

send_sms()
{
# $1 = To
# $2 = Message
# $3 = From

        FILE=$(mktemp -t send_XXXXXX)
	echo "From: $3" > $FILE
        echo "To: $1" >> $FILE
        ###if [ "x$3" != "x" ]; then
        ###        echo "$3" >> $FILE
        ###fi

        echo "Commento: Risposta Automatica da smstools eventhandler" >> $FILE
        echo "" >> $FILE
        echo -n "$2" >> $FILE
        FILE2='/var/spool/sms/outgoing/'
	###FILE2='/var/spool/sms/modem1/'
        mv $FILE $FILE2
}


if [ "$1" = "CALL" ]; then
	DATE=`date +"%d.%m.%Y alle ore: %H:%M:%S"`
	FROM=`formail -zx From: < $2`
	FROM_TOA=`formail -zx From_TOA: < $2`
	MODEM=`formail -zx Modem: < $2`
	TEXT=`sed -e '1,/^$/ d' < $2`

        if [ "x$FROM" != "x" ]; then
                if [ "${FROM:0:1}" = "0" ]; then
                        FROM="$COUNTRY_CODE${FROM:1}"
                fi

                send_sms "$FROM" "Questo numero non accetta Chiamate, solo SMS; eventualmente, inviare un SMS!" "SMS EventHandler!"

                if [ "x$ADMIN_TO" != "x" ]; then
                        send_sms "$ADMIN_TO" "Chiamata ricevuta dal numero: $FROM, il: $DATE" "SMS EventHandler!"
                fi
        fi
fi


# SMS forwarding Eliminare le 3 XxX !!!.
if [ "$1" = "RECEIVEDXXX" ]; then

  FORWARD_TO="393519182780" ###cambiare questo numero...
  FROM=`formail -zx From: < $2`
  FROM_TOA=`formail -zx From_TOA: < $2`
  MODEM=`formail -zx Modem: < $2`
  TEXT=`sed -e '1,/^$/ d' < $2`
  
  FILE=$(mktemp -t send_XXXXXX)
  echo "From: $FROM" > $FILE
  echo "To: $FORWARD_TO" >> $FILE
  echo "" >> $FILE
  echo "ricevuto SMS da: $FROM , testo SMS: $TEXT" >> $FILE
  FILE2='/var/spool/sms/outgoing/'
  ###FILE2='/var/spool/sms/modem1/'
  mv $FILE $FILE2
fi
