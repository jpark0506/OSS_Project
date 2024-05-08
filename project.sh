#!/bin/bash

echo "
************OSS1 - Project1************
* StudentID : 12202078 *
* Name : 박준혁 *
***************************************
"

if [ "$#" -ne 3 ]; then
    echo "arg not 3"
fi

MATCHES="$1"
PLAYERS="$2"
TEAMS="$3"

for FILE in $matches $players $teams
do
    if [ ! -f "$FILE" ]; then
        echo "Error: File '$FILE' not found!"
    fi
done

echo " FILE CHECK DONE"

exit=false

while [ $exit = false ]
do
    echo -n "[MENU]
1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in
players.csv
2. Get the team data to enter a league position in teams.csv
3. Get the Top-3 Attendance matches in mateches.csv
4. Get the team's league position and team's top scorer in teams.csv & players.csv
5. Get the modified format of date_GMT in matches.csv
6. Get the data of the winning team by the largest difference on home stadium in teams.csv
& matches.csv
7. Exit
Enter your CHOICE (1~7) :"
    read input
    case $input in
        1)
            sleep 1000
            awk -F',' '$1 == "Heung-Min Son" {
                print "Team:" $4 ", Apperance:" $6 ", Goal:" $7 ", Assist:" $8
            }' "$PLAYERS"
            ;;
        2)
            echo -n "What do you want to get the team data of league_position[1~20] : "
            read league_position
            awk -F',' -v pos="$league_position" '
            $6 == pos {  # Match the league position in the sixth column
                total_matches = $2 + $3 + $4;  # Wins + Draws + Losses
                if (total_matches > 0) {
                    winning_rate = $2 / total_matches;  # Calculate winning rate
                } else {
                    winning_rate = 0;
                }
                print $6 " " $1 " " winning_rate;
            }' "$TEAMS"
            sleep 2
            ;;
        3)
            echo -n "Do you want to know Top-3 attendance data and average attendance? (y/n) : "
            read answer
            
            if [ "$answer" = "y" ]; then
                echo "***Top-3 Attendance Match***"
                tail -n +2 "$MATCHES" | sort -t ',' -k2,2nr | head -n 3 | awk -F',' '{
    print $3 " vs " $4 " ("$1")\n" $2 " " $7 "\n"
}'
            sleep 2
            fi
            ;;
        4)
            echo "4"
            ;;
        5)
            echo -n "Do you want to modify the format of date? (y/n) :"
            read answer
            if [ "$answer" = "y" ]; then
                sed -n '1,10p' matches.csv | sed -E 's/^([^,]+),.*$/\1/' | sed -E 's/([a-zA-Z]+) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2})(am|pm)/\3\/\1\/\2 \4\5/' | sed -E 's/Jan/01/;s/Feb/02/;s/Mar/03/;s/Apr/04/;s/May/05/;s/Jun/06/;s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/;s/Dec/12/' | sed -E 's/([0-9]{4})\/([0-9]{2})\/([0-9]{1,2}) ([0-9]{1,2}:[0-9]{2})(am|pm)/\1\/\2\/\3 \4\5/'
            fi
            ;;
        6)
            echo "6"
            ;;
        7)
            exit=true
            ;;
        *)
            echo "Invalid input"
            ;;
    esac

done