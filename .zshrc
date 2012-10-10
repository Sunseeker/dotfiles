#
# Настраиваем безполезные клавиши плюс бекспей
#
# алиас ибо на некоторых машинах нихера чё-то без алиаса на загружается
#source /etc/profile
#alias zkbd='zsh /usr/share/zsh/functions/Misc/zkbd'
#autoload zkbd
#[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
#[[ ! -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd 

# PageUp PageDown
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

source ~/.zsh-git-prompt/zshrc.sh

#
# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

# Установка атрибутов доступа для вновь создаваемых файлов
umask 022

# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" } # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

#PROMPT=$'%{\e[1;32m%}%n@%m:%{\e[1;34m%}[%~]$%{\e[0m%} '
#RPROMPT=$'%{\e[1;32m%}[%{\e[1;33m%}%T%{\e[1;32m%}]%{\e[0m%}'
#PROMPT=$'%{\e[1;32m%}%{\e[1;33m%}%T%{\e[1;32m%} '$'%{\e[1;32m%}%n@%m:%{\e[1;34m%}[%1d]$%{\e[0m%} '
PROMPT=$'%{\e[1;32m%}%{\e[1;33m%}%T%{\e[1;32m%} '$'%{\e[1;32m%}%n@%m:%{\e[1;34m%}[%1d]%{\e[0m%}$(git_super_status)%{\e[1;34m%}$%{\e[0m%} '

# Позволяем разворачивать сокращенный ввод, к примеру cd /u/sh в /usr/share
autoload -Uz compinit
compinit

# экранируем спецсимволы в url, например &, ?, ~ и так далее
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

autoload -U incremental-complete-word
zle -N incremental-complete-word
autoload -U insert-files
zle -N insert-files

# дополнение по истории
autoload -U predict-on
zle -N predict-on

## режим редактирования команды, вызывает для этого то что в $EDITOR
# autoload -U edit-command-line
## Вызов редактора для редактирования строки ввода
# zle -N edit-command-line
## bindkey -M vicmd v edit-command-line 			#для командного режима vi
# bindkey -M emacs "^X^E" edit-command-line 		#хоткей в стиле emacs
## завершить слово команду
# bindkey -M emacs "^N" complete-word

#вызов диалога удаления файлов в каталоге
function dialogrun; { rm -rf $(dialog --separate-output --checklist file 100 100 100 $(for l in $(ls -A); do echo "$l" "$(test -d $l && echo "dir" || echo "file")" 0; done) --stdout); clear  }
zle -N dialogrun
#bindkey ^M dialogrun

# куда же мы без калькулятора
#autoload -U zcalc

