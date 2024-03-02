#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Script  : menu.sh
# Desc    : STESH incremental game 
# Version : 0.0.2v
# Autor   : ghostkill73 <github.com/ghostkill73>
# Date    : 2024/02/29
# --------------------------------------------------------------------------------
# License : Intellectual property does not exist.
# Product free for changes, distribution and sale.
# It is not necessary to ask the author for permission.
# --------------------------------------------------------------------------------

# ==============================[CONFIG]============================
infp="insufficient points."
sep="# ------------------------------------------------------------"

# =============================[SOURCES]============================
source ./game/save.cfg
source ./config/logo.cfg

# ==============================[GAME]==============================
while true; do
clear
    cat config/logo.cfg 2> /dev/null
    echo "the bash incremental game"
    echo
    echo "Points: $points"
    echo "[LEVEL $(awk "BEGIN { printf \"%.0f\", log($icm) / log(2) }")] Production speed: $(awk "BEGIN { printf \"%.10f\n\", $delay }")s"
	echo "[1] Generate points +$(($prod + $prod2 + $prod3))"
	echo "[2] Machine shop"
	echo "[3] Decrease delay [$ $icm]"
	echo "[EXIT] Save and quit"
	echo "[RESET] Reset Game"
	echo
    read -p "> " option

    case $option in
        1)
            points=$((points + prod))
            points=$((points + prod2))
            points=$((points + prod3))
            sleep $delay
            ;;
        2)
			while true; do
			clear
				echo "STESH - SHOP"
				echo "Points: $points"
				echo "[1] Improve production (TIER 1) [$ $tier1]"
				echo "[2] Improve production (TIER 2) [$ $tier2]"
				echo "[3] Improve production (TIER 3) [$ $tier3]"
				echo "[4] Return to game" 
				read -p "shop> " optionShop
					case $optionShop in
						1)
							if [ $points -ge $tier1 ]; then
               					points=$((points - $tier1))
               					prod=$((prod + 1))
               					tier1=$((tier1 + 2))
      						else
              					echo "$infp"
               					sleep 1
      						fi
      						;;
      					2)
							if [ $points -ge $tier2 ]; then
               					points=$((points - $tier2))
               					prod2=$((prod2 + 10))
               					tier2=$((tier2 + 25))
      						else
              					echo "$infp"
               					sleep 1
      						fi
      						;;
      					3)
							if [ $points -ge $tier3 ]; then
               					points=$((points - $tier3))
               					prod3=$((prod3 + 100))
               					tier3=$((tier3 + 250))
      						else
              					echo "$infp"
               					sleep 1
      						fi
      						;;
      					4)
      						break
      						;;
      					*)
      						;;
      				esac
			done
            ;;
        3)
       		if [ $points -ge $icm ]; then
       			points=$((points - icm))
       			delay=$(awk "BEGIN { printf \"%.20f\", $delay / 1.2 }")
       			icm=$((icm * 2))
       		else
                echo "$infp" 
                sleep 1
       		fi
       		;;
        EXIT)
            echo "Exiting..."
            echo "# If you don't want to break the game, don't edit" > ./game/save.cfg
            echo "$sep" >> ./game/save.cfg
            echo "points=$points" >> ./game/save.cfg
            echo "$sep" >> ./game/save.cfg
            echo "prod=$prod" >> ./game/save.cfg
            echo "prod2=$prod2" >> ./game/save.cfg
            echo "prod3=$prod3" >> ./game/save.cfg
            echo "$sep" >> ./game/save.cfg
            echo "delay=$delay" >> ./game/save.cfg
            echo "icm=$icm" >> ./game/save.cfg
            echo "$sep" >> ./game/save.cfg
            echo "tier1=$tier1" >> ./game/save.cfg
            echo "tier2=$tier2" >> ./game/save.cfg
            echo "tier3=$tier3" >> ./game/save.cfg
            echo "$sep" >> ./game/save.cfg
            break
            ;;
        RESET)
       		read -p "reset progress game?(y/n)> " resetD
       			if [ "$resetD" = "y" ]; then
       				cat "./config/originalsave.cfg" > "./game/save.cfg"
       				sleep 3
       				echo "game reset successfully!"
       				exit 0
       			elif [ "$resetD" = "n" ]; then
       				echo "returning..."
       				sleep 1
       			else
       				echo "error, please enter a valid option."
       				sleep 2
       				return
       			fi
       		;;
        *)
            ;;
    esac
done    