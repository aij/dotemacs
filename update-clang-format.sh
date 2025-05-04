#!/usr/bin/env bash

# Filter the clang/tools/clang-format/ subdir from the llvm-project repo
# See file clang-format-re-extraction.org for details.

set -e -u
set -o pipefail

tmp="$(mktemp -d)"

cd $tmp

echo Using tmp dir "$tmp"
set -x

time git clone --single-branch https://github.com/llvm/llvm-project.git clang-format-el
cd clang-format-el
time git filter-repo --subdirectory-filter clang/tools/clang-format --prune-empty always

git remote add origin git@github.com:aij/clang-format.git
git push origin HEAD:filtered
