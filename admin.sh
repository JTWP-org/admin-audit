#!/bin/bash

#CONFIG

#where are the log files located use a space between DIR to use more than one
logLoc="/home/steam/*/Pavlov/Saved/Logs/*.log /home/steam/logs/*/Pavlov/Saved/Logs/*.log"


#a csv file with all admins in this format
#       DISCORD NAME,DISCORD ID,STEAM ID

#loop with each line of the csv
while read line; do

        #basic info
        discordName=$(echo $line | awk -F ',' '{print $1}')
        discordId=$(echo $line | awk -F ',' '{print $2}')
        steamId=$(echo $line | awk -F ',' '{print $3}')

        #stats
        cons=$(sudo grep "TicketValidation succeed for: $steamId"  ${logLoc}   | awk -F '[' '{print $2}'  | tr -d ']' | awk -F "-" '{print " " $1 "\\n" }')
        consNum=$(echo $cons | wc -w)
        mth=$(date +%m)
        consCur=$(echo $cons | grep "????.${mth}.??")
        consCurNum=$(echo $consCur | wc -w)



        echo """
SCRIPT LOG $(date "+%x %r") = script is cheaking admin ingame activity
current admin : $discordName
        STEAM ID64 : $steamId
        DISCORD ID : $discordId
        TOTAL CONNECTIONS : $consNum
        CONNECTIONS THIS MONTH : $consCurNum
------------------------------------
"""



#check for admin FAIL
if [ "$consNum"  = 0 ]; then
        ./discord.sh \
        --title "Admin Reportcard" \
        --text  `date "+%x %r` \
        --author "${discordName}" \
        --thumbnail "https://cdn.discordapp.com/attachments/949594481223684106/1111082979855454259/Reportcard.png"
#everyone else
else
    ./discord.sh --webhook-url="$WEBHOOK"  --text " $(echo \<\@${discordId}\>) (${discordName}) activity status : ${consCurNum}/${consNum}  \n THIS MONTH / ALL TIME "

fi
done < adminID
