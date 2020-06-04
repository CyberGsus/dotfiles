# Credit:
#   Scripting OS X      <https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/>
#   Sindre Sorhus       <https://github.com/sindresorhus/pure>
#   Chis Titus          <https://github.com/ChrisTitusTech/zsh>

setopt autocd         # auto cd into directory when specified as command
setopt vi             # <esc> brings up vi bindings
setopt autopushd      # push directory when cd'ing

xset r rate 300 50   # faster scrolling with keye

PATH+=':.local/bin'

# Fallback left prompt
autoload -U colors && colors
PS1="%F{%(!.red.green)}%n%b%f@%m %F{117}%1~%f %B%#%b "

# Right prompt : hour and exit code
RPROMPT='%B%(?.%F{green}√.%F{red}%?)%f %*%b'



# Pure Prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL=`echo -e "\x1b[1m\u03bb\x1b[m"` # Bold small lamda (λ)
PURE_PROMPT_VICMD_SYMBOL=`echo -e "\x1b[1m\u03b8\x1b[m"` # Bold small theta (θ)
prompt pure

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

# Custom ZSH Binds
bindkey '^ ' autosuggest-accept

# Load aliases and shortcuts if existent.
[ -f "$HOME/.zsh/aliasrc" ] && source "$HOME/.zsh/aliasrc"

# Load ; should be last.
#source /home/cyber/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-softmoth-SLASH-zsh-vim-mode/zsh-vim-mode.plugin.zsh
#fpath+=( /home/cyber/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-softmoth-SLASH-zsh-vim-mode )
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/autojump/autojump.zsh 2>/dev/null
[ -f "$HOME/.zsh/keybinds" ] && source "$HOME/.zsh/keybinds" # some keybind fixes, see 
                                                             # <https://wiki.archlinux.org/index.php/Home_and_End_keys_not_working#Less>
                                                             # <https://stackoverflow.com/questions/161676/home-end-keys-in-zsh-dont-work-with-putty>
                                                             # for details
[ -f '/usr/share/nvm/init-nvm.sh' ] && source /usr/share/nvm/init-nvm.sh # nvm
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
export DOCKER_HIDE_LEGACY_COMMANDS=true # hide legacy command from docker
