#!/usr/bin/env bash
#------------------------------------------------------------
# Autor   : Abner Benedito
# github  : ghostkill73
# Version : 0.0.3 (2024-06-13)
# Date    : 2024/02/29
#------------------------------------------------------------
# CONFIG

# verify
[[ ! -e "$currentSave" ]] && {
	mkdir "./saves/" 2>&-
	printf '%s\n' "$originalSave" > $currentSave
}

autoSave="1" # 1 == on
currentSave="./saves/save.cfg"

source "$currentSave"

originalSave='
# If you dont want to break the game, dont edit
#---------------------------------------------------------
points=0 # points
prod=1 # prod
#---------------------------------------------------------
delay=5 # delay in seconds
icm=1 # delay boost price
#---------------------------------------------------------
# prices
tier1=5
tier2=2000
tier3=10000
#---------------------------------------------------------'


#------------------------------------------------------------
# FUNCTIONS

clear() { printf '\e[2J\e[H'; }
sleep() { read -rt "$1" <> <(:) || :; }
infp() { printf '%s\n' "insufficient points"; sleep "1"; }

saveGame() {
printf '%s\n' "
# If you dont want to break the game, dont edit
#---------------------------------------------------------
points="$points"
prod="$prod"
#---------------------------------------------------------
delay="$delay"
icm="$icm"
#---------------------------------------------------------
tier1="$tier1"
tier2="$tier2"
tier3="$tier3"
#---------------------------------------------------------'
" > ${currentSave}
}

showTitle() {
printf '%s\n' '
  /$$$$$$  /$$$$$$$$ /$$$$$$$$  /$$$$$$  /$$   /$$
 /$$__  $$|__  $$__/| $$_____/ /$$__  $$| $$  | $$
| $$  \__/   | $$   | $$      | $$  \__/| $$  | $$
|  $$$$$$    | $$   | $$$$$   |  $$$$$$ | $$$$$$$$
 \____  $$   | $$   | $$__/    \____  $$| $$__  $$
 /$$  \ $$   | $$   | $$       /$$  \ $$| $$  | $$
|  $$$$$$/   | $$   | $$$$$$$$|  $$$$$$/| $$  | $$
 \______/    |__/   |________/ \______/ |__/  |__/'
}

saveAndExit() {
read -p "Save and exit? (y/N) " exitConfirm

case ${exitConfirm} in

[yY]) saveGame; exit 0 ;;

[nN]) continue ;;

*) ;;

esac # exitConfirm

}

#resetAndExit() { ;}

gameMenu() {
while :; do

#---------------------------------------------------------
delayLevel="$(awk "BEGIN { printf \"%.0f\", log($icm) / log(2) }")"
productionSpeed="$(awk "BEGIN { printf \"%.10f\n\", $delay }")"
generatePoints="$((prod))"
[[ "$autoSave" = '1' ]] && saveGame # auto save
#---------------------------------------------------------

clear; showTitle
printf '%s\n' "
POINTS: ${points}

[LEVEL ${delayLevel}] Production speed: ${productionSpeed}s
[AnyKey] Generate points +${generatePoints}
[1] Shop
[2] Decrease delay [\$ ${icm}]
[EXIT] Save and quit
[RESET] Reset the save"

read -p "> " mainOption

case ${mainOption} in

1)
while :; do

clear; showTitle
printf '%s\n' "
POINTS: ${points}

[1] Improve TIER 1 [\$ ${tier1}]
[2] Improve TIER 2 [\$ ${tier2}]
[3] Improve TIER 3 [\$ ${tier3}]
[R] Return"
read -p "shop> " optionShop

case ${optionShop} in
	1)
	if [[ "$points" -ge "$tier1" ]]; then
		points="$((points - tier1))"
		prod="$((prod + 1))"
		tier1="$((tier1 + 10))"
	else
		infp
	fi
	;;

	2)
	if [[ "$points" -ge "$tier2" ]]; then
		points="$((points - tier2))"
		prod="$((prod + 10))"
		tier2="$((tier2 + 100))"
	else
		infp
	fi
	;;

	3)
	if [[ "$points" -ge "$tier3" ]]; then
		points="$((points - tier3))"
		prod="$((prod + 100))"
		tier3="$((tier3 + 1000))"
	else
		infp
	fi
	;;

	[rR]) break ;;

esac # esac optionShop

done # while option 1
;;

2)
if [[ $points -ge $icm ]]; then
	points="$((points - icm))"
	delay="$(awk "BEGIN { printf \"%.20f\", $delay / 1.2 }")"
	icm="$((icm * 2))"
else
	infp
fi
;;

exit|EXIT) saveAndExit ;;

reset|RESET) : ;;

*) points="$((points + prod))"; sleep "$delay" ;;

esac # esac mainOption

done # main
}

gameMenu
