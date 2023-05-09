#:  * `--repository`, `--repo` [<tap> ...]
#:
#:  Display where Homebrew's git repository is located.
#:
#:  If <user>`/`<repo> are provided, display where tap <user>`/`<repo>'s directory is located.

normalize-tap-arg() {
  local tap="$1"
  local user_repo=(${tap//\// })
  if [ ${#user_repo[@]} -eq 2 ]; then
    if ! [[ "${user_repo[1]}" =~ ^homebrew-.+ ]]; then
      user_repo[1]="homebrew-${user_repo[1]}"
    fi
    echo "${user_repo[0]}/${user_repo[1]}" | tr '[:upper:]' '[:lower:]'
  fi
}

homebrew---repository() {
  # HOMEBREW_REPOSITORY is set by brew.sh
  # shellcheck disable=SC2154
  if [ $# -eq 0 ]; then
    echo "${HOMEBREW_REPOSITORY}"
  else
    for tap in "$@"; do
      tap="$(normalize-tap-arg "${tap}")"
      if [ -n "${tap}" ]; then
        echo "${HOMEBREW_REPOSITORY}/Library/Taps/${tap}"
      else
        odie "Invalid tap name provided!"
      fi
    done
  fi
}
