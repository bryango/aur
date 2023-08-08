#!/bin/bash

set -x

BRANCH=$1
REPO=$2

if [[ -z $1 ]]; then bat "$0"; exit; fi
[[ -z $2 ]] && REPO=bryango/aur

git clone \
    --filter=blob:none \
    --branch="$BRANCH" \
    --single-branch \
    "git@github.com:$REPO.git" \
    "$(basename "$REPO" | sed -e 's/^arch-//g')-$(basename "$BRANCH")"
