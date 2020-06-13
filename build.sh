#!/usr/bin/env bash

CDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
build_dir=$CDIR/build

while getopts A:K:q option
do
  case "${option}"
  in
    q) QUIET=1;;
    A) ARCH=${OPTARG};;
    K) KERNEL=${OPTARG};;
  esac
done

cd $CDIR
rm -rf $build_dir && mkdir -p $build_dir

git clone --quiet https://github.com/chitoku-k/dotfiles
rm -rf dotfiles/.git

for f in *prerun.sh dotfiles
do
  cp -r $CDIR/$f $build_dir/
done
