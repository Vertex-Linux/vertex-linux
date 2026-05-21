# ~/.bashrc — Vertex Linux default shell config

# Only run in interactive shells
[[ $- != *i* ]] && return

# Auto-start fastfetch on new terminal sessions (not in subshells)
if [[ -z "$FASTFETCH_SHOWN" ]] && command -v fastfetch &>/dev/null; then
    export FASTFETCH_SHOWN=1
    fastfetch
fi
