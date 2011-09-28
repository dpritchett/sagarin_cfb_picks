#!/usr/bin/env sh

DATE="`date +\"%d-%b-%Y\"`"

SAGARIN_URL='http://www.usatoday.com/sports/sagarin/fbt11.htm'
RATINGS_FILE='ratings.txt'
SAGARIN_FILE='fbt11.htm'
OUTFILE_NAME="picks-$DATE.txt"

curl $SAGARIN_URL > fbt11.htm
ack-grep -h "^\s+\d" | cut -c 6-60 | sed "s/=.*>//" | cut --complement -c 23-24 > $RATINGS_FILE

ruby pick_winners.rb | tee $OUTFILE_NAME
#uuencode $OUTFILE_NAME $OUTFILE_NAME | mail -s "Weekly Picks" $MY_EMAIL_ADDRESS

#rm $OUTFILE_NAME $SAGARIN_FILE
