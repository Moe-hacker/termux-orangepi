#!/bin/bash
adb push init /sdcard/1
while :
do
  HOSTNAME=$(hostname)
  TEMP=$(</sys/class/thermal/thermal_zone0/temp)
  TEMP=$(($TEMP/1000))
  _TEMP=$TEMP
  TEMP="$TEMP°C"
  MEMORY="$(free -tm | grep "Mem" | awk {'print $3'})M/$(free -tm | grep "Mem" | awk {'print $2'})M"
  DISK="$(df -h -t ext4|grep mmc|awk {'print $3'})/$(df -h -t ext4|grep mmc|awk {'print $2'})"
  UPTIME_S=$(cat /proc/uptime |awk {'print $1'}|cut -d . -f 1)
  UPTIME_M="$(($UPTIME_S/60))"
  if (($UPTIME_M >= 60));then
    UPTIME_H=$(($UPTIME_M/60))
    UPTIME_M=$(($UPTIME_M%60))
    if (( $UPTIME_H >= 24 ));then
      UPTIME_D=$(($UPTIME_H/24))
      UPTIME_H=$(($UPTIME_H%24))
      UPTIME="${UPTIME_D}d${UPTIME_H}h${UPTIME_M}min"
    else
      UPTIME="${UPTIME_H}h${UPTIME_M}min"
   fi
  else
    UPTIME="${UPTIME_M}min"
  fi
  IP=$(ip addr show eth0|grep 192|awk {'print $2'}|cut -d '/' -f 1)
  PORT=$(cat /etc/ssh/sshd_config|grep Port|grep -v "#"|awk {'print $2'})
  echo -e "HOSTNAME=\"$HOSTNAME\"\nTEMP=\"$TEMP\"\nMEMORY=\"$MEMORY\"\nDISK=\"$DISK\"\nUPTIME=\"$UPTIME\"\nIP=\"$IP\"\nPORT=\"$PORT\"\n_TEMP=\"$_TEMP\"" > /tmp/opinfo
  adb push /tmp/opinfo /sdcard/info
  sleep 3s
done
