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
# Notes
# ------------------------------------------------------------------------------
#
# `rm` is aliased to `trash` by upstream's lib/aliases.zsh, so deletions are
# recoverable from the macOS Trash. `trash` takes no flags, so `rm -rf <dir>`
# fails with "Un-recognized argument -rf". Use one of these instead:
#
#   command rm -rf <dir>     # bypass the alias, permanent
#   trash <dir>              # recoverable, directories included
