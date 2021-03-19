import System.IO
import System.Exit

import XMonad

-- Config
import XMonad.Config.Desktop
import XMonad.Config.Azerty

-- Hooks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Hooks.UrgencyHook

-- Layout
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.SubLayouts
import XMonad.Layout.NoBorders
import XMonad.Layout.Simplest
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Renamed
import XMonad.Layout.WindowNavigation
-- import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens
import XMonad.Layout.CenteredMaster(centerMaster)

-- Utils
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP, additionalMouseBindings)
import XMonad.Util.Run(spawnPipe)

-- Actions
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.SinkAll
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves(rotSlavesDown, rotAllDown)

-- Data
import Data.Maybe (isJust)

import Graphics.X11.ExtraTypes.XF86
import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D

-- Variables
myTerminal :: String
myTerminal = "alacritty"

myEditor :: String
myEditor = "code"

myBrowser :: String
myBrowser = "firefox"

myPDFReader :: String
myPDFReader = "okular"

myFileManager :: String
myFileManager = "pcmanfm"

myMusicPlayer :: String
myMusicPlayer = "spotify"

myFont :: String
myFont = "xft:JetBrainsMono Nerd Font:regular:size=12:antialias=true:hinting=true"

myBorderWidth = 3

myModMask :: KeyMask
myModMask = mod4Mask

myStartupHook :: X ()
myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    setWMName "LG3D"

-- colours
normBord = "#1B2B34"
focdBord = "#EC5F67"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myWorkspaces    = ["\61728","\62057","\61853","\61749","\61501","\61502","\61705","\61564","\61884","Extras"]
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]


myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61635" | x <- my4Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61502" | x <- my5Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61501" | x <- my6Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61705" | x <- my7Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61564" | x <- my8Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\62150" | x <- my9Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61872" | x <- my10Shifts]
    ]
    where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["Arandr", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal"]
    myTFloats = ["Downloads", "Save As...", "Figure 1", "Figure 2", "Figure 3", "Figure 4", "Figure 5", "Figure 6"]
    myRFloats = []
    myIgnores = ["desktop_window"]
    -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
    -- my2Shifts = []
    -- my3Shifts = ["Inkscape"]
    -- my4Shifts = []
    -- my5Shifts = ["Gimp", "feh"]
    -- my6Shifts = ["vlc", "mpv"]
    -- my7Shifts = ["Virtualbox"]
    -- my8Shifts = ["Thunar"]
    -- my9Shifts = []
    -- my10Shifts = ["discord"]




--myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
myLayout = avoidStruts $ spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
    where
        tiled = ResizableTall nmaster delta tiled_ratio []
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2

-- Tab Theme
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

myMouseBindings XConfig {XMonad.modMask = modMask} = M.fromList 

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)

    ]


-- keys config

myKeys conf@ XConfig {XMonad.modMask = modMask} = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [ ((modMask, xK_e), spawn myEditor )
  , ((modMask, xK_c), spawn "conky-toggle" )
  , ((modMask, xK_r), spawn "rofi-theme-selector" )
  , ((modMask, xK_v), spawn "pavucontrol" )
  , ((modMask, xK_y), spawn "polybar-msg cmd toggle" )
  , ((modMask, xK_x), spawn "arcolinux-logout" )
  , ((modMask, xK_m), spawn myMusicPlayer)
  , ((modMask, xK_o), spawn myPDFReader)
  , ((modMask, xK_Escape), spawn "xkill" )
  , ((modMask, xK_Return), spawn myTerminal )
  , ((modMask, xK_b), spawn myBrowser )
  , ((modMask, xK_F2), spawn myEditor )
  , ((modMask, xK_F6), spawn "vlc --video-on-top" )
  , ((modMask, xK_F10), spawn "spotify" )
  , ((modMask, xK_F11), spawn "rofi -show run -fullscreen" )
  , ((modMask, xK_F12), spawn "rofi -show run" )

  -- FUNCTION KEYS
  , ((0, xK_F12), spawn "xfce4-terminal --drop-down" )

  -- SUPER + SHIFT KEYS

  , ((modMask .|. shiftMask , xK_Return ), spawn myFileManager)
  , ((modMask .|. shiftMask , xK_p ), spawn "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")
  , ((modMask .|. shiftMask , xK_r ), spawn "xmonad --recompile && xmonad --restart")
  , ((modMask .|. shiftMask , xK_c ), kill)
  , ((modMask .|. shiftMask , xK_e ), spawn "texstudio")

  -- CONTROL + ALT KEYS

  , ((controlMask .|. mod1Mask , xK_a ), spawn "xfce4-appfinder")
  , ((controlMask .|. mod1Mask , xK_b ), spawn "thunar")
  , ((controlMask .|. mod1Mask , xK_e ), spawn "arcolinux-tweak-tool")
  , ((controlMask .|. mod1Mask , xK_f ), spawn myBrowser)
  , ((controlMask .|. mod1Mask , xK_i ), spawn "nitrogen")
  , ((controlMask .|. mod1Mask , xK_k ), spawn "arcolinux-logout")
  , ((controlMask .|. mod1Mask , xK_l ), spawn "arcolinux-logout")
  , ((controlMask .|. mod1Mask , xK_m ), spawn "xfce4-settings-manager")
  , ((controlMask .|. mod1Mask , xK_o ), spawn "$HOME/.xmonad/scripts/picom-toggle.sh")
  , ((controlMask .|. mod1Mask , xK_p ), spawn "pamac-manager")
  , ((controlMask .|. mod1Mask , xK_r ), spawn "rofi-theme-selector")
  , ((controlMask .|. mod1Mask , xK_s ), spawn "spotify")
  , ((controlMask .|. mod1Mask , xK_t ), spawn myTerminal)
  , ((controlMask .|. mod1Mask , xK_u ), spawn "pavucontrol")
  , ((controlMask .|. mod1Mask , xK_w ), spawn "arcolinux-welcome-app")
  , ((controlMask .|. mod1Mask , xK_Return ), spawn myTerminal)

  -- ALT + ... KEYS

  , ((mod1Mask, xK_f), spawn "variety -f" )
  , ((mod1Mask, xK_n), spawn "variety -n" )
  , ((mod1Mask, xK_p), spawn "variety -p" )
  , ((mod1Mask, xK_r), spawn "xmonad --restart" )
  , ((mod1Mask, xK_Up), spawn "variety --pause" )
  , ((mod1Mask, xK_Down), spawn "variety --resume" )
  , ((mod1Mask, xK_Left), spawn "variety -p" )
  , ((mod1Mask, xK_Right), spawn "variety -n" )
  , ((mod1Mask, xK_F2), spawn "gmrun" )
  , ((mod1Mask, xK_F3), spawn "xfce4-appfinder" )

  --VARIETY KEYS WITH PYWAL

  , ((mod1Mask .|. shiftMask , xK_f ), spawn "variety -f && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_n ), spawn "variety -n && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_p ), spawn "variety -p && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_t ), spawn "variety -t && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_u ), spawn "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")

  --CONTROL + SHIFT KEYS

  , ((controlMask .|. shiftMask , xK_Escape ), spawn "xfce4-taskmanager")

  --SCREENSHOTS

  , ((0, xK_Print), spawn "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")
  , ((controlMask, xK_Print), spawn "xfce4-screenshooter" )
  , ((controlMask .|. shiftMask , xK_Print ), spawn "gnome-screenshot -i")


  --MULTIMEDIA KEYS

  -- Mute volume
  , ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")

  -- Decrease volume
  , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")

  -- Increase volume
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")

  -- Increase brightness
  , ((0, xF86XK_MonBrightnessUp),  spawn "xbacklight -inc 5")

  -- Decrease brightness
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")

