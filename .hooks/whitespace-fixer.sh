#!/bin/bash
# A git hook script to find and fix trailing whitespace in your commits.
# Bypass it with the --no-verify option to git-commit.
# shortcut: GNU sed only (Linux/Che), add a BSD branch if a project is developed on macOS.

# change IFS to ignore filename's space in |for|
IFS=$'\n'
# autoremove trailing whitespace
for line in $(git -c core.quotePath=false diff --check --cached | sed '/^[+-]/d'); do
  file="$(echo "$line" | sed -E 's/:[0-9]+: .*//')"
  # two trailing spaces are a hard line break in Markdown
  case "$file" in *.md) continue ;; esac
  # display tips
  echo -e "auto remove trailing whitespace in \033[31m$file\033[0m!"
  # since $file in working directory isn't always equal to $file in index, so we backup it
  mv -f "$file" "${file}.save"
  # discard changes in working directory
  git checkout -- "$file"
  # remove trailing whitespace
  sed -i 's/[[:space:]]*$//' "$file"
  git add "$file"
  # restore the $file
  sed 's/[[:space:]]*$//' "${file}.save" > "$file"
  rm "${file}.save"
done

if ! git status -s | grep -q '^[ADMR]'; then
  # empty commit
  echo
  echo -e "\033[31mNO CHANGES ADDED, ABORT COMMIT!\033[0m"
  exit 1
fi

echo "[Whitespace Fixer] All done!"
# Now we can commit
exit
