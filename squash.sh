squash() {
  count=$1
  shift
  has_message=false
  message=""
  commit_options=""
  while [ $# -gt 0 ]; do
    case $1 in
      -m) has_message=true; message="$2"; shift ;; # Just store the message without -m for display
      *) commit_options="$commit_options $1" ;;
    esac
    shift
  done
  # ANSI escape codes for bold text
  bold=$(tput bold)
  normal=$(tput sgr0)
  echo "${bold}You are about to squash the last $count commits.${normal}"
  echo ""
  # Capture recent commit messages into a variable
  recent_commits=$(git log -n $count --pretty=format:"%h - %an: %s")
  echo "${bold}Commit messages:${normal}"
  echo "$recent_commits"
  echo ""

  if [ -n "$commit_options" ]; then
    echo "${bold}Additional commit options:${normal} $commit_options"
  fi

  # Get the earliest commit message from the range to be squashed
  earliest_commit_message=$(git log --reverse -n $count --pretty=format:"%s" | head -n 1)

  if [ "$has_message" = true ]; then
    echo "${bold}Commit message:${normal} $message"
  else
    echo "${bold}Default commit message: ${normal}$earliest_commit_message"
    echo -n "${bold}Press Enter to use the default message or type a new one: ${normal}"
    read user_message
    if [ -n "$user_message" ]; then
      message="$user_message"
    else
      message="$earliest_commit_message"
    fi
    has_message=true
  fi
}