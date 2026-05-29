# salmon.nvim

A warm Neovim colorscheme built around the color of salmon. Neutral dark backgrounds keep the palette out of the way while salmon (#FF885D) carries functions, UI accents, and search highlights. Variables and properties render in italic — pair with a cursive italic font for the full effect.

<img width="2718" height="2122" alt="2026-05-29T12:44:27,475151004-04:00" src="https://github.com/user-attachments/assets/5816a3e7-3030-4bbe-8380-25f868211eba" />

## Variants

| Command | Description |
|---|---|
| `colorscheme salmon` | Auto — follows `vim.o.background` |
| `colorscheme salmon-dark` | Always dark |
| `colorscheme salmon-light` | Always light |

## Requirements

- Neovim 0.9+
- `termguicolors` enabled (the plugin sets this automatically)
- A font with a cursive italic variant for the best experience (see [Recommended Fonts](#recommended-fonts))

## Installation

### lazy.nvim

```lua
{
    "pebra/salmon.nvim",
    priority = 1000,
    config = function()
        require("salmon").setup({})
        vim.cmd("colorscheme salmon")
    end,
}
```

## Configuration

Call `setup()` before applying the colorscheme. All options are optional — the defaults are shown below.

```lua
require("salmon").setup({
    -- "auto" follows vim.o.background; or set "dark" / "light" explicitly
    variant      = "auto",
    dark_variant = "dark",   -- which variant "auto" uses on a dark background

    dim_inactive_windows             = false,
    extend_background_behind_borders = true,  -- float bg bleeds behind borders

    enable = {
        legacy_highlights = true,   -- old treesitter group names (@text, @method, …)
        migrations        = true,   -- handle deprecated option keys automatically
        terminal          = true,   -- set vim.g.terminal_color_* for :terminal
    },

    styles = {
        bold         = true,   -- bold on headings, mode pills, jump labels
        italic       = true,   -- italic on variables, properties, comments
        transparency = false,  -- set bg = NONE on Normal, Float, StatusLine, …
    },

    -- Override specific hex values per variant
    palette = {
        dark  = { salmon = "#FF7A4D" },
        light = { salmon = "#D94F00" },
    },

    -- Remap semantic roles to different palette color names
    groups = {
        error = "love",   -- default
        warn  = "gold",
        todo  = "salmon",
        -- …
    },

    -- Raw highlight overrides — palette color names are resolved automatically
    highlight_groups = {
        Normal    = { bg = "base" },
        Comment   = { italic = false },
        Function  = { fg = "#FF6644" },
    },

    -- Called once per highlight group just before nvim_set_hl, useful for
    -- last-minute adjustments
    before_highlight = function(group, highlight, palette)
    end,
})
```

## Palette

These are the named colors you can reference in `palette`, `groups`, and `highlight_groups`.

### Dark

| Name | Hex | Role |
|---|---|---|
| `salmon` | `#FF885D` | Salmon — functions, accents, search |
| `gold` | `#FFC5B1` | Peach — strings, numbers, warnings |
| `dill` | `#00AC49` | Green — keywords, control flow |
| `foam` | `#A591FF` | Purple — types, properties, directories |
| `iris` | `#CAC2FF` | Lavender — parameters, attributes |
| `love` | `#E65100` | Orange-red — errors |
| `leaf` | `#5DFF88` | Green — success, ok states |
| `base` | `#191B1C` | Main background |
| `surface` | `#292B2D` | Panels, sidebars |
| `overlay` | `#383B3D` | Floating windows, popups |
| `text` | `#EDEFF0` | Main body text |
| `subtle` | `#9BA3A8` | Comments, punctuation |
| `muted` | `#7B8285` | Disabled, decorative |

### Light (work in progress)

| Name | Hex | Role |
|---|---|---|
| `salmon` | `#E65100` | Salmon (shifted darker for legibility) |
| `gold` | `#7C2800` | Dark amber — warnings, numbers |
| `dill` | `#005D24` | Forest green — keywords |
| `foam` | `#6C00ED` | Deep purple — types |
| `iris` | `#45009D` | Dark indigo — parameters |
| `love` | `#B23D00` | Orange-red — errors |
| `leaf` | `#008537` | Medium green — success |
| `base` | `#EDEFF0` | Main background |
| `surface` | `#C2C9CC` | Panels |
| `overlay` | `#9BA3A8` | Floating windows |
| `text` | `#191B1C` | Main body text |

## Recommended Fonts

The italic style on variables and properties (`@variable`, `@property`, `@variable.parameter`) only shows its cursive character when the font's italic variant uses cursive glyphs.

| Font | Notes |
|---|---|
| [Victor Mono](https://rubjo.github.io/victor-mono/) | Free, distinctly cursive italic |
| [Operator Mono](https://www.typography.com/fonts/operator/styles) | Commercial, the original cursive coding font |
| [Recursive Mono](https://www.recursive.design/) | Free, variable font with cursive axis |
| [Cascadia Code](https://github.com/microsoft/cascadia-code) | Free, subtle cursive italic |
| [JetBrains Mono](https://www.jetbrains.com/legalnotices/jb_mono/) | Free, mild italic curves |

## Plugin Integrations

The following plugins are styled out of the box — no extra configuration needed.

- **Telescope**
- **nvim-tree** and **neo-tree**
- **GitSigns**
- **Which-key**
- **indent-blankline** (v3)
- **nvim-cmp**
- **Noice**
- **Flash** and **Leap**
- **Mini** (statusline, cursorword, indentscope, pick)
- **Trouble**
- **Dashboard / Alpha**
- **Fidget**
- **LSP** (references, inlay hints, signature help)

### Lualine

```lua
require("lualine").setup({
    options = { theme = "salmon" },
})
```

## Overriding Highlights

### Quick one-off override

```lua
require("salmon").setup({
    highlight_groups = {
        -- disable italic on comments
        Comment = { italic = false },
        -- make strings use a richer salmon instead of peach
        String = { fg = "salmon" },
        -- raw hex also works
        Normal = { bg = "#151515" },
    },
})
```

### Swap a semantic role

```lua
require("salmon").setup({
    groups = {
        -- make errors show in the same color as warnings
        error = "gold",
    },
})
```

### Tweak a single palette color without changing anything else

```lua
require("salmon").setup({
    palette = {
        dark = { salmon = "#FF6644" },
    },
})
```

### Before-highlight hook

For programmatic adjustments — runs once per group just before `nvim_set_hl`:

```lua
require("salmon").setup({
    before_highlight = function(group, highlight, palette)
        -- strip italic from every group
        if highlight.italic then
            highlight.italic = false
        end
    end,
})
```

## Transparency

```lua
require("salmon").setup({
    styles = { transparency = true },
})
```

Sets `bg = NONE` on `Normal`, `NormalFloat`, `StatusLine`, `WinBar`, `TabLine`, and their variants so the terminal/compositor background shows through.
