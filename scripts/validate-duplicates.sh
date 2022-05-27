#!/bin/sh
#
# Check for duplicate entries in the data files. Two entries are regarded as
# duplicates if the normalised forms of their "name" fields are identical.
# Normalisation currently is defined as:
#   - Transforming all letters to lower case
#   - Removing all blank and punctuation characters
# For example, "CI/cd", "CICD", and "ci-cd" would all be regarded as duplicates
# because they all normalise to the form "cicd".
#
# Requirements:
#   - yq [1] must be installed.
#   - Must be executed from the root directory of the repository.
#
# [1] https://github.com/mikefarah/yq

. scripts/_commons.sh
failed=$(mktemp)

# Normalisation of names as per the above definition.
normalise() {
  tr '[:upper:]' '[:lower:]' | tr -d '[:blank:][:punct:]'
}

files | while read f; do
  duplicates=$(cat "$f" | yq '.[].name' | normalise | sort | uniq -d || echo 1 >"$failed") 
  if [[ -z "$duplicates" ]]; then
    echo "$f valid"
  else
    printf "$f invalid\n$(colour_red)Duplicates:\n$duplicates$(colour_reset)\n"
    echo 1 >"$failed"
  fi
done

[[ -s "$failed" ]] && exit 1 || exit 0
