# Neovim Colorscheme Blueprint

A general guide for building a multi-variant, user-configurable Neovim colorscheme following the architecture used in rose-pine.

---

## Directory Structure

```
my-theme/
├── colors/
│   ├── my-theme.lua          -- default entry point (auto variant)
│   ├── my-theme-dark.lua     -- explicit variant entry points
│   └── my-theme-light.lua
├── lua/
│   ├── my-theme.lua          -- public API: setup() + colorscheme()
│   └── my-theme/
│       ├── config.lua        -- options schema and defaults
│       ├── palette.lua       -- color definitions per variant
│       ├── utilities.lua     -- blend() and parse_color() helpers
│       └── plugins/          -- optional plugin-specific modules
│           ├── bufferline.lua
│           └── ...
└── lua/lualine/themes/
    └── my-theme.lua          -- lualine integration
```

---

## Layer Architecture

Colors flow through three distinct abstraction layers:

```
hex values  →  palette (named colors)  →  groups (semantic roles)  →  vim highlights
"#191724"      base, text, love, ...      error, border, panel, ...    Normal, Comment, ...
```

This separation lets users override at any layer without touching the rest.

---

## Layer 1 — Palette (`lua/my-theme/palette.lua`)

Define one table per variant. Every variant must have identical keys.

**Background depth** (darkest → lightest for dark themes, reversed for light):
```lua
_nc        -- inactive window background (dim version of base)
base       -- main editor background
surface    -- slightly elevated panels
overlay    -- floating windows, popups
```

**Text depth** (dimmest → brightest):
```lua
muted      -- disabled, invisible hints
subtle     -- comments, punctuation
text       -- main body text
```

**Accent colors** (name by feel, not by hue — hues change per variant):
```lua
love       -- errors, dangerous actions (typically red/pink)
gold       -- warnings, numbers, constants (typically yellow/amber)
rose       -- functions, highlights (typically pink/salmon)
pine       -- keywords, control flow (typically teal/blue-green)
foam       -- types, directories (typically cyan/blue)
iris       -- parameters, special (typically purple/lavender)
leaf       -- success, ok states (typically muted green)
```

**Highlight tiers** (for backgrounds of selected/active items):
```lua
highlight_low   -- very subtle, barely visible
highlight_med   -- selection background
highlight_high  -- strong selection, cursor
```

**Special**:
```lua
none = "NONE"   -- transparent, convenience alias
```

**Variant selection logic**:
```lua
local options = require("my-theme.config").options

local variants = { dark = {...}, light = {...} }

-- Apply per-variant palette overrides from user config
if options.palette and next(options.palette) then
    for variant_name, overrides in pairs(options.palette) do
        if variants[variant_name] then
            variants[variant_name] = vim.tbl_extend("force", variants[variant_name], overrides)
        end
    end
end

if variants[options.variant] then
    return variants[options.variant]
end
return vim.o.background == "light" and variants.light or variants[options.dark_variant or "dark"]
```

---

## Layer 2 — Groups (`lua/my-theme/config.lua`)

Groups map semantic role names to palette color names. Users can override group → palette mappings in their config.

```lua
groups = {
    -- UI structure
    border = "muted",
    link   = "iris",
    panel  = "surface",

    -- Diagnostics
    error = "love",
    warn  = "gold",
    hint  = "iris",
    info  = "foam",
    ok    = "leaf",
    note  = "pine",
    todo  = "rose",

    -- Git status
    git_add       = "foam",
    git_change    = "rose",
    git_delete    = "love",
    git_dirty     = "rose",
    git_ignore    = "muted",
    git_merge     = "iris",
    git_rename    = "pine",
    git_stage     = "iris",
    git_text      = "rose",
    git_untracked = "subtle",

    -- Headings (h1–h6)
    h1 = "iris",
    h2 = "foam",
    h3 = "rose",
    h4 = "gold",
    h5 = "pine",
    h6 = "leaf",
},
```

Groups are resolved at highlight-set time via `utilities.parse_color()`:
```lua
local groups = {}
for name, color in pairs(config.options.groups) do
    groups[name] = utilities.parse_color(color)   -- resolves palette key → hex
end
```

---

## Layer 3 — Highlights (`lua/my-theme.lua`)

Highlights are plain Lua tables. Set them with `vim.api.nvim_set_hl(0, name, table)`.

**Highlight table fields**:
```lua
{
    fg          = "#hex or NONE",
    bg          = "#hex or NONE",
    sp          = "#hex",          -- underline/undercurl color
    bold        = true/false,
    italic      = true/false,
    underline   = true/false,
    undercurl   = true/false,
    underdouble = true/false,
    underdotted = true/false,
    underdashed = true/false,
    strikethrough = true/false,
    nocombine   = true/false,
    reverse     = true/false,
    link        = "OtherGroupName",  -- cannot combine with other attrs
}
```

