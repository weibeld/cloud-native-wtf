#!/bin/sh
# Transform a single name (of a project, organisation, or tag) into an ID.

echo "$*" | tr '[:upper:]' '[:lower:]' | tr -s '[:punct:][:blank:]' -
