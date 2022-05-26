#!/bin/sh
# 
# Validate all YAML data files with the corresponding schemas.
#
# Requires the following npm packages to be installed:
#   - ajv-cli [1]
#   - ajv-formats [2]
#
# Must be executed from the root directory of the repository.
#
# [1] https://www.npmjs.com/package/ajv-cli
# [2] https://www.npmjs.com/package/ajv-formats

for f in projects organisations tags; do
  ajv --spec draft2020 -c ajv-formats -s schema/"$f".json -d "$f".yaml
done
