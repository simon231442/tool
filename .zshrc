# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# alias
alias no="norminette -R CheckForbiddenSourceHeader"
alias noh="norminette -R CheckDefine"
alias c+="gcc -Wall -Wextra -Werror"
alias newcfile=create_c_file 

# Fonction pour créer un nouveau fichier .c avec un header
create_c_file() {
    # Vérification de l'argument
    if [ -z "$1" ]; then
        echo "Erreur: Nom de fichier manquant."
        return
    fi

    # Vérification de l'existence du fichier
    if [ -f "$1" ]; then
        echo "Erreur: Le fichier $1 existe déjà."
        return
    fi

    # Création du fichier et ajout du header
    touch "$1"
    echo "/* ************************************************************************** */" > "$1"
    echo "/*                                                                            */" >> "$1"
    echo "/*                                                        :::      ::::::::   */" >> "$1"
    printf "/*   %-50s :+:      :+:    :+:   */\n" $1 >> "$1"
    echo "/*                                                    +:+ +:+         +:+     */" >> "$1"
    echo "/*   By: srenaud <simon2314@hotmail.com>            +#+  +:+       +#+        */" >> "$1"
    echo "/*                                                +#+#+#+#+#+   +#+           */" >> "$1"
    echo "/*   Created: $(date +'%Y/%m/%d %H:%M:%S') by srenaud           #+#    #+#             */" >> "$1"
    echo "/*   Updated: $(date +'%Y/%m/%d %H:%M:%S') by srenaud          ###   ########.fr       */" >> "$1"
    echo "/*                                                                            */" >> "$1"
    echo "/* ************************************************************************** */" >> "$1"
	echo "" >> "$1"
}
