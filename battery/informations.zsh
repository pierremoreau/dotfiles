#!/bin/zsh
#
# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab
#
# Filename: informations.zsh
# Author: Pierre Moreau <dev@pmoreau.org>


local          OS=`uname`
local HAS_BATTERY=false
if [[ ${OS} == 'Linux' ]]
then
  local LINUX_BATDIR='/sys/class/power_supply/BAT0'
  if [[ -d $LINUX_BATDIR ]]; then
    HAS_BATTERY=true
  fi
fi


function GetBatteryStatus()
{
  if [[ "${HAS_BATTERY}" = false ]]
  then
    echo 'None'
    return
  fi

  local state='Unknown'

  case $OS in
    'Linux')
      state=`cat $LINUX_BATDIR/status`
      ;;

    'Darwin')
      state=`system_profiler SPPowerDataType 2> /dev/null | grep 'Charging' | tail -1 | sed 's/[[:space:]]*Charging: //'`
      local state2=`system_profiler SPPowerDataType 2> /dev/null | grep 'Fully Charged' | tail -1 | sed 's/[[:space:]]*Fully Charged: //'`
      if [[ ${state} == 'No' ]]
      then
        if [[ ${state2} == 'No' ]]
        then
          state='Discharging'
        else
          state='Charged'
        fi
      else
        state='Charging'
      fi
      ;;
  esac

  echo $state
}


function GetBatteryPercentage()
{
  local  remaining
  local       full
  local percentage

  case $OS in
    'Linux')
      remaining=`cat $LINUX_BATDIR/charge_now`
           full=`cat $LINUX_BATDIR/charge_full`
      ;;

    'Darwin')
      remaining=$((`system_profiler SPPowerDataType 2> /dev/null | grep 'Charge Remaining' | sed 's/[[:space:]]*Charge Remaining (mAh): //'`))
           full=$((`system_profiler SPPowerDataType 2> /dev/null | grep 'Full Charge Capacity' | sed 's/[[:space:]]*Full Charge Capacity (mAh): //'`))
  esac

  percentage=$(( 100 * $remaining / $full ))
  if [[ $percentage -gt 100 ]]; then
    percentage=100
  elif [[ $percentage -lt 0 ]]; then
    percentage=0
  fi

  echo $percentage
}

function GetRemainingTime()
{
  local remaining
  local      used
  local  duration=''

  if [[ $(GetBatteryStatus) != 'Discharging' ]]
  then
    echo ${duration}
    return
  fi

  case $OS in
    'Linux')
      remaining=`cat $LINUX_BATDIR/charge_now`
           used=`cat $LINUX_BATDIR/current_now`
      remaining=$((`echo "${remaining}.0"`))
           used=$((`echo "${used}.0"`))
      ;;
    'Darwin')
      remaining=$((`system_profiler SPPowerDataType 2> /dev/null | grep 'Charge Remaining' | sed 's/[[:space:]]*Charge Remaining (mAh): //'`))
           used=$(( 0.0 - `system_profiler SPPowerDataType 2> /dev/null | grep 'Amperage' | sed 's/[[:space:]]*Amperage (mA): //'`))
      ;;
  esac

  duration=$(( ${remaining} / ${used} ))
  if [[ ${duration} -lt 1.0 ]]
  then
    local min=`echo $(( ${duration} * 60.0 )) | sed 's/\..*//'`
    duration="${min}min"
  else
    local hours=`echo ${duration} | sed 's/\..*//'`
    local min=`echo $(((${duration} - ${hours}) * 60.0)) | sed 's/\..*//'`
    duration="${hours}h${min}min"
  fi

  echo $duration
}
