#!/usr/bin/env sh

SAGARIN_URL='http://www.usatoday.com/sports/sagarin/fbt11.htm'
SAGARIN_FILE='fbt11.htm'
OUTFILE_NAME='newest_picks.txt'

rm $SAGARIN_FILE
wget -q $SAGARIN_URL
ack-grep -h "^\s+\d" | cut -c 6-60 | sed "s/=.*>//" | cut --complement -c 23-24 > ratings.txt

ruby pick_winners.rb | tee $OUTFILE_NAME | mail $MY_EMAIL_ADDRESS --subject="Weekly Picks"
cat $OUTFILE_NAME
rm  $OUTFILE_NAME
