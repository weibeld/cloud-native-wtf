# Common utilities to be sourced in every script.

# The data files to process
FILES=(projects.yaml organisations.yaml tags.yaml)

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
