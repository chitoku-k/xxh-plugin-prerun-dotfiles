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

curl -sSfL 'https://github.com/junegunn/fzf/releases/download/0.27.0/fzf-0.27.0-linux_amd64.tar.gz' | tar xf -
mv fzf bin/

curl -sSfLOJ 'https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64'
mv jq-linux64 bin/jq
chmod +x bin/jq

curl -sSfL 'https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz' | tar xf - 'fd-v8.2.1-x86_64-unknown-linux-musl/fd'
mv 'fd-v8.2.1-x86_64-unknown-linux-musl/fd' bin/

mkdir -p antigen/bundles
pushd antigen/bundles > /dev/null
for repo in $(cat ../../dotfiles/config/zsh/bundles); do
    if [[ $repo = *:* ]]; then
        git clone --quiet "$repo" "$repo"
    elif [[ $repo = *.* ]]; then
        git clone --quiet "https://$repo" "$repo"
    else
        git clone --quiet "https://github.com/$repo" "$repo"
    fi
done
find . -path '*/.git*' -delete
popd > /dev/null

tar -Jcf archive.tar.xz dotfiles antigen bin

for f in *prerun.sh archive.tar.xz
do
  cp -r $CDIR/$f $build_dir/
done
