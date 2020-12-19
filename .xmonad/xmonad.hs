-- xmonad example config file for xmonad-0.9
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- NOTE: Those updating from earlier xmonad versions, who use
-- EwmhDesktops, safeSpawn, WindowGo, or the simple-status-bar
-- setup functions (dzen, xmobar) probably need to change
-- xmonad.hs, please see the notes below, or the following
-- link for more details:
--
-- http://www.haskell.org/haskellwiki/Xmonad/Notable_changes_since_0.8
--

-- IMPORTS

    -- Base
import XMonad
import System.Exit

    -- Data

import Data.Monoid

    -- Actions
import XMonad.Actions.WithAll
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)

    -- Hooks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

    -- Layout
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns

    -- Util
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.Run -- spawnPipe

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Width of the window border in pixels.
--
myBorderWidth   = 5

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask


myAppLauncher   = "exe=`dmenu_path | dmenu` && eval \"exec $exe\""

-- NOTE: from 0.9.1 on numlock mask is set automatically. The numlockMask
-- setting should be removed from configs.
--
-- You can safely remove this even on earlier xmonad versions unless you
-- need to set it to something other than the default mod2Mask, (e.g. OSX).
--
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
-- myNumlockMask   = mod2Mask -- deprecated in xmonad-0.9.1
------------------------------------------------------------


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#f8c134" -- Flag Yellow

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--

--Super is M, Alt is M1, Shift is S, Ctrl is C
--Space, Tab, Backspace, Up/Down/Left/Right are all <XXX>
myKeys :: [([Char], X ())]
myKeys =
        --Xmonad
        [ ("M-q", spawn "xmonad --recompile; xmonad --restart") --Restart Xmonad
        , ("M-S-q", io (exitWith ExitSuccess))                  --Exit Xmonad

        --Program launch keybindings
        --, ("M-t", spawn $ Xmonad.terminal conf) -- launch a terminal
        , ("M-p", spawn myAppLauncher)          -- launch dmenu
        --insert emacs

        --Kill windows
        , ("M-S-c", kill)                       --close focused window
        , ("M-S-a", killAll)                    --kill all windows in workspace

        --Layouts
        , ("M-<Space>", sendMessage NextLayout) --Rotate through available layouts
        --, ("M-S-<Space>", setLayout $ XMonad.layoutHook conf) --Reset layouts to default

        --Window resizing
        , ("M-n", refresh)                      --Resize viewed windows to the correct size
        , ("M-h", sendMessage Shrink)           --Shrink horiz window width
        , ("M-l", sendMessage Expand)           --Expand horiz window width
        , ("M-M1-h", sendMessage MirrorShrink)  --Shrink vert window width
        , ("M-M1-l", sendMessage MirrorExpand)  --Expand vert window width

        --Windows navigation
        , ("M-<Tab>", windows W.focusDown)      --Move focus to the next window
        , ("M-j", windows W.focusDown)          --Move focus to the next window
        , ("M-k", windows W.focusUp)            --Move focus to the previous window
        , ("M-m", windows W.focusMaster)        --Move focus to the master window
        , ("M-S-m", windows W.swapMaster)       --Swap focused window with master window
        , ("M-S-j", windows W.swapDown)         --Swap focused window with next window
        , ("M-S-k", windows W.swapUp)           --Swap focused window with previous window
        , ("M-<Backspace>", promote)            --Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)          --Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)             --Rotate all windows in the current stack

        --Floating windows
        , ("M-S-t", withFocused $ windows . W.sink)  --Push floating window back to tile

        --Inc/dec windows in master pane or stack
        , ("M-,", sendMessage (IncMasterN 1))   --Increment # of windows in master area
        , ("M-.", sendMessage (IncMasterN (-1))) --Decrement # of windows in master area
        ]


        --Workspaces
        ++
        --Change to workspace k
        [("M-" ++ enumFrom k, windows $ W.greedyView f) | (k, f) <- zip ['1' .. '9'] myWorkspaces]
        ++
        --Send window to workspace k
        [("M-S-" ++ enumFrom k, windows $ W.shift f) | (k, f) <- zip ['1' .. '9'] myWorkspaces]
        ++
        --M-{w,e} - Switch to screen 2 or 1
        --M-S-{w,e} - Move window to screen 2 or 1
        [(mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
            | (key, scr) <- zip "we" [1,0]
            , (action, mask) <- [(W.view, ""), (W.shift, "S-")]
        ]
--     -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
--     -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
--     --
--     [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
--         | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
--         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| threeCol ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled       = Tall nmaster delta ratio
    threeCol    = ThreeCol nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--

myStartupHook = do
        spawnOnce "nitrogen --restore &"
        spawnOnce "picom &" --compositor

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc0 <- spawnPipe "xmobar -x 0 /home/poprox/.config/xmobar/xmobarrc" --launch xmobar on monitor one
  -- xmproc1 <- spawnPipe "xmobar -x 1 /home/poprox/.config/xmobar/xmobarrc" --launch xmobar on monitor one
  xmonad $ docks $ ewmh defaults{ handleEventHook = handleEventHook def <+> fullscreenEventHook }
  -- ewmh defaults { ...  } is for opacity with picom

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        -- numlockMask deprecated in 0.9.1
        -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
      -- keys               = myKeys,  --used for old keybinding scheme
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    } `additionalKeysP` myKeys
