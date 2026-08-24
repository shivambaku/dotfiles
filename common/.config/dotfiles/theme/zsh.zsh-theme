# Hokkaido Snow color palette
hokkaido_snow_base="#05070A"
hokkaido_snow_deep="#0A0D11"
hokkaido_snow_surface="#13181E"
hokkaido_snow_raised="#1B232B"
hokkaido_snow_selection="#223246"
hokkaido_snow_border="#3A4652"
hokkaido_snow_text="#E1E8EC"
hokkaido_snow_secondary="#B8C3CA"
hokkaido_snow_muted="#7D8992"
hokkaido_snow_blue="#7FB5E5"
hokkaido_snow_ice="#A9CCE8"
hokkaido_snow_distant_blue="#6F9FD0"
hokkaido_snow_cyan="#78BBC4"
hokkaido_snow_green="#9CB68E"
hokkaido_snow_violet="#B3A1D6"
hokkaido_snow_peach="#D0A17E"
hokkaido_snow_warning="#D3B26F"
hokkaido_snow_error="#D9858B"

# Cursor shapes
_beam_cursor=$'\e[6 q'
_block_cursor=$'\e[2 q'

# Vim mode indicator (shown in prompt)
# Note: visual|viopp won't trigger - zsh vi-mode stays 'vicmd' during visual selection
function vim_mode_indicator() {
  case $KEYMAP in
    vicmd) print -r -- "%F{${hokkaido_snow_violet}}❯%f " ;;
    viins|main) print -r -- "%F{${hokkaido_snow_green}}❯%f " ;;
    visual|viopp) print -r -- "%F{${hokkaido_snow_warning}}❯%f " ;;
    *) print -r -- "%F{${hokkaido_snow_green}}❯%f " ;;
  esac
}

# Build the full prompt
function _build_prompt() {
  PROMPT='$(vim_mode_indicator)'
  if [[ "$HOKKAIDO_SNOW_SHOW_TIME" == true ]]; then
    PROMPT+="%F{${hokkaido_snow_violet}}%T  "
  fi
  if [[ -n "$SSH_CONNECTION" || $EUID -eq 0 ]]; then
    PROMPT+="%F{${hokkaido_snow_ice}}%n@%m  "
  fi
  PROMPT+="%F{${hokkaido_snow_blue}}%~%{$reset_color%}"
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
ZSH_THEME_GIT_PROMPT_PREFIX="%F{${hokkaido_snow_cyan}}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{${hokkaido_snow_cyan}}) %F{${hokkaido_snow_warning}}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{${hokkaido_snow_cyan}}) %F{${hokkaido_snow_green}}%1{✔%}"

# ==============================================================================
# TRANSIENT PROMPT (optional)
# Collapses previous prompts to "❯" after command execution.
# Source: https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt
#
# To disable: comment out from here to "END TRANSIENT PROMPT"
# ==============================================================================

function _set_transient_prompt() {
  if (( _transient_prompt_compact )); then
    PROMPT="%F{${hokkaido_snow_muted}}❯%f "
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
