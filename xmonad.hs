import XMonad

-- Layout.
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

-- Utils.
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops

-- Hooks.
import XMonad.Hooks.ManageDocks (ToggleStruts(..),avoidStruts,docks,manageDocks)

myStartupHook = do
  spawnOnce "nitrogen --restore"
  spawnOnce "$HOME/.config/polybar/polybar_launch.sh"
  spawnOnce "picom"

myLayouts = smartBorders $ avoidStruts tiled ||| noBorders Full
  where
    tiled = spacing 5 $ Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2

main = do
  xmonad . ewmh $ docks defaultConfig
    { terminal = "kitty",
      layoutHook = myLayouts,
      modMask = mod1Mask,
      workspaces = ["1","2","3","4","5","6","7","8","9"],
      borderWidth = 3,
      normalBorderColor = "#4C566A",
      focusedBorderColor = "#5E81AC",
      startupHook = myStartupHook,
      manageHook = manageHook defaultConfig <+> manageDocks
    }
