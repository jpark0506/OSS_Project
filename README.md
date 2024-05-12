1번 코드
1. awk -F',' 옵션으로 파일을 처리했습니다.
2. $1 == "Heung-Min Son 조건으로 첫번째 필드인 플레이어 이름이 “Heung-Min Son”인 경우만에만 출력하도록 설정했습니다.
3. 출력 형식은 ${column+1}로 , 정보에 맞는 열을 넣어줬습니다. 코드의 경우 $4,$6,$7,$8 입니다.

2번 코드
1. Read 명령을 이용해 input을 league_position에 받았습니다.
2. awk -F',' 옵션으로 파일을 처리했고, pos 변수를 만들어 league_position값을 넣었습니다.
3. $6 == pos 조건을 만족하는 행만 처리하도록 했고, total_matches 는 2,3,4행의 합으로, If, else 조건문으로 winning_rate를 처리했습니다.

3번 코드
1. Read 명령을 이용해 input을 answer에 받았습니다
2. if [ "$answer" = "y" ] 조건을 사용해 y인 경우에만 작동하도록 했습니다. 
3. tail -n +2 "$MATCHES" - 첫 줄 제외하고 가져올 수 있도록 했습니다.
4. sort -t ',' -k2,2nr - 데이터를 두 번째 필드인 출석 수 기준으로 내림차순 정렬했습니다.
5. head -n 3 - 정렬된 데이터 중 상위 3개 행만 선택했습니다.
6. awk -F',' '{ print $3 " vs " $4 " ("$1")\n" $2 " " $7 "\n" - awk -F',' 옵션으로 파일을 처리했고, 조건에 맞춰 출력했습니다. 
4번 코드
1. Read 명령을 이용해 input을 answer에 받았습니다
2. if [ "$answer" = "y" ] 조건을 사용해 y인 경우에만 작동하도록 했습니다. 
3. declare -a 옵션을 이용해 teams, top_scorers 배열을 선언했습니다.
4. while IFS=',' read -r name _ _ _ _ position _ _ _;  팀 이름, 리그 포지션을 csv와 파싱했습니다.
5. teams+=("$position,$name”)을 통해 teams 변수에 팀들을 추가해줬습니다.
6. while IFS=',' read -r player_name _ _ team _ _ goals _; 플레이어 이름, 플레이어가 속한 팀, 선수의 최대 골 수를 csv와 파싱했습니다.
7. top_scorers+=("$team,$player_name,$goals") 을 통해 top_scorers 변수에 선수들을 추가했습니다.
8. IFS=$'\n' sorted_teams=($(sort -t, -k1,1n <<< "${teams[*]}")) teams 배열을 리그 순위 순으로 정렬해 sorted_teams에 넣어줬습니다.
9. sorted_teams를 순회하는 반복문을 만들고, team_info에 해당하는 선수들을의 max_goal를 top_scorers를 순회하는 반복문을 통해 뽑아 출력했습니다.

5번 코드
1. Read 명령을 이용해 input을 answer에 받았습니다
2. if [ "$answer" = "y" ] 조건을 사용해 y인 경우에만 작동하도록 했습니다.
3. sed -E 's/^([^,]+),.*$/\1/ 는 각 줄의 첫번째 콤마 전까지의 날짜 필드만 추출했습니다.
4. sed -E 's/([a-zA-Z]+) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2})(am|pm)/\3\/\1\/\2 \4\5/를 통해 추출된 날짜 형식을  년/월/일 시간(am/pm) 형태로 변경했습니다.
5. s/Jan/01/;s/Feb/02/;s/Mar/03/;s/Apr/04/;s/May/05/;s/Jun/06/;s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/;s/Dec/12/는 월 이름에 해당하는 숫자로 변경했습니다.
6. sed -E 's/([0-9]{4})\/([0-9]{2})\/([0-9]{1,2}) ([0-9]{1,2}:[0-9]{2})(am|pm)/\1\/\2\/\3 \4\5/을 통해 전단계의 출력을 통해 변경된 월을 형식에 맞게 없데이트 했습니다.

6번 코드(정렬 조건이 없어 날짜 기준으로 정렬하지 않았습니다.)
1. echo "Select team number:"
            awk -F ',' 'NR > 1 {
                if (NR % 2 == 0)
                    printf "%d)\t%s\t", NR-1, $1;
                else
                    print (NR-1) ")\t" $1;
            }' teams.csv
   을 통해 팀 목록을 1줄에 2개 팀, teams.csv가 변경되더라고 가능하게 했습니다.
2. read -p "Enter your team number: " team_number 를 통해 team_number를 가져왔습니다.
3. team_name=$(awk -F ',' 'NR=='"$team_number"' {print $1}' teams.csv)을 통해 입력받은 번호의 이름을 가져올 수 있도록 했습니다.
4. $3 == team {
                goal_diff = $5 - $6
                if (goal_diff > 0) {
                    result[$1] = $3 " " $5 " vs " $6 " " $4 ""
                    if (goal_diff > max_diff) {
                        max_diff = goal_diff
                    }
                }
            }
을 통해 골 차이를 계산하고, 가장 차이가 큰 경우를 찾았습니다.
4.  END {
                for (date in result) {
                    if (result[date] ~ "(" max_diff " goals difference)") {
                        print date "\n" result[date]
                    }
                }
            }' matches.csv
에서는 최대 골 차이를 기록한 경기를 형식에 맞게 출력했습니다.
