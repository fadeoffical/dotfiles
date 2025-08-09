#!/usr/bin/env zsh

# history
export HISTSIZE=10000
export SAVEHIST=3000
export HISTFILE="$HOME/.zsh_history"

# add keepassxc ssh agent to path
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# add ~/.local/bin to path if it is not already part of it
case ":${PATH}:" in
    *:"$HOME/.local/bin":*)
        ;;
    *)
        export PATH="$HOME/.local/bin:$PATH"
	;;
esac

# source rust environment configuration
. "$HOME/.cargo/env"
