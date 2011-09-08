#!/usr/bin/env sh
rm fbt11.htm
wget http://www.usatoday.com/sports/sagarin/fbt11.htm
ack-grep -h "^\s+\d" | cut -c 6-60 | sed "s/=.*>//" | cut --complement -c 23-24 > ratings.txt

ruby pick_winners.rb
