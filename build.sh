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
rm -rf $build_dir && mkdir -p $build_dir && mkdir bin

git clone --quiet https://github.com/chitoku-k/dotfiles
rm -rf dotfiles/.git

git clone --quiet https://github.com/zsh-users/antigen
rm -rf antigen/.git

curl -sSfL 'https://github.com/junegunn/fzf-bin/releases/download/0.21.1/fzf-0.21.1-linux_386.tgz' | tar xf -
mv fzf bin/

curl -sSfL 'https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-v8.1.1-x86_64-unknown-linux-musl.tar.gz' | tar xf - 'fd-v8.1.1-x86_64-unknown-linux-musl/fd'
mv 'fd-v8.1.1-x86_64-unknown-linux-musl/fd' bin/

mkdir -p antigen/bundles
pushd antigen/bundles
xargs -n 1 -I '{}' git clone --quiet 'https://github.com/{}' '{}' < ../../dotfiles/config/zsh/bundles
find . -path '*/.git*' -delete
popd

for f in *prerun.sh dotfiles antigen bin
do
  cp -r $CDIR/$f $build_dir/
done
