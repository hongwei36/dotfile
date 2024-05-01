# ============================================== mac ==============================================
## 指令完成时立即写入历史记录
setopt INC_APPEND_HISTORY
## 指令重复时，设置让较早的指令过期失效，只保留最新指令记录
setopt HIST_EXPIRE_DUPS_FIRST
## 指令和上一条重复时，不记录
setopt HIST_IGNORE_DUPS
## 指令重复时，删除旧指令
setopt HIST_IGNORE_ALL_DUPS
## 不记录空格开头指令
setopt HIST_IGNORE_SPACE
## 查找历史指令时，省略重复指令
setopt HIST_FIND_NO_DUPS
## 导出历史指令时，省略重复指令
setopt HIST_SAVE_NO_DUPS
## widget access a history which isn't there --> beep in ZLE
setopt HIST_BEEP
## show hidden dotfiles
setopt globdots

# ============================================= alias =============================================
## proxy
alias proxy='export all_proxy=socks5://127.0.0.1:1080 && curl cip.cc'
# alias proxy='export all_proxy=http://127.0.0.1:1087'
alias unproxy='unset all_proxy && curl cip.cc'

## network
alias ip4='curl cip.cc'
alias gl='curl -vv google.com'
alias wget='wget --no-hsts'

## commonly use
alias ll='ls -alG'

## eza
alias eza='eza -abghHliS --sort=Filename --icons'

## grep
alias grep='grep --color=auto'

## df
alias df='df -h'

## fastfetch
alias nf='fastfetch'

## bat
alias bat='bat --theme=Dracula'

## lazygit
alias lg='cd $(readlink -f .) && lazygit'

## ncdu
alias ncdu='ncdu --color dark'

## pbpaste
alias pbtrans='pbpaste | xargs -0 trans'

## edit .zshrc
alias ez='lvim $ZDOTDIR/.zshrc'
## source .zshrc
alias sz='source $ZDOTDIR/.zshrc'

# ============================================ common =============================================
## homebrew
export PATH=$(brew --prefix)/bin:$PATH

## nvim
export EDITOR=nvim
## lunarvim
export PATH=$HOME/.local/bin:$PATH

## man
export MANPAGER='nvim +Man!'

## bin
export PATH=$XDG_CONFIG_HOME/bin:$PATH

## ripgrep
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/rg/ripgreprc

## node
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NODE_OPTIONS='--trace-deprecation'
## nvm
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## Java
export JAVA_HOME='/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home'
## redis
export REDISCLI_HISTFILE=$XDG_DATA_HOME/redis/.rediscli_history
## mycli
export MYCLI_HISTFILE=$XDG_DATA_HOME/mycli/mycli_history
## mysql
export MYSQLSH_USER_CONFIG_HOME=$XDG_CONFIG_HOME/mysql

## cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$HOME/.local/cargo


## starship
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/hong.toml
# if [[ $TERM_PROGRAM = "Apple_Terminal" ]]; then
#     export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/hong.toml
# else
#     export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/default.toml
# fi

## chatgpt.nvim
export OPENAI_API_KEY=$(security find-generic-password -s "OPENAI_API_KEY" -w)
export OPENAI_API_HOST='https://api.chatanywhere.tech'

# ============================================== zsh ==============================================
## autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

zvm_before_init() {
  local ncur=$(zvm_cursor_style $ZVM_NORMAL_MODE_CURSOR)
  ZVM_INSERT_MODE_CURSOR=$ncur'\e\e]12;#929292\a'
  ZVM_NORMAL_MODE_CURSOR=$ncur'\e\e]12;#008800\a'
}

zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_ESCAPE_BINDKEY=jk
  ZVM_VI_INSERT_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
  ZVM_VI_VISUAL_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
  ZVM_VI_OPPEND_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
  ZVM_VI_HIGHLIGHT_BACKGROUND=#519e97
}

zvm_after_init() {
    ## fzf 和 zsh-vi-mode 不兼容，在 zsh-vi-mode 后加载 fzf 配置
    eval "$(fzf --zsh)"
    ## zoxide
    eval "$(zoxide init zsh)"
    ## starship
    eval "$(starship init zsh)"
    ## mvn completion
    . $ZDOTDIR/plugins/mvn.zsh
}

