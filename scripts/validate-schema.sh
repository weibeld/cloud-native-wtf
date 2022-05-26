#!/bin/sh
# 
# Validate all YAML data files with the corresponding schemas. The script
# exits with exit code 1 if any of the data files is invalid.
#
# Requires the following npm packages to be installed:
#   - ajv-cli [1]
#   - ajv-formats [2]
#
# Must be executed from the root directory of the repository.
#
# [1] https://www.npmjs.com/package/ajv-cli
# [2] https://www.npmjs.com/package/ajv-formats

unset failed

for f in projects organisations tags; do
  ajv --spec draft2020 -c ajv-formats -s schema/"$f".json -d "$f".yaml || failed=1
done

[[ -z "$failed" ]] && exit 0 || exit 1
