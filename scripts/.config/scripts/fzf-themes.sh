#!/usr/bin/env bash
set -euo pipefail

# Shared fzf layout for all pickers (adapted from skim-themes.sh).
FZF_THEME_BASE=(
    --color=bw
    --height=100%
    --margin=0,0,0,0
    --layout=reverse
    --info=hidden
    --no-hscroll
)

FZF_THEME_PDF=("${FZF_THEME_BASE[@]}")

FZF_THEME_SESSION=("${FZF_THEME_BASE[@]}" --scheme=path)

FZF_THEME_LINKS=("${FZF_THEME_BASE[@]}" --cycle)