# Tetris :)
#autoload -U tetris 
#zle -N tetris 
#bindkey ^T  tetris

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Completions
zstyle ':completion:*:default' list-colors '${LS_COLORS}'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' add-space true	
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format '==> Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
#zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' menu select=1	
zstyle ':completion:*' old-menu false
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt '=>'
zstyle ':completion:*' select-prompt '==> %SScrolling active: current selection [%l] at %p%s'
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true	
zstyle ':completion:*:cd:*' ignore-parents parent pwd 
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(((        $#PREFIX+$#SUFFIX)/3 )) numeric )'
# симпотное добавления для kill
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"

zstyle :compinstall filename '/home/slay/.zshrc'

# файл истории команд
HISTFILE=~/.zhistory

# Число команд, сохраняемых в HISTFILE
SAVEHIST=5000
HISTSIZE=5000

# Дополнение файла истории
setopt APPEND_HISTORY

# Игнорировать все повторения команд
setopt HIST_IGNORE_ALL_DUPS

# Игнорировать лишние пробелы
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# если набрали путь к директории без комманды CD, то перейти
setopt AUTO_CD

# исправлять неверно набранные комманды
setopt CORRECT_ALL

# zsh будет обращаться с пробелами так же, как и bash
setopt SH_WORD_SPLIT

# последние комманды в начале файла и не хранить дубликаты
setopt histexpiredupsfirst histfindnodups

# ещё всякая херь про истоию
setopt histignoredups histnostore histverify histignorespace extended_history share_history appendhistory

# не пищать при дополнении или ошибках
unsetopt beep

# Установка и снятие различных опций шелла
setopt notify globdots correct pushdtohome cdablevars autolist
setopt correctall autocd recexact longlistjobs
setopt autoresume histignoredups pushdsilent noclobber
setopt autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Не считать Control+C за выход из оболочки
#setopt IGNORE_EOF

# автоматическое удаление одинакового из этого массива
typeset -U path cdpath fpath manpath

# загружаем список цветов
autoload colors && colors

# вопрос на автокоррекцию
SPROMPT='zsh: Replace '\''%R'\'' on '\''%r'\'' ? [Yes/No/Abort/Edit] '

# заголовки и прочее
precmd()
{
    [[ -t 1 ]] || return
	case $TERM in
		*xterm*|rxvt|(dt|k|E)term*) print -Pn "\e]2;[%~] :: %n@%M at %l\a"		;;
#		screen(-bce|.linux)) print -Pn "\ek[%~]\e\" && print -Pn "\e]0;[%~] %m (screen)\a" ;;  #заголовок для скрина
        esac
}

preexec() 
{
    	[[ -t 1 ]] || return
        case $TERM in
	    *xterm*|rxvt|(dt|k|E)term*) print -Pn "\e]2;<$1> [%~] :: %n@%M at %l\a"	    ;;
#	    screen(-bce|.linux)) print -Pn "\ek<$1> [%~]\e\" && print -Pn "\e]0;<$1> [%~] %m (screen)\a" ;; #заголовок для скрина
	esac
}

####  функции
# распаковка архива
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1        ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xf $1        ;;
            *.tbz2)      tar xjf $1      ;;
            *.tgz)       tar xzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "I do not know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# упаковка в архив
pk () {
    if [ $1 ] ; then
	case $1 in
	    tbz)   	tar cjvf $2.tar.bz2 $2      ;;
	    tgz)   	tar czvf $2.tar.gz  $2   	;;
	    tar)  	tar cpvf $2.tar  $2       ;;
	    bz2)	bzip $2 ;;
	    gz)		gzip -c -9 -n $2 > $2.gz ;;
	    zip)   	zip -r $2.zip $2   ;;
	    7z)    	7z a $2.7z $2    ;;
	    *)     	echo "'$1' cannot be packed via pk()" ;;
	esac
    else
        echo "'$1' is not a valid file"
    fi
}

# mp3 в нормальную кодировку
mp32utf() { find -iname '*.mp3' -print0 | xargs -0 mid3iconv -eCP1251 --remove-v1 }

# конвертируем всякую дурь
mpg2flv() { ffmpeg -i $1 -ar 22050 -ab 32 -f flv -s 320x240 `echo $1 | awk -F . '{print $1}'`.flv }
flv2xvid() { mencoder "$1" -vf scale=320:240  -ovc xvid -xvidencopts bitrate=250:autoaspect -vf pp=lb -oac mp3lame  -lameopts fast:preset=standard -o  "./basename $1.avi" }
flv2divx() { mencoder "$1" --vf scale=320:240  -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=250:mbd=2:v4mv:autoaspect -vf pp=lb -oac mp3lame  -lameopts fast:preset=standard -o  "./basename $1.avi" }

# top по имени процесса, правда только по полному
pidtop() {top -p `pidof $@ | tr ' ' ','`}

# простой калькулятор
calc() {echo "${1}"|bc -l;}

# великий рандом для перемешивания строк в файле
rand() { awk '{print rand()"\t"$0}'|sort|awk -F'\t' '{print $2}' }

# копипаст в консоли
ccopy(){ cp $1 /tmp/ccopy.$1; }
alias cpaste="ls /tmp/ccopy.* | sed 's|/tmp/ccopy.||' | xargs -I % mv /tmp/ccopy.% ./%"

