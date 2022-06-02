#!/bin/sh
#
# Check for duplicate entries in the data files. Two entries are regarded as
# duplicates if they have an identical "name" field after normalisation.
# Normalisation is defined as:
#   - All letters transformed to lower case
#   - All blanks and punctuation characters removed
# For example: "CI/CD" => "cicd", "ci-cd" => "cicd"
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Parameters
#------------------------------------------------------------------------------#
container=mikefarah/yq:4.25.1
files=$(printf "projects.yaml\norganisations.yaml\ntags.yaml\n")

#------------------------------------------------------------------------------#
# Preamble
#------------------------------------------------------------------------------#
. scripts/util.sh
ensure_container "$container"
set -e -o pipefail

#------------------------------------------------------------------------------#
# Main script
#------------------------------------------------------------------------------#

# Normalise names as per the above definition
normalise() {
  tr '[:upper:]' '[:lower:]' | tr -d '[:blank:][:punct:]'
}

failed=$(mktemp)
echo "$files" | while read f; do
  duplicates=$(cat "$f" | yq '.[].name' | normalise | sort | uniq -d) 
  if [[ -z "$duplicates" ]]; then
    echo "$f valid"
  else
    n=$(echo "$duplicates" | wc -l | tr -d ' ')
    [[ "$n" -gt 1 ]] && ending=s || ending=
    echo "$f invalid" >&2
    printf "$(colour_red)Found $n duplicate$ending:\n$duplicates$(colour_reset)\n" | sed 's/^/  /' >&2
    echo 1 >"$failed"
  fi
done
[[ -s "$failed" ]] && exit 1 || exit 0
