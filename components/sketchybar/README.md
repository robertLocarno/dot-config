# SketchyBar

Config for [sketchybar](https://felixkratz.github.io/SketchyBar/setup)

# Install

```bash
brew tap FelixKratz/formulae
brew install sketchybar
```

# Setup

```
ln -s ~/src/github.com/robertLocarno/dot-config/components/sketchybar ~/.config/sketchybar
```

When you create additional plugins, make sure they're made executable via:
```
chmod +x name/of/plugin.sh
```

If this is set up with my aerospace toml, then that's responsible for actually launching sketchybar.

# NOTE

This config uses Aerospace to start and stop sketchybar.
