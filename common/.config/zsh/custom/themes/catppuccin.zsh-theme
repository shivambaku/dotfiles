# Catppuccin Mocha color palette
catppuccin_rosewater="#f5e0dc"
catppuccin_flamingo="#f2cdcd"
catppuccin_pink="#f5c2e7"
catppuccin_mauve="#cba6f7"
catppuccin_red="#f38ba8"
catppuccin_maroon="#eba0ac"
catppuccin_peach="#fab387"
catppuccin_yellow="#f9e2af"
catppuccin_green="#a6e3a1"
catppuccin_teal="#94e2d5"
catppuccin_sky="#89dceb"
catppuccin_sapphire="#74c7ec"
catppuccin_blue="#89b4fa"
catppuccin_lavender="#b4befe"
catppuccin_text="#cdd6f4"
catppuccin_subtext1="#bac2de"
catppuccin_subtext0="#a6adc8"
catppuccin_overlay2="#9399b2"
catppuccin_overlay1="#7f849c"
catppuccin_overlay0="#6c7086"
catppuccin_surface2="#585b70"
catppuccin_surface1="#45475a"
catppuccin_surface0="#313244"
catppuccin_base="#1e1e2e"
catppuccin_mantle="#181825"
catppuccin_crust="#11111b"

# Cursor shapes
_beam_cursor='\e[6 q'
_block_cursor='\e[2 q'

# Vim mode indicator (shown in prompt)
# Note: visual|viopp won't trigger - zsh vi-mode stays 'vicmd' during visual selection
function vim_mode_indicator() {
  case $KEYMAP in
    vicmd) echo "%F{${catppuccin_mauve}}❯%f " ;;
    viins|main) echo "%F{${catppuccin_green}}❯%f " ;;
    visual|viopp) echo "%F{${catppuccin_yellow}}❯%f " ;;
  esac
}

# Build the full prompt
function _build_prompt() {
  PROMPT='$(vim_mode_indicator)'
  if [[ "$CATPPUCCIN_SHOW_TIME" == true ]]; then
    PROMPT+="%F{${catppuccin_mauve}}%T%  "
  fi
  PROMPT+="%F{${catppuccin_pink}}%n%  "
  PROMPT+="%F{${catppuccin_blue}}%c%{$reset_color%}"
  PROMPT+=' $(git_prompt_info)'
}

# Vim mode: update cursor shape on mode change
function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne "$_block_cursor" ;;
    viins|main) echo -ne "$_beam_cursor" ;;
  esac
  zle reset-prompt
}

function zle-line-init() {
  echo -ne "$_beam_cursor"
  zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

# Initialize prompt
_build_prompt

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%F{${catppuccin_teal}}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{${catppuccin_teal}}) %F{${catppuccin_yellow}}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{${catppuccin_teal}}) %F{${catppuccin_green}}%1{✔%}"

# ==============================================================================
# TRANSIENT PROMPT (optional)
# Collapses previous prompts to "❯" after command execution.
# Source: https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt
#
# To disable: comment out from here to "END TRANSIENT PROMPT"
# ==============================================================================

function _set_transient_prompt() {
  if (( _transient_prompt_compact )); then
    PROMPT="%F{${catppuccin_overlay1}}❯%f "
  else
    _build_prompt
  fi
}

function zle-line-init() {
  [[ $CONTEXT == start ]] || return 0

  _transient_prompt_compact=0
  _set_transient_prompt
  echo -ne "$_beam_cursor"
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

function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne "$_block_cursor" ;;
    viins|main) echo -ne "$_beam_cursor" ;;
  esac
  zle .reset-prompt
}

_transient_prompt_compact=0
zle -N zle-line-init
zle -N zle-keymap-select

# ==============================================================================
# END TRANSIENT PROMPT
# ==============================================================================
