while :; do
  inotifywait -qq -e modify $HOME/.xmonad/xmonad.hs
  xmonad --recompile && xmonad --restart
done