**Custom `blend` field** (computed before setting, not passed to nvim):
```lua
{
    fg       = palette.love,
    bg       = palette.love,
    blend    = 20,           -- 0–100 percent
    blend_on = palette.base, -- optional: what to blend against (defaults to base)
}
```

**Three highlight sections**:

1. `legacy_highlights` — old treesitter capture names (`@text`, `@method`, etc.) and old plugin groups. Guarded by `config.options.enable.legacy_highlights`.
2. `default_highlights` — all current groups. Always applied.
3. `transparency_highlights` — overrides that set `bg = "NONE"`. Applied only when `config.options.styles.transparency` is true.

**User override resolution** (after all three sections are merged):
```lua
for group, highlight in pairs(config.options.highlight_groups) do
    local existing = highlights[group] or {}
    -- follow links: "link" cannot mix with attributes
    while existing.link do
        existing = highlights[existing.link] or {}
    end
    local parsed = vim.tbl_extend("force", {}, highlight)
    -- resolve palette color names in user-provided values
    if highlight.fg then parsed.fg = utilities.parse_color(highlight.fg) or highlight.fg end
    if highlight.bg then parsed.bg = utilities.parse_color(highlight.bg) or highlight.bg end
    if highlight.sp then parsed.sp = utilities.parse_color(highlight.sp) or highlight.sp end
    if highlight.inherit == nil or highlight.inherit then
        parsed.inherit = nil
        highlights[group] = vim.tbl_extend("force", existing, parsed)
    else
        parsed.inherit = nil
        highlights[group] = parsed
    end
end
```

**Final pass** — resolve blend, call before_highlight hook, apply:
```lua
for group, highlight in pairs(highlights) do
    if config.options.before_highlight then
        config.options.before_highlight(group, highlight, palette)
    end
    if highlight.blend and highlight.bg and highlight.bg ~= "NONE" then
        highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or palette.base, highlight.blend / 100)
    end
    highlight.blend = nil
    highlight.blend_on = nil
    vim.api.nvim_set_hl(0, group, highlight)
end
```

---

## Essential Highlight Groups Checklist

### Vim built-ins (must cover these)
```
Normal, NormalFloat, NormalNC
Cursor, CursorLine, CursorColumn, CursorLineNr
LineNr, SignColumn, FoldColumn, Folded
StatusLine, StatusLineNC, WinBar, WinBarNC, WinSeparator, VertSplit
TabLine, TabLineFill, TabLineSel
Pmenu, PmenuSel, PmenuSbar, PmenuThumb, PmenuKind, PmenuKindSel, PmenuExtra, PmenuExtraSel
Visual, Search, IncSearch, CurSearch, Substitute
DiffAdd, DiffChange, DiffDelete, DiffText
ColorColumn, Conceal, Directory, EndOfBuffer, ErrorMsg, FloatBorder, FloatTitle
MatchParen, ModeMsg, MoreMsg, NonText, Question, QuickFixLine
SpecialKey, SpellBad, SpellCap, SpellLocal, SpellRare
Title, WarningMsg, WildMenu
```

### Syntax (classic groups)
```
Boolean, Character, Comment, Conditional, Constant, Debug, Define, Delimiter
Error, Exception, Float, Function, Identifier, Include, Keyword, Label
Macro, Number, Operator, PreCondit, PreProc, Repeat
Special, SpecialChar, SpecialComment, Statement, StorageClass
String, Structure, Tag, Todo, Type, TypeDef, Underlined
Added, Changed, Removed
```

### Diagnostics
```
DiagnosticError/Hint/Info/Ok/Warn
DiagnosticFloating*, DiagnosticSign*, DiagnosticDefault*, DiagnosticUnderline*, DiagnosticVirtualText*
```

### Treesitter (current capture names)
See `:help treesitter-highlight-groups`. Key ones:
```
@variable, @variable.builtin, @variable.member, @variable.parameter
@constant, @constant.builtin
@string, @string.regexp, @string.escape, @string.special.url
@type, @type.builtin
@function, @function.builtin, @function.method, @function.method.call
@keyword, @keyword.import, @keyword.return, @keyword.conditional, @keyword.repeat
@constructor, @operator, @attribute, @property, @label, @module
@punctuation.delimiter, @punctuation.bracket, @punctuation.special
@comment, @comment.error, @comment.warning, @comment.todo, @comment.note
@markup.strong, @markup.italic, @markup.heading, @markup.link.url, @markup.list
@tag, @tag.attribute, @tag.delimiter
@diff.plus, @diff.minus, @diff.delta
```

