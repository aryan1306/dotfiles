#!/usr/bin/env zsh
#
# Personal aliases and functions.
#
# Loaded automatically by `zgen load $DOTFILES/custom` (see home/.zshrc).
# This file is NOT part of denysdovhan/dotfiles upstream, so nothing here will
# ever conflict when you `git fetch upstream && git merge upstream/master`.
#
# Put new aliases here rather than in lib/aliases.zsh — that file is upstream's
# and every edit to it becomes a merge conflict later.

# Claude Code
# export IS_DEMO=1
export CLAUDE_CODE_NO_FLICKER=1
# export CLAUDE_CODE_NEW_INIT=1
# export CLAUDE_CODE_HIDE_ACCOUNT_INFO=1
alias clc="claude"

# ------------------------------------------------------------------------------
# Notes on aliases deliberately NOT set here
# ------------------------------------------------------------------------------
#
# `rm` — upstream used to alias this to `trash`, which rejects `-rf` and made
# `rm -rf <dir>` fail outright. That alias has been removed. oh-my-zsh's
# `common-aliases` plugin now supplies `alias rm='rm -i'` underneath, so bare
# `rm file` prompts once per file while `rm -rf` still works (-f overrides -i).
# To get an unprompted `rm` back, uncomment:
#
#   alias rm='command rm'
