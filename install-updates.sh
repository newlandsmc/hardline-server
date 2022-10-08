#!/bin/bash

#git -C /var/minecraft/hardline/plugins/Expeditions/loot/ pull
rsync -Ir --remove-source-files /var/minecraft/hardline/pending-updates/* /var/minecraft/hardline/plugins/
find /var/minecraft/hardline/pending-updates/* -depth -type d -empty -delete

exit 0