### LSP semantic tokens
```
@lsp.type.comment, @lsp.type.keyword, @lsp.type.variable, @lsp.type.parameter
@lsp.type.property, @lsp.type.enum, @lsp.type.interface, @lsp.type.namespace
@lsp.typemod.variable.constant, @lsp.typemod.variable.defaultLibrary
@lsp.typemod.function.defaultLibrary, @lsp.typemod.variable.injected
```

---

## Utilities (`lua/my-theme/utilities.lua`)

**`parse_color(color)`** — resolves a palette key name or hex string to a hex value:
```lua
local color_cache = {}
function utilities.parse_color(color)
    if color_cache[color] then return color_cache[color] end
    if color == nil then return nil end
    color = color:lower()
    if not color:find("#") and color ~= "none" then
        color = require("my-theme.palette")[color] or vim.api.nvim_get_color_by_name(color)
    end
    color_cache[color] = color
    return color
end
```

**`blend(fg, bg, alpha)`** — linear RGB mix, returns `"#RRGGBB"`:
```lua
local blend_cache = {}
function utilities.blend(fg, bg, alpha)
    local key = fg .. bg .. alpha
    if blend_cache[key] then return blend_cache[key] end
    -- convert hex to {r,g,b} using bit.band/rshift via nvim_get_color_by_name
    -- blend each channel: floor(alpha * fg_ch + (1-alpha) * bg_ch + 0.5)
    -- format result as "#%02X%02X%02X"
    blend_cache[key] = result
    return result
end
```

---

## Config (`lua/my-theme/config.lua`)

```lua
config.options = {
    variant      = "auto",    -- "auto" | variant names
    dark_variant = "dark",    -- which variant to use when auto + dark background

    dim_inactive_windows             = false,
    extend_background_behind_borders = true,

    enable = {
        legacy_highlights = true,   -- old treesitter/plugin groups
        migrations        = true,   -- handle deprecated option keys
        terminal          = true,   -- set vim.g.terminal_color_*
    },

    styles = {
        bold         = true,
        italic       = true,
        transparency = false,
    },

    palette         = {},   -- { variant_name = { color_key = "#hex" } }
    groups          = {},   -- semantic role overrides: { error = "love" }
    highlight_groups = {},  -- direct highlight overrides: { Normal = { bg = "base" } }

    before_highlight = function(group, highlight, palette) end,
}

function config.extend_options(options)
    config.options = vim.tbl_deep_extend("force", config.options, options or {})
    if config.options.enable.migrations then
        config.options = migrate(config.options)
    end
end
```

The `migrate()` function maps deprecated option keys to their current equivalents, preserving backwards compatibility.

---

## Public API (`lua/my-theme.lua`)

```lua
local M = {}

-- Called by the user in their config: require("my-theme").setup({ ... })
function M.setup(options)
    require("my-theme.config").extend_options(options or {})
end

-- Called by colors/ entry points
function M.colorscheme(variant)
    local config = require("my-theme.config")
    config.extend_options({ variant = variant })

    vim.opt.termguicolors = true
    if vim.g.colors_name then
        vim.cmd("hi clear")
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "my-theme"

    if variant == "light" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end

    set_highlights()
end

return M
```

---

## Entry Points (`colors/`)

Each file flushes the palette cache (so the correct variant is loaded) then calls `colorscheme()`:

```lua
-- colors/my-theme.lua  (auto — follows vim background)
package.loaded["my-theme.palette"] = nil
require("my-theme").colorscheme()

-- colors/my-theme-dark.lua
package.loaded["my-theme.palette"] = nil
require("my-theme").colorscheme("dark")

-- colors/my-theme-light.lua
package.loaded["my-theme.palette"] = nil
require("my-theme").colorscheme("light")
```

The `package.loaded` reset is critical: `palette.lua` reads `config.options.variant` at module load time, so it must be re-evaluated each time a variant is selected.

---

## Terminal Colors

Set inside `set_highlights()`, guarded by `config.options.enable.terminal`:

