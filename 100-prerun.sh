XXH_SHELL_ZSH=$CURRENT_DIR

if [[ $XDG_CACHE_HOME ]]; then
  mkdir -p $XDG_CACHE_HOME
  done_file=$XDG_CACHE_HOME/xxh-plugin-prerun-dotfiles-done
else
  done_file=$XXH_HOME/.xxh-plugin-prerun-dotfiles-done
fi

if [[ ! -f $done_file ]]; then
  CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  cp -r $CURR_DIR/dotfiles $XXH_HOME/dotfiles
  cp -r $CURR_DIR/antigen $XDG_CACHE_HOME/antigen

  cd $XXH_HOME/dotfiles
  ./install <<< '1 3 4 11'

  cp $XXH_HOME/.zshenv $XXH_SHELL_ZSH
  touch $done_file
fi

cd $XXH_HOME