#
# переменные окружения
#
# перенаправляем
READNULLCMD=${PAGER}

# если стоит most то заюзаем в качестве $PAGER
[[ -x $(whence -p most) ]] && export PAGER=$(whence -p most)

#оформим подсветку в grep
#export GREP_COLOR="1;33"
#export GREP_OPTIONS="--color=auto"
alias grep='grep --color=auto -i'

# редактор по дефолту
export EDITOR=vim

# более человекочитаемые df и du
alias df='df -h'
alias du='du -h'

# показ файлов в цвете
alias ls='ls -F --color=auto'
#alias ls='ls --color=auto'
alias ll='ls -al'
alias la='ls -A'
alias l='ls -CF'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

# разукрашиваем некоторые команды с помощью grc

[[ -f /usr/bin/grc ]] && {
  alias ping="grc --colour=auto ping"
  alias traceroute="grc --colour=auto traceroute"
#  alias make="grc --colour=auto make"
  alias diff="grc --colour=auto diff"
#  alias cvs="grc --colour=auto cvs"
  alias netstat="grc --colour=auto netstat"
}

# разукрашиваем логи с помощью grc
alias logc="grc cat"
alias logt="grc tail"
alias logh="grc head"

#
# запуск программ
#
# везде
alias -s {avi,mpeg,mpg,mov,m2v,flv}=mplayer
alias -s {zip,fb2}=fbless
alias -s txt=$PAGER
alias -s py=python
alias -s {ogg,mp3,wav,wma}=mplayer

# в иксах
alias -s {xls,doc,,rtf,ppt,odt,sxw}=soffice
alias -s {png,gif,jpg,jpeg}=feh
alias -s {pdf,djvu}=evince

# без иксов
[[ -z $DISPLAY ]] && {
    alias -s {odt,doc,sxw,xls,doc,rtf}=catdoc
    alias -s {png,gif,jpg,jpeg}="fbi -a"
    alias -s {pdf,djvu}=evince
    alias -s mht=opera
}

#html сам пусть соображает чё запускать
autoload -U pick-web-browser
alias -s {html,htm}=pick-web-browser

#
# глобальные алиасы
#
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"
alias -g L="| less"
alias -g M="| most"
alias -g B="&|"
alias -g HL="--help"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

#конвертим вывод в utf8, а то достало
alias -g KU="| iconv -c -f koi8r -t utf8"
alias -g CU="| iconv -c -f cp1251 -t utf8"

#ну и обратно тоже
alias -g UK="| iconv -c -f utf8 -t koi8r"
alias -g UC="| iconv -c -f utf8 -t cp1251"

# родной скрин
alias screen="screen -DR"

# список удаленных файлов с NTFS, FAT, UFS1/2, FFS, Ext2 и Ext3
# пакет sleuthkit, утилита icat для восстановления
alias fls="fls -rd"

# пишем диски
alias iso2cd="cdrecord -s dev=`cdrecord --devices 2>&1 | grep "\(rw\|dev=\)" | awk {'print $2'} | cut -f'2' -d'=' | head -n1` gracetime=1 driveropts=burnfree -dao -overburn -v"

# ls -l с цифровым видом прав
alias lls="ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g'  -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'"

# nrg2iso
alias nrg2iso="dd bs=1k if=$1 of=$2 skip=300"

# показываем дерево директорий
alias dirf='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# grep по ps aux
alias psgrep='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'

# удаляем пустые строки и комментарии
alias delspacecomm="sed '/ *#/d; /^ *$/d' $1"

# создаем пароль из 6символов
alias mkpass="head -c6 /dev/urandom | xxd -ps"

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export SSH_ASKPASS="/usr/bin/ksshaskpass"

export MANPAGER=less

g() {
    git "$*" | tig
}

#keychain -Q -q --nogui ~/.ssh/yury
#[ -f $HOME/.keychain/$HOSTNAME-sh ] && source $HOME/.keychain/$HOSTNAME-sh

