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

# Vim mode indicator
function vim_mode_indicator() {
  case $KEYMAP in
    vicmd) echo "%K{${catppuccin_mauve}}%F{${catppuccin_crust}} NORMAL %k%f " ;;
    viins|main) echo "%K{${catppuccin_green}}%F{${catppuccin_crust}} INSERT %k%f " ;;
    visual|viopp) echo "%K{${catppuccin_yellow}}%F{${catppuccin_crust}} VISUAL %k%f " ;;
  esac
}

# Cursor shapes
_beam_cursor='\e[6 q'
_block_cursor='\e[2 q'

# Transient prompt - using recursive-edit approach from Vincent Bernat
# https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt
_transient_prompt_compact=0

function _set-prompt() {
  if (( _transient_prompt_compact )); then
    # Compact/transient prompt - just a simple chevron
    PROMPT="%F{${catppuccin_overlay1}}❯%f "
  else
    # Full prompt
    PROMPT='$(vim_mode_indicator)'
    PROMPT+="%(?:%F{${catppuccin_green}}%1{➜%} :%F{${catppuccin_red}}%1{➜%} )"
    if [ "$CATPPUCCIN_SHOW_TIME" = true ]; then
      PROMPT+="%F{${catppuccin_mauve}}%T%  "
    fi
    PROMPT+="%F{${catppuccin_pink}}%n%  "
    PROMPT+="%F{${catppuccin_blue}}%c%{$reset_color%}"
    PROMPT+=' $(git_prompt_info)'
  fi
}

function zle-line-init() {
  [[ $CONTEXT == start ]] || return 0

  # Start with full prompt
  _transient_prompt_compact=0
  _set-prompt

  # Initialize cursor to beam
  echo -ne "$_beam_cursor"

  # Force prompt refresh so vim mode indicator shows correctly
  zle .reset-prompt

  # Enable bracketed paste
  (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]
  
  # Start recursive line editor
  zle .recursive-edit
  local -i ret=$?
  
  # Disable bracketed paste
  (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]

  # Handle Ctrl-D (EOT)
  if [[ $ret == 0 && $KEYS == $'\4' ]]; then
    _transient_prompt_compact=1
    _set-prompt
    zle .reset-prompt
    exit
  fi

  # Line editing is done - switch to compact prompt and redraw
  _transient_prompt_compact=1
  _set-prompt
  zle .reset-prompt
  
  # Restore full prompt for next time
  _transient_prompt_compact=0
  _set-prompt

  if (( ret )); then
    # Ctrl-C: abort
    zle .send-break
  else
    # Enter: accept the line
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

zle -N zle-line-init
zle -N zle-keymap-select

# Initialize prompt
_set-prompt

ZSH_THEME_GIT_PROMPT_PREFIX="%F{${catppuccin_teal}}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{${catppuccin_teal}}) %F{${catppuccin_yellow}}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{${catppuccin_teal}}) %F{${catppuccin_green}}%1{✔%}"
