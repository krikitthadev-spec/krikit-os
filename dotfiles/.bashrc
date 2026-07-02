# Krikit OS minimal bashrc
export TERM=xterm-256color
export PS1="\[\e[1;32m\]krikit@\h \[\e[0;36m\]\w\[\e[0m\]\$ "
export PATH="$HOME/bin:$PATH"

# Useful aliases
alias ll='ls -la --color=auto'
alias gs='git status'
alias kr='krikit'

kr_status() {
  echo "Krikit OS status from $KR_ROOT"
  uname -sr
}
