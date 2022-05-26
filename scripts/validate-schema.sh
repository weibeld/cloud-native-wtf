#!/bin/sh
# 
# Validate all YAML data files with their corresponding JSON schema.
#
# Requirements:
#   - npm packages ajv-cli [1] and ajv-formats [2] must be installed.
#   - Must be executed from the root directory of the repository.
#
# [1] https://www.npmjs.com/package/ajv-cli
# [2] https://www.npmjs.com/package/ajv-formats

. scripts/_commons.sh
unset failed

files | while read f; do
  ajv --spec draft2020 -c ajv-formats -s schema/"${f%.*}".json -d "$f" || failed=1
done

[[ -z "$failed" ]] && exit 0 || exit 1
