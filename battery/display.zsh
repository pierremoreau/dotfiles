#!/bin/zsh


CURRENT_DIR="$(dirname $0)"
source ${CURRENT_DIR}/informations.zsh

function DisplayBattery()
{
  local state=$(GetBatteryStatus)
  if [[ ${state} == 'None' ]]
  then
    echo ''
    return
  fi

  local percentage=$(GetBatteryPercentage)

  case ${state} in
    'Charging')
      local icon="${__MYCOLOR_FGGREEN}▲${__MYCOLOR_RESET}"
      ;;
    'Discharging')
      if [[ ${percentage} -lt 10 ]]
      then
        local ratio_color="${__MYCOLOR_BGRED}"
      elif [[ ${percentage} -lt 20 ]]
      then
        local ratio_color="${__MYCOLOR_FGRED}"
      elif [[ ${percentage} -lt 50 ]]
      then
        local ratio_color="${__MYCOLOR_FGYELLOW}"
      elif [[ ${percentage} -lt 99 ]]
      then
        local ratio_color="${__MYCOLOR_FGGREEN}"
      fi
      local icon="${ratio_color}▼${__MYCOLOR_RESET}"

      local duration=$(GetRemainingTime)
      if [[ ${duration} != '' ]]
      then
        duration=" (${duration})"
      fi
      ;;
    *)
      exit 1
      ;;
  esac

  echo "${icon}${percentage}${__MYCHAR_ESC}%${duration}"
}