--  , ((0, xF86XK_AudioPlay), spawn $ "mpc toggle")
--  , ((0, xF86XK_AudioNext), spawn $ "mpc next")
--  , ((0, xF86XK_AudioPrev), spawn $ "mpc prev")
--  , ((0, xF86XK_AudioStop), spawn $ "mpc stop")

  , ((0, xF86XK_AudioPlay), spawn "playerctl play-pause")
  , ((0, xF86XK_AudioNext), spawn "playerctl next")
  , ((0, xF86XK_AudioPrev), spawn "playerctl previous")
  , ((0, xF86XK_AudioStop), spawn "playerctl stop")


  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Switch focus to next monitor
  , ((modMask, xK_period), nextScreen)

  -- Switch focus to prev monitor
  , ((modMask, xK_comma), prevScreen)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  -- Push window back into tiling.
  , ((modMask, xK_t), withFocused $ windows . W.sink)

  --Focus selected desktop
  , ((controlMask .|. mod1Mask , xK_Left ), prevWS)

  --Focus selected desktop
  , ((controlMask .|. mod1Mask , xK_Right ), nextWS)

    -- Shrink vert window width
  , ((modMask .|. mod1Mask, xK_j), sendMessage MirrorShrink)

  -- Expand vert window width
  , ((modMask .|. mod1Mask, xK_k), sendMessage MirrorExpand)

  -- Shrink the master area.
  , ((modMask, xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l), sendMessage Expand)

  -- Move focus to the next window.
  , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k), windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m), windows W.focusMaster )

  -- Move window to next screen
  , ((modMask .|. shiftMask, xK_period), shiftNextScreen)

  -- Move window to prev screen
  , ((modMask .|. shiftMask, xK_comma), shiftPrevScreen)

  -- Move focused window to master, others maintain order
  , ((modMask, xK_BackSpace), promote)

  -- Swap the focused window and the master window
  , ((modMask .|. shiftMask, xK_m), windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )

  -- Push all windows back into tiling.
  , ((modMask .|. shiftMask , xK_t), sinkAll)

  -- Rotate all windows except master and keep focus in place
  , ((modMask .|. shiftMask , xK_Tab), rotSlavesDown)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Rotate all the windows in the current stack
  , ((controlMask .|. modMask, xK_Tab), rotAllDown)

  -- Increment the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

  --French Azerty users use this line
  -- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_minus, xK_egrave, xK_underscore, xK_ccedilla , xK_agrave]

  --Belgian Azerty users use this line
  -- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_section, xK_egrave, xK_exclam, xK_ccedilla, xK_agrave]

      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

  ++
  -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

  -- Needed for scratchpads???
      where nonNSP = WSIs (return (\ws -> W.tag ws /= "nsp"))
            nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))


main :: IO ()
main = do

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


    xmonad . ewmh $
        myBaseConfig
            { startupHook = myStartupHook
            , layoutHook = myLayout -- ||| layoutHook myBaseConfig
            , manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
            , modMask = myModMask
            , borderWidth = myBorderWidth
            , handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook <+> docksEventHook
            , focusFollowsMouse = myFocusFollowsMouse
            , workspaces = myWorkspaces
            , focusedBorderColor = focdBord
            , normalBorderColor = normBord
            , keys = myKeys
            , mouseBindings = myMouseBindings
            }
