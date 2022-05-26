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
unset failed

# Normalisation of names as per the above definition.
normalise() {
  tr '[:upper:]' '[:lower:]' | tr -d '[:blank:][:punct:]'
}

for f in "${FILES[@]}"; do
  duplicates=$(cat "$f" | yq '.[].name' | normalise | sort | uniq -d) 
  if [[ -z "$duplicates" ]]; then
    echo "$f valid"
  else
    # Use 'printf' instead of 'echo -e', 'echo -n', etc. because these options
    # are not supported in all environmets (e.g. in sh on macOS).
    printf "$f invalid\n$(colour_red)Duplicates:\n$duplicates$(colour_reset)\n"
    failed=1
  fi
done

[[ -z "$failed" ]] && exit 0 || exit 1
