#!/bin/bash

ADDR="kQDpgasejCQgh7pdtEq2WJw9RMyKcQ2RPpK_qdJaBEX3LT-m"

RESULT=`run-lite-client runmethod $ADDR stats | grep "^result:"`

echo $RESULT | awk '{print $3}' | xargs printf "Total games played: %i\n"
echo $RESULT | awk '{print $4}' | xargs printf "Won games: %i\n"
echo $RESULT | awk '{print $5}' | xargs printf "Lost games: %i\n"
echo $RESULT | awk '{print $6}' | xargs from-nano | xargs printf "Won amount: %s\n"
echo $RESULT | awk '{print $7}' | xargs from-nano | xargs printf "Lost amount: %s\n"
echo $RESULT | awk '{print $8}' | xargs from-nano | xargs printf "Withdrawn amount: %s\n"