```lua
vim.g.terminal_color_0  = palette.overlay   -- black
vim.g.terminal_color_8  = palette.subtle    -- bright black
vim.g.terminal_color_1  = palette.love      -- red
vim.g.terminal_color_9  = palette.love      -- bright red
vim.g.terminal_color_2  = palette.pine      -- green
vim.g.terminal_color_10 = palette.pine      -- bright green
vim.g.terminal_color_3  = palette.gold      -- yellow
vim.g.terminal_color_11 = palette.gold      -- bright yellow
vim.g.terminal_color_4  = palette.foam      -- blue
vim.g.terminal_color_12 = palette.foam      -- bright blue
vim.g.terminal_color_5  = palette.iris      -- magenta
vim.g.terminal_color_13 = palette.iris      -- bright magenta
vim.g.terminal_color_6  = palette.rose      -- cyan
vim.g.terminal_color_14 = palette.rose      -- bright cyan
vim.g.terminal_color_7  = palette.text      -- white
vim.g.terminal_color_15 = palette.text      -- bright white

-- Autocommand wires StatusLineTerm for terminal buffers
vim.cmd([[
augroup my-theme
    autocmd!
    autocmd TermOpen * if &buftype=='terminal'
        \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
        \|else|setlocal winhighlight=|endif
    autocmd ColorSchemePre * autocmd! my-theme
augroup END
]])
```

---

## Plugin Integrations

### Lualine (`lua/lualine/themes/my-theme.lua`)

```lua
local p = require("my-theme.palette")
local c = require("my-theme.config")
local bg = c.options.styles.transparency and "NONE" or p.surface

return {
    normal  = { a = { bg = p.rose,  fg = p.base, gui = "bold" }, b = { bg = p.overlay, fg = p.rose  }, c = { bg = bg, fg = p.text } },
    insert  = { a = { bg = p.foam,  fg = p.base, gui = "bold" }, b = { bg = p.overlay, fg = p.foam  }, c = { bg = bg, fg = p.text } },
    visual  = { a = { bg = p.iris,  fg = p.base, gui = "bold" }, b = { bg = p.overlay, fg = p.iris  }, c = { bg = bg, fg = p.text } },
    replace = { a = { bg = p.pine,  fg = p.base, gui = "bold" }, b = { bg = p.overlay, fg = p.pine  }, c = { bg = bg, fg = p.text } },
    command = { a = { bg = p.love,  fg = p.base, gui = "bold" }, b = { bg = p.overlay, fg = p.love  }, c = { bg = bg, fg = p.text } },
    inactive = { a = { bg = bg, fg = p.muted, gui = "bold" }, b = { bg = bg, fg = p.muted }, c = { bg = bg, fg = p.muted } },
}
```

### Plugin-specific modules (`lua/my-theme/plugins/`)

Return a table of highlight specs that the user passes to the plugin's `setup()`:

```lua
-- lua/my-theme/plugins/bufferline.lua
local p = require("my-theme.palette")
return {
    buffer_selected = { fg = p.text,   bg = p.surface, bold = true, italic = true },
    buffer_visible  = { fg = p.subtle, bg = p.base },
    tab_selected    = { fg = p.text,   bg = p.overlay },
    -- ...
}
```

---

## Blend Pattern

The `blend` field creates tinted backgrounds without OS-level transparency:

```lua
-- Visual selection: iris with 15% opacity over base
Visual = { bg = palette.iris, blend = 15 }

-- Diagnostic virtual text: red text on faint red background
DiagnosticVirtualTextError = { fg = groups.error, bg = groups.error, blend = 10 }

-- Diff add: green on faint green
DiffAdd = { bg = groups.git_add, blend = 20 }
```

`blend = 0` → pure `blend_on` (usually base), `blend = 100` → pure `bg` color.

---

## make_border Helper

A common pattern for float borders that can optionally extend into the background:

```lua
local function make_border(fg)
    fg = fg or groups.border
    return {
        fg = fg,
        bg = (config.options.extend_background_behind_borders and not styles.transparency)
             and palette.surface or "NONE",
    }
end

-- Usage
FloatBorder       = make_border()
TelescopeBorder   = make_border()
LspSagaRenameBorder = make_border(palette.pine)
```

---

## Key Design Principles

1. **Three-layer separation**: hex → named palette → semantic group → highlight. Never hardcode hex in highlights.
2. **Styles flags control decoration**: `styles.bold/italic` gate all bold/italic in highlights, giving the user a single toggle.
3. **Transparency is an override layer**: keep opaque defaults; a separate table overrides `bg` to `"NONE"` when transparency is on.
4. **Blend instead of alpha**: compute blended hex colors at runtime so the theme works on any terminal without compositor support.
5. **Cache aggressively**: `parse_color` and `blend` both use module-level caches; the palette cache is busted between variant switches via `package.loaded`.
6. **User overrides at every layer**: `palette` (per-variant hex), `groups` (semantic remapping), `highlight_groups` (raw override), `before_highlight` (imperative hook).
7. **Variants ≠ colorschemes**: multiple variants share one `colors_name`; only dawn sets `background = light`. The auto mode follows `vim.o.background`.
8. **Legacy support**: keep old highlight names under a flag (`enable.legacy_highlights`) and map deprecated options in a `migrate()` function.

