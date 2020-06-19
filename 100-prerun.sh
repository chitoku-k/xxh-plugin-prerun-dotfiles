XXH_SHELL_ZSH=$CURRENT_DIR

if [[ $XDG_CACHE_HOME ]]; then
  done_file=$XDG_CACHE_HOME/xxh-plugin-prerun-dotfiles-done
else
  done_file=$XXH_HOME/.xxh-plugin-prerun-dotfiles-done
fi

if [[ ! -f $done_file ]]; then
  CURR_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  mkdir -p $XDG_CACHE_HOME

  tar -xmf $CURR_DIR/archive.tar.gz -C $CURR_DIR
  cp $CURR_DIR/bin/* $XXH_SHELL_ZSH/zsh-bin/bin
  cp -r $CURR_DIR/dotfiles $XXH_HOME/dotfiles
  cp -r $CURR_DIR/antigen $XDG_CACHE_HOME/antigen

  cd $XXH_HOME/dotfiles
  ./install <<< '1 4 5 12'

  PATH=$XXH_SHELL_ZSH/zsh-bin/bin:$PATH \
    $XDG_CACHE_HOME/antigen/bundles/junegunn/fzf/install --all --xdg --no-update-rc > /dev/null

  # pseudo git for antigen
  if ! type git &> /dev/null; then
    echo "#!/bin/bash\nexit 1" > $XXH_SHELL_ZSH/zsh-bin/bin/git
    chmod +x $XXH_SHELL_ZSH/zsh-bin/bin/git
  fi

  cp $XXH_HOME/.zshenv $XXH_SHELL_ZSH
  touch $done_file
fi

cd $XXH_HOME