# zsh-vi-mode
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-auto-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-completions
if type brew &>/dev/null; then

    FPATH=$XDG_DATA_HOME/zsh-completions:$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit
    compinit

    ## 忽略大小写
    zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
    zstyle ':completion:*' menu select
    zmodload zsh/complist

    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
fi

# forgit
[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh

# ============================================= fzf ================================================
## 补全触发字符
export FZF_COMPLETION_TRIGGER='\'

## Ctrl-T --> 选择文件或者目录粘贴到命令行
export FZF_CTRL_T_OPTS="--preview \
    '(highlight -O ansi -l {} 2> /dev/null || bat --style=numbers --color=always --line-range :500 {} || tree -C {}) 2> /dev/null | head -200' \
    --select-1 --exit-0"

## Ctrl-R --> 选择历史命令
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

## Alt-C  --> cd 到选择文件目录
export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {} | head -200'"

## 默认外观参数
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --color=hl:#ca4238,hl+:#ca4238,info:#95a0a0,fg+:#97f676 --bind \
    'alt-k:preview-up,alt-j:preview-down' --bind \
    'ctrl-b:preview-page-up,ctrl-f:preview-page-down' --bind \
    'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"


## 默认命令参数
export FZF_DEFAULT_COMMAND="fd --hidden --follow --type f --exclude={.git,.cache,.zcompcache,.zsh_sessions}"

## fd ==> path candidates
_fzf_compgen_path() {
  fd --hidden --follow --exclude={.git,.cache,.zcompcache,.zsh_sessions} . "$1"
}

## fd ==> dir candidates
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude={.git,.cache,.zcompcache,.zsh_sessions} . "$1"
}
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    j)            fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview '(bat -n --color=always :500 {} || tree -C {}) 2>/dev/null | head -200' "$@" ;;
  esac
}

## linux-command 搭配 fzf
fl() {
  dir="$HOME/Documents/linux-command/command"
  ## find command 目录下所有 .md 文件，sed "s#$dir/##; s/\.md//" 去掉目录和 .md 拓展名,然后交给fzf
  ## fzf 打开搜索和预览窗口，通过 glow 预览 markdown 文件
  ## 选中命令后用 awk 打开 
  commandsfile=$(find $dir -name '*.md' | sed "s#$dir/##; s/\.md//" \
      | fzf --prompt='LinuxCommands> ' --preview "echo $dir/{}.md | xargs glow --style dark -p" --preview-window=right,75% \
      | awk '{printf "'$dir'/%s.md", $1}')
  if [ $commandsfile ]; then
    glow --style dark -p $commandsfile
   else
     echo >> /dev/null
   fi
}

# tldr
tl() {
    tldr --list | fzf --preview "tldr -R {1} | glow --style dark -p" --preview-window=right,60% | xargs tldr
}

# autojump
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { if (i<NF) { printf "%s ", $(i) } else { print $(i) } } }' |  fzf --height 20% --reverse --inline-info)" 
}

# b - browse chrome bookmarks
b() {
     bookmarks_path=~/Library/Application\ Support/Google/Chrome/Default/Bookmarks

     jq_script='
        def ancestors: while(. | length >= 2; del(.[-1,-2]));
        . as $in | paths(.url?) as $key | $in | getpath($key) | {name,url, path: [$key[0:-2] | ancestors as $a | $in | getpath($a) | .name?] | reverse | join("/") } | .path + "/" + .name + "\t" + .url'

    jq -r "$jq_script" < "$bookmarks_path" \
        | sed -E $'s/(.*)\t(.*)/\\1\t\x1b[36m\\2\x1b[m/g' \
        | fzf --ansi \
        | cut -d$'\t' -f2 \
        | xargs open
}

# c - browse chrome history
c() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# ============================================= yazi ==============================================
## yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ============================================= tmux ==============================================
alias tnew='tmux -u new -s'
alias tat='tmux -u at -t'
alias tdt='tmux detach'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'

## tmuxinator
alias tn='tmuxinator'

# =========================================== (f)path =============================================
## 去重
typeset -aU path
typeset -aU fpath
