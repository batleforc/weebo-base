#!/bin/sh
# Re-stage files a pre-commit tool may have rewritten, without widening the commit.
# usage: restage.sh <file listing the paths that had unstaged changes before the tools ran>
# Those paths are left alone, as staging them would commit the user's unstaged work.
git -c core.quotePath=false diff --cached --name-only --diff-filter=ACMR |
  grep -vxFf "$1" |
  xargs -r -d '\n' git add --
