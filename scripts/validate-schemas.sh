#!/bin/sh
#
# Validate data files against their JSON schemas.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Parameters
#------------------------------------------------------------------------------#
set -e
container=weibeld/ajv-cli:5.0.0
files=$(printf "projects.yaml\norganisations.yaml\ntags.yaml\n")

#------------------------------------------------------------------------------#
# Preamble
#------------------------------------------------------------------------------#
. scripts/util.sh
ensure_container "$container"

#------------------------------------------------------------------------------#
# Main script
#------------------------------------------------------------------------------#
failed=$(mktemp)
echo "$files" | while read f; do
  ajv --spec draft2020 -c ajv-formats -s schema/"${f%.*}".json -d "$f" || echo 1 >"$failed"
done
[[ -s "$failed" ]] && exit 1 || exit 0
