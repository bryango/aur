#!/bin/bash

set -x

BRANCH=$1
REPO=$2
UPSTREAM=$3

if [[ -z $1 ]]; then bat "$0"; exit; fi
[[ -z $2 ]] && REPO=bryango/aur
[[ -z $2 ]] && UPSTREAM=archlinux/aur

target="$(basename "$REPO")-$(basename "$BRANCH")"
origin="git@github.com:$REPO.git"
upstream="git@github.com:$UPSTREAM.git"

if git clone \
    --filter=blob:none \
    --branch="$BRANCH" \
    --single-branch \
    "$origin" "$target"
then
    exit
fi

## otherwise,
set -xe
commit=$(git ls-remote "$upstream" "$BRANCH" | cut -f1)
echo "$BRANCH"
open "https://github.com/$REPO/tree/$commit"
