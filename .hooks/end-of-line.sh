#! /bin/sh
# A hook script to ensure files have proper end-of-line characters.
# This script checks the staged version of each file and ensures it ends with a newline character.
# It rewrites the index directly so unstaged changes of a partially staged file stay out of the commit.
# Binary files and deleted files are skipped.

# Handle filenames containing spaces
IFS="
"

# Get the list of staged files (added/copied/modified only, skip deletions)
STAGED_FILES=$(git -c core.quotePath=false diff --cached --name-only --diff-filter=ACM)

for FILE in $STAGED_FILES; do
    # Only text files (grep -qI skips binaries), whose staged version lacks a final newline
    if git show ":$FILE" | grep -qI '' && [ -n "$(git show ":$FILE" | tail -c1 | tr -d '\n')" ]; then
        echo "Fixing end-of-line for $FILE"
        BLOB=$({ git show ":$FILE"; echo; } | git hash-object -w --stdin)
        MODE=$(git ls-files -s -- "$FILE" | cut -d' ' -f1)
        git update-index --cacheinfo "$MODE,$BLOB,$FILE"
        # Keep the working copy in line, so the file does not show up as modified after the commit
        if [ -f "$FILE" ] && [ -n "$(tail -c1 "$FILE" | tr -d '\n')" ]; then
            echo "" >> "$FILE"
        fi
    fi
done

echo "[End-of-Line Fixer] All done!"

exit 0
