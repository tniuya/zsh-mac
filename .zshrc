# Created by newuser for 3.0.2
function chpwd(){
   print -Pn "\e]2;%~\a"
 }
########################################
#-------------------------------------------------------
## ターミナルのウィンドウ・タイトルを動的に変更.1
#  precmd() {   # zshシェルのプロンプトが表示される前に毎回実行
#      print -Pn "\e]0;[$HOST] %~\a"
#  }
#  preexec () { # コマンドが実行される直前に実行
#      print -Pn "\e]0;[$1]: %~\a"
#  }

## ターミナルのウィンドウ・タイトルを動的に変更.2
# hostname=`hostname -s`
# function _setcaption() { echo -ne  "\e]1;${hostname}\a\e]2;${hostname}$1\a" > /dev/tty }
# function chpwd() {  print -Pn "\e]2; [%m] : %~\a" }
# chpwd
# function _cmdcaption() { _setcaption " ($1)"; "$@"; chpwd }
# for cmd in telnet slogin ssh rlogin rsh su sudo
# do
#     alias $cmd="_cmdcaption $cmd"
# done

## ターミナルのウィンドウ・タイトルを動的に変更.3 -- screen 対応版
precmd() {
    [[ -t 1 ]] || return
    case $TERM in
        *xterm*|rxvt|(dt|k|E)term)
            #print -Pn "\e]2;%n%%${ZSH_NAME}@%m:%~ [%l]\a"
            #print -Pn "\e]2;[%n@%m %~] [%l]\a"
            print -Pn "\e]2;[%n@%m %~]\a"      # %l ← pts/1 等の表示を削除
            ;;
        # screen)
        #      #print -Pn "\e]0;[%n@%m %~] [%l]\a"
        #      print -Pn "\e]0;[%n@%m %~]\a"
        #      ;;
    esac
}

#-------------------------


# 環境変数
export LANG=ja_JP.UTF-8
 
 
# 色を使用出来るようにする
autoload -Uz colors
colors
 
# emacs 風キーバインドにする
bindkey -e
 
# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
bindkey '^h' zaw-history

# history search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

setopt share_history
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks  

# 古いコマンドと同じものは無視 
setopt hist_save_no_dups

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開         
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history

# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

 
# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
##  PROMPT="%{${fg[red]}%}[%n@%m]%{${reset_color}%} %~
##  %# "

##http://www.slideshare.net/tetutaro/zsh-20923001
local p_rhst=""
if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
  local rhost=`who am i|sed 's/.*(\(.*\)).*/\1/'`
  rhost=${rhost#localhost:}
  rhost=${rhost%%.*}
  p_rhost="%B%F{yellow}($rhost)%f%B"
fi
local p_cdir="%F{blue}%B[%b%f%F{red}%~%f%F{blue}%B]%b%f"$'\n'
local p_info="%n@%m${WINDOW:+"[$WINDOW]"}"
local p_mark="%B%(!,#,>)%b"
PROMPT=" $p_cdir$p_rhost$p_info $p_mark "
 
PROMPT2="(%_) %(!,#,>) "
SPROMPT="correct: %R -> %r ? [n,y,a,e]: "

#Fn+delete -> ~になることを回避
#http://www.softwaretalk.info/binding-fn-delete-in-zsh-on-mac-os-x.htm
bindkey "^[[3~" delete-char
 
# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
 
########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit
 
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
 
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
 
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
 
 
########################################
# vcs_info
 
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"
 
 
########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
 
# beep を無効にする
setopt no_beep
 
# フローコントロールを無効にする
setopt no_flow_control
 
# '#' 以降をコメントとして扱う
setopt interactive_comments
 
# ディレクトリ名だけでcdする
setopt auto_cd
 
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
 
# = の後はパス名として補完する
setopt magic_equal_subst
 
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
 
# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu
 
# 高機能なワイルドカード展開を使用する
setopt extended_glob
 
########################################
# キーバインド
 
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward
 
########################################
# エイリアス
alias e='emacs' 
alias la='ls -a'
alias ll='ls -l -a'
 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
 
alias mkdir='mkdir -p'
 
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
 
# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
 
# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi
 
 
 
########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        ;;
esac
 
# vim:set ft=zsh:

#alias ls='ls -G'
#alias ll='ls -l'
export PGDATA=/Users/taka/.homebrew/Cellar/postgresql/9.2.4/data
export M2_HOME=/usr/local/Cellar/maven/current/
export PATH=${PATH}:${M2_HOME}/bin

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/mvim "$@"'
alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias rtags='ctags -R -a --sort=yes --exclude=*.js --exclude=*.h --exclude=log --exclude=*.yml --exclude=.git --langmap=RUBY:.rb ~/.rbenv/versions/i2.0.0-p195/lib/ruby/2.0.0'
alias gtags='ctags -R -a --sort=yes --exclude=*.js --exclude=*.exp  --exclude=*.am --exclude=*.in --exclude=*.m4--exclude=*.o --exclude=*.h --exclude=log --exclude=*.yml --exclude=.git --langmap=RUBY:.rb ~/.rbenv/versions/2.0.0-p195/lib/ruby/gems/2.0.0/gems'
#export PS1="\w [\u:\!] $"
export PATH=/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/opt/X11/bin:/sw/bin
#export PATH=/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/opt/X11/bin:/sw/bin:/usr/local/mysql/bin

test -r /sw/bin/init.sh && . /sw/bin/init.sh

##
# Your previous /Users/taka/.bash_profile file was backed up as /Users/taka/.bash_profile.macports-saved_2013-04-11_at_15:53:35
##

# MacPorts Installer addition on 2013-04-11_at_15:53:35: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
export _JAVA_OPTIONS=-Dfile.encoding=UTF-8
export JAVA_HOME='/System/Library/Java/Home/'
export CATALINA_HOME='/usr/local/Cellar/tomcat/7.0.39/libexec'
source /Users/taka/.phpbrew/bashrc
PHPBREW_SET_PROMPT=1

export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
JAVA_HOME=/System/Library/java/Home
export JAVA_HOME
PATH=$PATH:$JAVA_HOME/bin
export PATH
/Users/taka/.phpbrew/bashrc 
export PHPBREW_SET_PROMPT=1
source /Users/taka/zaw/zaw.zsh
