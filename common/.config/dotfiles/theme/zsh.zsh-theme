# Biei color palette
biei_base="#05070A"
biei_deep="#0A0D11"
biei_surface="#13181E"
biei_raised="#1B232B"
biei_selection="#223246"
biei_border="#3A4652"
biei_text="#E1E8EC"
biei_secondary="#B8C3CA"
biei_muted="#7D8992"
biei_blue="#7FB5E5"
biei_ice="#A9CCE8"
biei_distant_blue="#6F9FD0"
biei_cyan="#78BBC4"
biei_green="#9CB68E"
biei_violet="#B3A1D6"
biei_peach="#D0A17E"
biei_warning="#D3B26F"
biei_error="#D9858B"

# Cursor shapes
_beam_cursor=$'\e[6 q'
_block_cursor=$'\e[2 q'

# Vim mode indicator (shown in prompt)
# Note: visual|viopp won't trigger - zsh vi-mode stays 'vicmd' during visual selection
function vim_mode_indicator() {
  case $KEYMAP in
    vicmd) print -r -- "%F{${biei_violet}}❯%f " ;;
    viins|main) print -r -- "%F{${biei_green}}❯%f " ;;
    visual|viopp) print -r -- "%F{${biei_warning}}❯%f " ;;
    *) print -r -- "%F{${biei_green}}❯%f " ;;
  esac
}

# Build the full prompt
function _build_prompt() {
  PROMPT='$(vim_mode_indicator)'
  if [[ "$BIEI_SHOW_TIME" == true ]]; then
    PROMPT+="%F{${biei_violet}}%T  "
  fi
  if [[ -n "$SSH_CONNECTION" || $EUID -eq 0 ]]; then
    PROMPT+="%F{${biei_ice}}%n@%m  "
  fi
  PROMPT+="%F{${biei_blue}}%~%{$reset_color%}"
  PROMPT+=' $(git_prompt_info)'
}

# Base prompt behavior. Keep this outside the transient block so the theme works
# if the optional transient prompt section is removed.
function _set_cursor_for_keymap() {
  case $KEYMAP in
    vicmd) print -rn -- "$_block_cursor" ;;
    viins|main) print -rn -- "$_beam_cursor" ;;
  esac
}

function zle-keymap-select() {
  _set_cursor_for_keymap
  zle .reset-prompt
}

function zle-line-init() {
  print -rn -- "$_beam_cursor"
  zle .reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

# Initialize prompt
_build_prompt

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%F{${biei_cyan}}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{${biei_cyan}}) %F{${biei_warning}}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{${biei_cyan}}) %F{${biei_green}}%1{✔%}"

# ==============================================================================
# TRANSIENT PROMPT (optional)
# Collapses previous prompts to "❯" after command execution.
# Source: https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt
#
# To disable: comment out from here to "END TRANSIENT PROMPT"
# ==============================================================================

function _set_transient_prompt() {
  if (( _transient_prompt_compact )); then
    PROMPT="%F{${biei_muted}}❯%f "
  else
    _build_prompt
  fi
}

function zle-line-init() {
  [[ $CONTEXT == start ]] || return 0

  _transient_prompt_compact=0
  _set_transient_prompt
  print -rn -- "$_beam_cursor"
  zle .reset-prompt

  (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]
  zle .recursive-edit
  local -i ret=$?
  (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]

  # Handle Ctrl-D (EOT)
  if [[ $ret == 0 && $KEYS == $'\4' ]]; then
    _transient_prompt_compact=1
    _set_transient_prompt
    zle .reset-prompt
    exit
  fi

  # Collapse prompt and execute
  _transient_prompt_compact=1
  _set_transient_prompt
  zle .reset-prompt
  _transient_prompt_compact=0
  _set_transient_prompt

  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}

_transient_prompt_compact=0
zle -N zle-line-init

# ==============================================================================
# END TRANSIENT PROMPT
# ==============================================================================
