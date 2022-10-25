# Utilities intended to be sourced by other scripts.
#
# CAUTION: this code may be executed by different shells, including the most
# restricted versions of sh, and on different platforms, such as Ubuntu, Alpine,
# BusyBox, etc. For this reason, the code should only include the greatest
# common denominator of features that are supported by all common shells on all
# common platfomrs (for example, avoid '[[', '<<<', arrays, etc.).

# Coloured output
colour_red() { printf '\e[31m'; }
colour_reset() { printf '\e[0m'; }

# Convert names to IDs according to the following rules:
#   - Transform letters to lower case
#   - Replace blank and punctuation characters by dashes
# Each line of input is converted separately.
name_to_id() {
  tr '[:upper:]' '[:lower:]' | tr -s '[:punct:][:blank:]' -
}

# Normalises the path of a file as a relative path from the current working 
# directory. For example, assuming that the current directory is REPO:
#     scripts/foo/script.sh
#     /Users/dw/Desktop/REPO/scripts/foo/script.sh
#     ../../Desktop/REPO/scripts/foo/script.sh
# are all normalised to:
#     scripts/foo/script.sh
normalise_path() {
  local a=$(cd "$(dirname "$0")" && pwd)/"$(basename "$0")"
  echo "${a#$PWD/}"
}

# Check if the script is currently running inside a container, and if not, start
# the container that is passed as an argument and instruct it to run the same
# script (that is currently being executed), then exit the current invocation
# of the script. This basically ensures that the script from which this function
# is called runs inside the specified container.
ensure_container() {
  if [ ! "$OS_ENV" = container ]; then
    docker run \
      -e OS_ENV=container \
      -v "$PWD":/repo \
      -w /repo \
      --entrypoint sh \
      "$1" "$(normalise_path "$0")"
    exit "$?"
  fi
}
