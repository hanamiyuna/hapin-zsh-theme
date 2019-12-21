# Hapin theme for Zsh
#
# Author: Hanami Yuna <github@yutsuki.moe>
# 
# Original from Oxide
# Author: Diki Ananta <diki1aap@gmail.com>
# Repository: https://github.com/dikiaap/dotfiles
# License: MIT

# Prompt:
# %F => Color codes
# %f => Reset color
# %~ => Current path
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
#
# Terminal:
# \n => Newline/Line Feed (LF)

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit) if available.
if [[ "${terminfo[colors]}" -ge 256 ]]; then
    hapin_turquoise="%F{73}"
    hapin_orange="%F{179}"
    hapin_red="%F{167}"
    hapin_limegreen="%F{107}"
    hapin_magenta="%F{211}"
    hapin_lightblue="%F{45}"
else
    hapin_turquoise="%F{cyan}"
    hapin_orange="%F{yellow}"
    hapin_red="%F{red}"
    hapin_limegreen="%F{green}"
    hapin_magenta="%F{magenta}"
    hapin_lightblue="%F{lightcyan}"
fi

# Reset color.
hapin_reset_color="%f"

# VCS style formats.
FMT_UNSTAGED="%{$hapin_reset_color%} %{$hapin_orange%}●"
FMT_STAGED="%{$hapin_reset_color%} %{$hapin_limegreen%}✚"
FMT_ACTION="(%{$hapin_limegreen%}%a%{$hapin_reset_color%})"
FMT_VCS_STATUS="on %{$hapin_turquoise%} %b%u%c%{$hapin_reset_color%}"

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# Check for untracked files.
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        hook_com[staged]+="%{$hapin_reset_color%} %{$hapin_red%}●"
    fi
}

# Executed before each prompt.
add-zsh-hook precmd vcs_info

# Oxide prompt style.
PROMPT=$'\n%{$hapin_magenta%}%n%{$hapin_reset_color%}@%{$hapin_limegreen%}%m %{$hapin_lightblue%}%~%{$hapin_reset_color%} ${vcs_info_msg_0_}\n%(?.%{%F{white}%}.%{$hapin_red%})%(!.#.❯)%{$hapin_reset_color%} '

