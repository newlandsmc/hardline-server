#!/bin/bash

rconHost='147.135.3.153'
rconPort='25575'
rconPass='RyPgEHV3nyLWq0ZGoiSjGfzbkOqA4Vy7'

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 5 minutes. The main end island will reset on this reboot.'

sleep 240

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 1 minute. The main end island will reset on this reboot.'

sleep 30

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 30 seconds. The main end island will reset on this reboot.'

sleep 25

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 5 seconds.'

sleep 1

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 4 seconds.'

sleep 1

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 3 seconds.'

sleep 1

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 2 seconds.'

sleep 1

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'broadcast &cHardline rebooting in 1 second.'
/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'endrespawn'

sleep 1

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'whitelist on'
rebooting=1

sudo systemctl stop minecraft

rm -f /var/minecraft/server/worlds/world_the_end/DIM1/region/r.0.0.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/region/r.0.-1.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/region/r.-1.0.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/region/r.-1.-1.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/entities/r.0.0.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/entities/r.0.-1.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/entities/r.-1.0.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/entities/r.-1.-1.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/poi/r.0.0.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/poi/r.0.-1.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/poi/r.-1.0.mca
rm -f /var/minecraft/server/worlds/world_the_end/DIM1/poi/r.-1.-1.mca

/var/minecraft/nbted/nbted -p /var/minecraft/server/worlds/world_the_end/level.dat > temp.txt

sed -i -E '/\t{4}[0-9]{1,2}$/d' temp.txt
sed -i -E 's/Byte "DragonKilled" 1/Byte "DragonKilled" 0/g' temp.txt
sed -i -E 's/List "Gateways" (End 0|Int [0-9]+)/List "Gateways" Int 20/g' temp.txt

array=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19")
array=($(shuf -e "${array[@]}"))
index=0

for i in {1..20}
do
  echo -e "\t\t\t\t${array[$index]}" >> temp2.txt
  index=$index+1
done

sed -i -E '/List "Gateways" Int 20/r temp2.txt' temp.txt

/var/minecraft/nbted/nbted -r temp.txt > /var/minecraft/server/worlds/world_the_end/level.dat

rm -f temp.txt
rm -f temp2.txt

sudo systemctl start minecraft

while [ $rebooting -eq 1 ]
do
  if [[ -n $(journalctl --since "10 seconds ago" --no-pager | grep -Ei "Done \([0-9.]+s\)! For help, type \"help\"") ]]
  then
    rebooting=0
  fi
  sleep 3
done

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'chunky world world_the_end'
/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'chunky center 0 0'
/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'chunky radius 528'
/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'chunky start'
/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'whitelist off'
