import XMonad

-- Layout.
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import qualified XMonad.StackSet as W

-- Utils.
import XMonad.Util.SpawnOnce
-- Makes XMonad EWMH compatible (So polybar can know the workspaces on XMonad).
import XMonad.Hooks.EwmhDesktops
-- For using scratchpads.
import XMonad.Util.NamedScratchpad
-- For applying actions on all of the windows in the current workspace.
import XMonad.Actions.WithAll
-- For manipulating layouts on command.
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.SetWMName
import XMonad.Layout.TrackFloating

-- Hooks.
import XMonad.Hooks.ManageDocks (ToggleStruts(..),avoidStruts,docks,manageDocks)
import XMonad.Hooks.DynamicProperty

-- For keybindings.
import XMonad.Util.EZConfig

-- Startup scripts.
-- Maybe create a master script.
myStartupHook = do
  -- Sets wallpaper and start wallshow.
  spawnOnce "perl6 $HOME/.xmonad/scripts/wallshow.pm6 $HOME/Wallpapers/Single/ 10" 
  -- Status bar on top.
  spawnOnce "$HOME/.config/polybar/polybar_launch.sh"
  -- Compositor (Transparency and shadows).
  spawnOnce "picom"
  -- Script that recompiles and restarts XMonad when a change occurs in this file.
  spawnOnce "$HOME/.xmonad/scripts/hot_reload.sh"
  setWMName "LG3D"

-- Layouts.
myLayouts = smartBorders $ mkToggle (FULL ?? EOT) $ avoidStruts(tiled ||| Mirror tiled) 
  where
    tiled = spacing 5 $ ResizableTall nmaster delta ratio []
    nmaster = 1
    delta = 3/100
    ratio = 1/2

-- Scratchpads.
myScratchPads = 
  [ 
    NS "spotify" "spotify" (resource =? "spotify") defaultFloating,
    NS "terminal" (myTerminal ++ " --title=scratchpad-terminal --class=scratchpad-terminal") (resource =? "scratchpad-terminal") defaultFloating
  ]

-- Custom keybindings.
myKeybindings = 
  [
    ("M-C-s", namedScratchpadAction myScratchPads "spotify"),
    ("M-C-t", namedScratchpadAction myScratchPads "terminal"),
    ("M-p", spawn "rofi -show drun -display-drun '⟶  '"),
    ("M-C-S-k", killAll),
    ("M-n", spawn "networkmanager_dmenu"),
    ("M-C-l", spawn "light-locker-command -l"),
    ("M-C-f", sendMessage $ Toggle FULL),
    ("M-a", sendMessage $ MirrorExpand),
    ("M-z", sendMessage $ MirrorShrink)
  ]

-- HandleEventsHooks.
spotifyHandleEventHook = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> floating)
  where floating  = customFloating $  W.RationalRect (1/17) (1/17) (8/9) (8/9)

terminalHandleEventHook = dynamicPropertyChange "WM_NAME" (title =? "scratchpad-terminal" --> floating)
  where floating  = customFloating $  W.RationalRect (1/6) (1/6) (2/3) (2/3)

myHandleEventHook = spotifyHandleEventHook <+> terminalHandleEventHook

-- Custom variables.
myTerminal = "kitty"
myModMask = mod1Mask
myWorkspaces = ["爵 WEB", "{} DEV", ">_ TERM", "力 DB", "ﭧ TEST", "鷺 COMS", "WRT", "GG"]
myBorderWidth = 3
myNormalBorderColor = "#4C566A"
myFocusedBorderColor = "#5E81AC"

-- Main.
main = do
  xmonad . ewmh $ docks defaultConfig
    { 
      terminal = myTerminal,
      layoutHook = myLayouts,
      modMask = myModMask,
      workspaces = myWorkspaces,
      borderWidth = myBorderWidth,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      startupHook = myStartupHook,
      manageHook = manageHook defaultConfig <+> manageDocks <+> namedScratchpadManageHook myScratchPads,
      handleEventHook = myHandleEventHook
    } `additionalKeysP` myKeybindings

