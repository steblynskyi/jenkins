#!/bin/bash

# Zero padded days using %d instead of %e
DAYSAGO=`date --date="30 days ago" +%Y%m%d`
ALLLINES=`/usr/bin/curl -s -XGET http://127.0.0.1:9200/_cat/indices?v | egrep logstash`

echo
echo "THIS IS WHAT SHOULD BE DELETED FOR ELK:"
echo

echo "$ALLLINES" | while read LINE
do
  FORMATEDLINE=`echo $LINE | awk '{ print $3 }' | awk -F'-' '{ print $2 }' | sed 's/\.//g' ` 
  if [ "$FORMATEDLINE" -lt "$DAYSAGO" ]
  then
    TODELETE=`echo $LINE | awk '{ print $3 }'`
    echo "http://127.0.0.1:9200/$TODELETE"
  fi
done

echo
echo -n "if this make sence, Y to continue N to exit [Y/N]:"
read INPUT
if [ "$INPUT" == "Y" ] || [ "$INPUT" == "y" ] || [ "$INPUT" == "yes" ] || [ "$INPUT" == "YES" ]
then
  echo "$ALLLINES" | while read LINE
  do
    FORMATEDLINE=`echo $LINE | awk '{ print $3 }' | awk -F'-' '{ print $2 }' | sed 's/\.//g' `
    if [ "$FORMATEDLINE" -lt "$DAYSAGO" ]
    then
      TODELETE=`echo $LINE | awk '{ print $3 }'`
      /usr/bin/curl -XDELETE http://127.0.0.1:9200/$TODELETE
      sleep 1
      fi
  done
else 
  echo SCRIPT CLOSED BY USER, BYE ...
  echo
  exit
fi
