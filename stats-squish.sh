mysqluser="aurelium"
mysqlpass="NHCwp2D6NU9Z8cX5"
mysqldb="hardline_aurelium"
discordwebhookurl="https://discord.com/api/webhooks/1032109243190485064/xx0nGNa4RrJsidPric6nu-KhL3t7jt9LqOdrPPKAD1eKN_OcYo8_zZA3-3QtuFMtuKbe"

mysql_call() {
  mysql -u $mysqluser -p$mysqlpass -D $mysqldb -e "$1" --vertical --column-names=FALSE | sed '/^\*\*\*/d'
}

generate_leaderboard() {
  declare -a rawLeaderboard=()
  highestLevel=$(mysql_call "SELECT MAX($1) FROM SkillData")
  for i in $(mysql_call "SELECT ID FROM SkillData WHERE $1=$highestLevel"); do
    rawLeaderboard+=($(cat /var/minecraft/hardline/usercache.json | jq ".[] | select(.uuid == \"$i\")" | jq -r ".name" | sed 's/\(_\|\*\)/\\\\\1/')) > /dev/null
  done

  delim=""
  count=1
  for j in ${rawLeaderboard[@]}; do
    printf "%s" "$delim**$count.** $j (Level $highestLevel)"
    delim="\n"
    count=$((count+1))
  done
}

stats_squish() {
  for k in $(mysql_call "SELECT column_name FROM information_schema.columns WHERE table_name = 'SkillData' AND table_schema = 'hardline_aurelium'"); do
    if [[ $k =~ .*_XP ]]; then
      mysql_call "UPDATE SkillData SET $k = 0"
    fi
    if [[ $k =~ .*_LEVEL ]]; then
      mysql_call "UPDATE SkillData SET $k = $k/2"
    fi
  done
}

discord_webhook_call() {
  curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$1\"}" $discordwebhookurl
}

fightingLeaderboard=$(generate_leaderboard FIGHTING_LEVEL)
archeryLeaderboard=$(generate_leaderboard ARCHERY_LEVEL)
defenseLeaderboard=$(generate_leaderboard DEFENSE_LEVEL)

stats_squish

discord_webhook_call "**__NEW MONTH STATS SQUISH__**\n\n\
A new month is here and stats have been squashed! All players stats have been reduced by 50%. Time to get your grind on! \n\n\
Top FIGHTING players last month:\n$fightingLeaderboard\n\n\
Top ARCHERY players last month:\n$archeryLeaderboard\n\n\
Top DEFENSE players last month:\n$defenseLeaderboard\n\n\
@everyone"
