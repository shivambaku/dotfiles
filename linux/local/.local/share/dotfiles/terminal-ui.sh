if [[ ${SB_TERMINAL_UI_LOADED:-} == 1 ]]; then
  return
fi
readonly SB_TERMINAL_UI_LOADED=1

SB_UI_RESET=''
SB_UI_BOLD=''
SB_UI_MUTED=''
SB_UI_SECONDARY=''
SB_UI_BLUE=''
SB_UI_ICE=''
SB_UI_GREEN=''
SB_UI_WARNING=''
SB_UI_ERROR=''

if [[ -t 1 && -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]]; then
  SB_UI_RESET=$'\e[0m'
  SB_UI_BOLD=$'\e[1m'
  SB_UI_MUTED=$'\e[90m'
  SB_UI_SECONDARY=$'\e[37m'
  SB_UI_BLUE=$'\e[34m'
  SB_UI_ICE=$'\e[94m'
  SB_UI_GREEN=$'\e[32m'
  SB_UI_WARNING=$'\e[33m'
  SB_UI_ERROR=$'\e[31m'
fi

sb_ui_disable() {
  SB_UI_RESET=''
  SB_UI_BOLD=''
  SB_UI_MUTED=''
  SB_UI_SECONDARY=''
  SB_UI_BLUE=''
  SB_UI_ICE=''
  SB_UI_GREEN=''
  SB_UI_WARNING=''
  SB_UI_ERROR=''
}

sb_ui_title() {
  printf '%s%sSB%s %s/%s %s%s%s\n' \
    "$SB_UI_BOLD" "$SB_UI_BLUE" "$SB_UI_RESET" "$SB_UI_MUTED" \
    "$SB_UI_RESET" "$SB_UI_ICE" "$1" "$SB_UI_RESET"
  printf '%s%s%s\n' "$SB_UI_MUTED" '--------------------------------------------------------' "$SB_UI_RESET"
}

sb_ui_section() {
  printf '\n%s%s%s%s\n' "$SB_UI_BOLD" "$SB_UI_ICE" "$1" "$SB_UI_RESET"
}

sb_ui_field() {
  local label=$1 value=$2 tone=${3:-default} color=''

  case $tone in
    good) color=$SB_UI_GREEN ;;
    warning) color=$SB_UI_WARNING ;;
    error) color=$SB_UI_ERROR ;;
    accent) color=$SB_UI_ICE ;;
  esac
  printf '  %s%-15s%s %s%s%s\n' \
    "$SB_UI_SECONDARY" "$label" "$SB_UI_RESET" "$color" "$value" "$SB_UI_RESET"
}

sb_ui_choice() {
  local key=$1 label=$2 description=${3:-}

  if [[ -n $description ]]; then
    printf '  %s%s%s  %s%-12s%s %s%s%s\n' \
      "$SB_UI_BLUE" "$key" "$SB_UI_RESET" "$SB_UI_ICE" "$label" "$SB_UI_RESET" \
      "$SB_UI_SECONDARY" "$description" "$SB_UI_RESET"
  else
    printf '  %s%s%s  %s%s%s\n' \
      "$SB_UI_BLUE" "$key" "$SB_UI_RESET" "$SB_UI_ICE" "$label" "$SB_UI_RESET"
  fi
}

sb_ui_item() {
  local tone=$1 label=$2 text=$3 color=''

  case $tone in
    good) color=$SB_UI_GREEN ;;
    warning) color=$SB_UI_WARNING ;;
    error) color=$SB_UI_ERROR ;;
    accent) color=$SB_UI_ICE ;;
  esac
  printf '  %s%s%-10s%s %s\n' "$SB_UI_BOLD" "$color" "$label" "$SB_UI_RESET" "$text"
}

sb_ui_prompt() {
  local ice='' reset=''

  if [[ -t 2 && -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]]; then
    ice=$'\e[94m'
    reset=$'\e[0m'
  fi
  printf '\n%s>%s %s: ' "$ice" "$reset" "$1" >&2
}

sb_ui_info() {
  printf '%s%s::%s %s\n' "$SB_UI_BOLD" "$SB_UI_BLUE" "$SB_UI_RESET" "$1"
}

sb_ui_success() {
  printf '%s%sOK%s %s\n' "$SB_UI_BOLD" "$SB_UI_GREEN" "$SB_UI_RESET" "$1"
}

sb_ui_warning() {
  local bold='' color='' reset=''

  if [[ -t 2 && -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]]; then
    bold=$'\e[1m'
    color=$'\e[33m'
    reset=$'\e[0m'
  fi
  printf '%s%sWARN%s %s\n' "$bold" "$color" "$reset" "$1" >&2
}

sb_ui_error() {
  local bold='' color='' reset=''

  if [[ -t 2 && -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]]; then
    bold=$'\e[1m'
    color=$'\e[31m'
    reset=$'\e[0m'
  fi
  printf '%s%sERROR%s %s\n' "$bold" "$color" "$reset" "$1" >&2
}
