set DISTRO $(uname | tr '[:upper:]' '[:lower:]')

fish_vi_key_bindings
set -U fish_greeting "🐟"
set -gx EDITOR nvim
set -gx PATH "$HOME/.cargo/bin" $PATH
set -gx GPG_TTY $(tty)
stty erase '^?'

if test $DISTRO = darwin
    fish_add_path -U /opt/homebrew/bin
    fish_add_path /opt/homebrew/opt/llvm/bin
    fish_add_path /opt/homebrew/opt/openjdk/bin
    fish_add_path /opt/homebrew/opt/libpq/bin
    set -gx LDFLAGS -L/opt/homebrew/opt/llvm/lib
    set -gx CPPFLAGS -I/opt/homebrew/opt/llvm/include
    # fish_add_path /usr/local/opt/unzip/bin
    # fish_add_path /usr/local/opt/coreutils/libexec/gnubin
end

abbr reload 'source ~/.config/fish/config.fish'
abbr config 'nvim ~/.dotfiles/myconfig.fish'

abbr ac 'aria2c -x16'
abbr ta 'tmux attach'
abbr find fd
abbr cat bat
abbr ls lsd
abbr la 'lsd -la'
abbr lt 'lsd --tree -L2 --long'
abbr lr 'lsd -ltr'
abbr cx 'chmod +x'
abbr vim nvim
abbr cd. 'cd ../'

abbr --add size --set-cursor="%" 'fd --extension % --exec stat -c %n,%s {} \;'
abbr gc 'git clone'
abbr gco 'git checkout'
abbr gsw 'git switch'
abbr gph 'git push; git push --tags'
abbr gpf 'git push --force-with-lease'
abbr gpu 'git pull'
abbr gps 'git push'
abbr gbd 'git branch --delete'
abbr grb 'git rebase'
abbr gsh 'git stash'
abbr gsp 'git stash pop'
abbr gcm 'git commit -m'
abbr gmm 'git merge origin/main'
abbr nrd 'pnpm run dev'
abbr nrp 'pnpm run preview'
abbr nrb 'pnpm run build'
abbr ff fuck
abbr gl 'lucky_commit (printf "%07d\n" (git rev-list HEAD --count))'

abbr R radian
abbr r radian

abbr ca 'conda activate'
abbr cl 'conda env list'
abbr ci 'mamba install'
abbr mi 'mamba install'
abbr cr 'conda remove --all -n '
abbr pie 'pip install -e .'

thefuck --alias | source
zoxide init fish | source
starship init fish | source

bind -M insert \cf accept-autosuggestion
bind \cf accept-autosuggestion
bind \el nextd-or-forward-word
bind -M insert \eh prevd-or-backward-word
bind -M insert \ef accept-autosuggestion
bind -M insert \eh prevd-or-backward-word
bind -M insert \ef accept-autosuggestion

# Original FZF
setenv FZF_DEFAULT_COMMAND 'fd --type file --follow'
setenv FZF_CTRL_T_COMMAND 'fd --type file --follow'
# setenv FZF_DEFAULT_OPTS '--height 20%'

set -U FZF_DEFAULT_OPTS "--height 80% --bind 'tab:down,btab:up' --layout=reverse --border --info=inline --preview 'bat --color \"always\" {}'"

# jethrokuan/fzf
set -U FZF_PREVIEW_FILE_CMD "bat --style=numbers --color 'always' {}"
set -U FZF_PREVIEW_DIR_CMD "lsd --tree -L1 --color=always"
set -U FZF_COMPLETE 2

set -U FZF_FIND_FILE_COMMAND "fd --hidden --exclude=.git --type f . \$dir"
set -U FZF_CD_COMMAND $FZF_FIND_FILE_COMMAND
set -U FZF_CD_WITH_HIDDEN_COMMAND $FZF_FIND_FILE_COMMAND
set -U FZF_OPEN_COMMAND $FZF_FIND_FILE_COMMAND

set -U nvm_default_version 20

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function copilot_what-the-shell
    set TMPFILE $(mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli what-the-shell "$argv" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set FIXED_CMD $(cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end
alias "cc"="copilot_what-the-shell"

function copilot_git-assist
    set TMPFILE $(mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli git-assist "$argv" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set FIXED_CMD $(cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

alias 'gitt'='copilot_git-assist'

function copilot_gh-assist
    set TMPFILE $(mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if /Users/chaichontat/.local/share/nvm/v18.6.0/bin/github-copilot-cli gh-assist "$argv" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set FIXED_CMD $(cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

alias 'ghh'='copilot_gh-assist'

# https://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m' # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m' # begin bold
setenv LESS_TERMCAP_me \e'[0m' # end mode
setenv LESS_TERMCAP_se \e'[0m' # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m' # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m' # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
