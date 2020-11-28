import XMonad



main = xmonad default
        {
          terminal      = myTerminal
          borderWidth   = myBorderWidth
          modMask       = myModMask
        }


myTerminal = "kitty"
myAppLauncher = "rofi"
myModMask = mod4Mask  --sets the mod key to windows instead of alt
myBorderWidth = 3
