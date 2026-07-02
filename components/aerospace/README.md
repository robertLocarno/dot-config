# AeroSpace

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is a window management tool for Mac.

## Setup

```
ln -s ~/src/github.com/robertLocarno/dot-config/components/aerospace/.aerospace.toml .aerospace.toml
```

To install the border, run:
```
brew tap FelixKratz/formulae
brew install borders
```

To disable "Displays have separate Spaces" run:
```
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
```
or in System Settings: `System Settings → Desktop & Dock → Displays have separate Spaces` (Logout is required)

## NOTE

This Aerospace config starts sketchybar, make sure it's installed to get the full benefits of the config.
