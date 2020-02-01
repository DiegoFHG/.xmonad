import XMonad

-- Layout.
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W

-- Utils.
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops
-- For using scratchpads.
import XMonad.Util.NamedScratchpad

-- Hooks.
import XMonad.Hooks.ManageDocks (ToggleStruts(..),avoidStruts,docks,manageDocks)
import XMonad.Hooks.DynamicProperty

-- For keybindings.
import XMonad.Util.EZConfig

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

myScratchPads = [ NS "spotify" spawnSpotify findSpotify manageSpotify
                ]

  where
    spawnSpotify = "$HOME/.xmonad/scripts/spotify_scratchpad.sh"
    findSpotify = resource =? "spotify"
    manageSpotify = customFloating $ W.RationalRect l t w h
      where
        h = 0.7
        w = 0.7
        t = 0.75 -h
        l = 0.75 -w

myKeybindings = 
  [
    ("M-C-s", namedScratchpadAction myScratchPads "spotify")
  ]

myHandleEventHook = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> floating)
    where floating  = customFloating $ W.RationalRect (1/8) (1/8) (4/5) (4/5)

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
      manageHook = manageHook defaultConfig <+> manageDocks,
      handleEventHook = myHandleEventHook
    } `additionalKeysP` myKeybindings
