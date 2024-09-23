# Alias for connect to SQLcl with different options
alias conn=$HOME/Workspace/toolbox/sqlcl/conn.sh

# Alias to run an APEX/Oracle Db container
alias docker_run=$HOME/Workspace/toolbox/docker/run_apex.sh

# Workspace File Structure Structure
alias trash="cd $HOME/Workspace/trash"
alias repo="cd $HOME/Workspace/repo"
alias resources="cd $HOME/Workspace/resources"
alias opensource="cd $HOME/Workspace/opensource"
alias external="cd $HOME/Workspace/external"
alias development="cd $HOME/Workspace/development"
alias toolbox="cd $HOME/Workspace/toolbox"

# Database statistics
alias db_stats=$HOME/Workspace/toolbox/database/db_statistics.sql

# Aliases for SQLcl development
alias common="development && cd dbtools-commons/"
alias project="development && cd dbtools-commons/dbtools-extensions/dbtools-cicd-project-extension"
alias dist="development && cd dbtools-commons/sqlcl-distribution"
alias sqlcl="development && cd dbtools-commons/sqlcl-distribution/target/sqlcl-*/sqlcl/bin"
alias conn_o="$HOME/Workspace/development/dbtools-commons/sqlcl-distribution/target/sqlcl-*/sqlcl/bin/sql /nolog"
alias conn_debug="$HOME/Workspace/development/dbtools-commons/sqlcl-distribution/target/sqlcl-*/sqlcl/bin/sql /nolog -debug"
alias conn_hr="$HOME/Workspace/development/dbtools-commons/sqlcl-distribution/target/sqlcl-*/sqlcl/bin/sql hr/oracle@dbtools-dev.oraclecorp.com:2323/DB23P"
alias conn_app="$HOME/Workspace/development/dbtools-commons/sqlcl-distribution/target/sqlcl-*/sqlcl/bin/sql sampleapp_ws/oracle@dbtools-dev.oraclecorp.com:2323/DB23P"
alias b1="project && mvn clean install -o -DskipTests -Dmaven.javadoc.skip=true && dist && mvn clean install -o -DskipTests -Dmaven.javadoc.skip=true && trash"
alias b2="common && mvn clean install -U -DskipTests -Dmaven.javadoc.skip=true -Dmaven.source.skip=true && trash"
alias b0="common && mvn clean install -o -DskipTests -Dmaven.javadoc.skip=true -Dmaven.source.skip=true && trash"
alias b3="project && mvn clean install -U -DskipTests -Dmaven.javadoc.skip=true -Dmaven.source.skip=true && trash"
alias btest="project && mvn clean install test -Dmaven.javadoc.skip=true -Dmaven.source.skip=true && trash"
alias setproxy="source $HOME/Workspace/repo/export_proxy &&  cp $HOME/Workspace/repo/mvn-settings/settings.xml $HOME/.m2/ &&  git config --global http.proxy http://www-proxy-ash7.us.oracle.com:80"
alias noproxy='unset no_proxy &&  unset http_proxy &&  unset https_proxy &&  unset HTTP_PROXY &&  unset HTTPS_PROXY &&  unset ALL_PROXY &&  rm $HOME/.m2/settings.xml &&  cp $HOME/Workspace/repo/mvn-settings/settings-no.xml $HOME/.m2/settings.xml &&  git config --global --unset http.proxy'
alias format="mvn spotless:apply"
alias format_check="mvn spotless:check"

# some more ls aliases
alias diskspace='du -S | sort -n -r | more'
alias folders='find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn'
alias c='clear'
alias cls='clear'
alias copy='cp'
alias rename='mv'
alias del='rm'
alias install='apt-get install'
alias fuck='echo -e "Chill out man, nothing is worth being upset\n\nHere is a quote, read it:\n`fortune`"'

# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

# Add easy extract support
function extract () {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  tar Jxvf $1   ;;
      *.lzma)    unlzma $1     ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
      *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *.xz)      unxz $1       ;;
      *.exe)     cabextract $1 ;;
      *)         echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# Repeat n times command
function repeat() {
  local i max
  max=$1; shift;
  for ((i=1; i <= max ; i++)); do  # --> C-like syntax
    eval "$@";
  done
}


# Function to run upon exit of shell.
function _exit() {
    echo -e "HAHAHA safe!, Bye Bye :)"
    echo -e "\e[1;5;32m                            ____             \e[0m"
    echo -e "\e[1;5;32m                           | __ ) _   _  ___ \e[0m"
    echo -e "\e[1;5;32m                           |  _ \| | | |/ _ \\e[0m"
    echo -e "\e[1;5;32m                           | |_) | |_| |  __/\e[0m"
    echo -e "\e[1;5;32m                           |____/ \__, |\___|\e[0m"
    echo -e "\e[1;5;32m                                  |___/      \e[0m"
    sleep 0.75
}
trap _exit EXIT