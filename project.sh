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
    echo -n "

    [MENU]
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
            echo ""
            awk -F',' '$1 == "Heung-Min Son" {
                print "Team:" $4 ", Apperance:" $6 ", Goal:" $7 ", Assist:" $8
            }' "$PLAYERS"
            echo ""
            ;;
        2)
            echo -n "What do you want to get the team data of league_position[1~20] : "
            read league_position
            awk -F',' -v pos="$league_position" '
            $6 == pos {
                total_matches = $2 + $3 + $4;
                if (total_matches > 0) {
                    winning_rate = $2 / total_matches;
                } else {
                    winning_rate = 0;
                }
                print $6 " " $1 " " winning_rate;
            }' "$TEAMS"
            echo "" 
            ;;
        3)
            echo -n "Do you want to know Top-3 attendance data and average attendance? (y/n) : "
            read answer
            
            if [ "$answer" = "y" ]; then
                echo "***Top-3 Attendance Match***"
                tail -n +2 "$MATCHES" | sort -t ',' -k2,2nr | head -n 3 | awk -F',' '{
    print $3 " vs " $4 " ("$1")\n" $2 " " $7 "\n"
}'
            echo ""
            fi
            ;;
        4)
            echo -n "Do you want to get each team's ranking and the highest-scoring player? (y/n) :"
            read answer

            
            if [ "$answer" = "y" ]; then

                declare -a teams
                declare -a top_scorers

                while IFS=',' read -r name _ _ _ _ position _ _ _; do
                    teams+=("$position,$name")
                done < "teams.csv"
            
                while IFS=',' read -r player_name _ _ team _ _ goals _; do
                    top_scorers+=("$team,$player_name,$goals")
                done < "players.csv"
                
                IFS=$'\n' sorted_teams=($(sort -t, -k1,1n <<< "${teams[*]}"))
                unset IFS

                for team_info in "${sorted_teams[@]}"; do
                    IFS=',' read -r position name <<< "$team_info"
                    echo "$position $name"

                    max_goals=0
                    scorer_info=""
                    for scorer in "${top_scorers[@]}"; do
                        IFS=',' read -r team player goals <<< "$scorer"
                        if [[ "$team" == "$name" && "$goals" -gt "$max_goals" ]]; then
                            max_goals=$goals
                            scorer_info="$player $goals"
                        fi
                    done
                    echo "$scorer_info"
                done
            fi
            echo ""
            ;;
            
        5)
            echo -n "Do you want to modify the format of date? (y/n) :"
            read answer
            if [ "$answer" = "y" ]; then
                sed -n '1,10p' matches.csv | sed -E 's/^([^,]+),.*$/\1/' | sed -E 's/([a-zA-Z]+) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2})(am|pm)/\3\/\1\/\2 \4\5/' | sed -E 's/Jan/01/;s/Feb/02/;s/Mar/03/;s/Apr/04/;s/May/05/;s/Jun/06/;s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/;s/Dec/12/' | sed -E 's/([0-9]{4})\/([0-9]{2})\/([0-9]{1,2}) ([0-9]{1,2}:[0-9]{2})(am|pm)/\1\/\2\/\3 \4\5/'
            fi
            echo ""
            ;;
        6)
            echo "Select team number:"
            awk -F ',' 'NR > 1 {
                if (NR % 2 == 0)
                    printf "%d)\t%s\t", NR-1, $1;
                else
                    print (NR-1) ")\t" $1;
            }' teams.csv

            echo "" 

            read -p "Enter your team number: " team_number

            team_name=$(awk -F ',' 'NR=='"$team_number"' {print $1}' teams.csv)

            awk -F ',' -v team="$team_name" '
            $3 == team {
                goal_diff = $5 - $6
                if (goal_diff > 0) {
                    result[$1] = $3 " " $5 " vs " $6 " " $4 ""
                    if (goal_diff > max_diff) {
                        max_diff = goal_diff
                    }
                }
            }
            END {
                for (date in result) {
                    if (result[date] ~ "(" max_diff " goals difference)") {
                        print date "\n" result[date]
                    }
                }
            }' matches.csv
            echo ""
            ;;
        7)
            exit=true
            ;;
        *)
            echo "Invalid input"
            ;;
    esac

done