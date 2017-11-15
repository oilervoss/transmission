#!/bin/sh

# Below is a command that will get a list of trackers with one tracker per line
# command can be 'cat /some/path/trackers.txt' for a static list

LIVE_TRACKERS_LIST_CMD='curl -fs --url https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt' 
TRANSMISSION_REMOTE='/usr/bin/transmission-remote'

PARAMETER="$1"
[ "$PARAMETER" = "*" ] || [ "$PARAMETER" = "." ] && PARAMETER=" "
TORRENTS=$($TRANSMISSION_REMOTE -l 2>/dev/null)
if [ $? -ne 0 ]; then
    echo -e "\n\e[0;91;1mFail on transmission. Aborting.\n\e[0m"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo -e "\n\e[31mThis script expects one parameter\e[0m"
    echo -e "\e[0;36maddtracker \t\t- list current torrents "
    echo -e "addtracker \$number\t- add trackers to torrent of number \$number"
    echo -e "addtracker \$name\t- add trackers to first torrent with part of name \$name"	
    echo -e "\n\e[0;32;1mCurrent torrents:\e[0;32m"
    echo "$TORRENTS" | sed -nr 's:(^.{4}).{64}:\1:p'
    echo -e "\n\e[0m"
    exit 1
fi

if [ ! -z "${PARAMETER//[0-9]}" ] ; then
	PARAMETER=$(echo "$TORRENTS" | \
sed -nr '1d;/^Sum:/d;s:(^.{4}).{64}:\1:p' | \
grep -i "$PARAMETER" | \
sed -nr 's:(^.{4}).*:\1:;s: ::gp')

	if [ ! -z "$PARAMETER" ] && [ -z ${PARAMETER//[0-9]} ] ; then
		NUMBERCHECK=1
		echo -e "\n\e[0;32;1mI found the following torrent:\e[0;32m"
		echo "$TORRENTS" | sed -nr 's:(^.{4}).{64}:\1:p' | grep -i "$1"
	else
		NUMBERCHECK=0
	fi
else
	NUMBERCHECK=$(echo "$TORRENTS" | \
sed -nr '1d;/^Sum:/d;s: :0:g;s:^(....).*:\1:p' | \
grep $(echo 0000$PARAMETER | sed -nr 's:.*([0-9]{4}$):\1:p'))

fi

if [ ${NUMBERCHECK:-0} -eq 0 ]; then
	echo -e "\n\e[0;31;1mI didn't find a torrent with the text/number: \e[21m$1"
        echo -e "\n\e[0;32;1mCurrent torrents:\e[0;32m"
	echo "$TORRENTS" | sed -n 's/\(^.\{4\}\).\{64\}/\1/p' 
	echo -e "\e[0m"
	exit 1
fi

TRACKER_LIST=`$LIVE_TRACKERS_LIST_CMD`

if [ $? -ne 0 ] || [ -z "$TRACKER_LIST" ]; then

	TRACKER_LIST="udp://tracker.skyts.net:6969/announce
udp://tracker.safe.moe:6969/announce
udp://tracker.piratepublic.com:1337/announce
udp://tracker.pirateparty.gr:6969/announce
udp://tracker.leechers-paradise.org:6969/announce
udp://tracker.coppersurfer.tk:6969/announce
udp://allesanddro.de:1337/announce
udp://9.rarbg.com:2710/announce
http://p4p.arenabg.com:1337/announce
udp://packages.crunchbangplusplus.org:6969/announce
udp://p4p.arenabg.com:1337/announce
http://tracker.opentrackr.org:1337/announce
udp://tracker.opentrackr.org:1337/announce
udp://wambo.club:1337/announce
udp://trackerxyz.tk:1337/announce
udp://tracker4.itzmx.com:2710/announce
udp://tracker2.christianbro.pw:6969/announce
udp://tracker1.xku.tv:6969/announce
udp://tracker1.wasabii.com.tw:6969/announce
udp://tracker.zer0day.to:1337/announce"

fi

for TORRENT in $PARAMETER; do
	echo -ne "\n\e[0;1;4;32mFor the Torrent: \e[0;4;32m"
	$TRANSMISSION_REMOTE -t $TORRENT -i | sed -nr 's/ *Name: ?(.*)/\1/p'
	echo "$TRACKER_LIST" | while read TRACKER
	do
		if [ ! -z "$TRACKER" ]; then
			echo -ne "\e[0;36;1mAdding $TRACKER\e[0;36m"
			$TRANSMISSION_REMOTE -t $TORRENT -td $TRACKER 1>/dev/null 2>&1 
			if [ $? -eq 0 ]; then
				echo -e " -> \e[32mSuccess! "
			else
				echo -e " - \e[31m< Failed > "
			fi
		fi
	done
done
echo -e "\e[0m"
