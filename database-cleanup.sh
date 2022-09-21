#!/bin/bash

rconHost='147.135.3.153'
rconPort='25575'
rconPass='RyPgEHV3nyLWq0ZGoiSjGfzbkOqA4Vy7'

/var/minecraft/mcrcon/mcrcon -H $rconHost -P $rconPort -p $rconPass 'co purge t:30d'
