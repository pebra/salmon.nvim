local config = require("salmon.config")

-- Dark: neutral gray backgrounds, salmon accents.
-- Highlight tiers are salmon-tinted blends over base.
-- Light: reversed depth, accents shifted darker for legibility on light bg.
local variants = {
    dark = {
        _nc            = "#14161h",   -- dimmed inactive window bg
        base           = "#191B1C",   -- main editor background
        surface        = "#292B2D",   -- elevated panels
        overlay        = "#383B3D",   -- floating windows / popups
        muted          = "#4D5456",   -- disabled text, faint chrome
        subtle         = "#697377",   -- comments, punctuation
        text           = "#EDEFF0",   -- main body text
        love           = "#E65100",   -- errors  (deep orange)
        gold           = "#FFC5B1",   -- warnings / numbers  (peach)
        salmon         = "#FF885D",   -- THE salmon — functions, accents
        dill           = "#a1b885",   -- keywords  (mid green)
        foam           = "#A591FF",   -- types / dirs  (mid purple)
        iris           = "#CAC2FF",   -- params / special  (light lavender)
        leaf           = "#5DFF88",   -- success / ok  (bright green)
        highlight_low  = "#24201F",   -- 5 % salmon over base
        highlight_med  = "#3B2B25",   -- 15 % salmon over base
        highlight_high = "#52362C",   -- 25 % salmon over base
        none           = "NONE",
    },
    light = {
        _nc            = "#F5F0EE",   -- slightly warm inactive bg
        base           = "#EDEFF0",   -- main editor background
        surface        = "#C2C9CC",   -- elevated panels
        overlay        = "#9BA3A8",   -- floating windows / popups
        muted          = "#595F61",   -- disabled text
        subtle         = "#7B8285",   -- comments, punctuation
        text           = "#191B1C",   -- main body text
        love           = "#B23D00",   -- errors  (rich orange-red)
        gold           = "#7C2800",   -- warnings / numbers  (dark amber)
        salmon           = "#E65100",   -- THE salmon — shifted darker for light bg
        dill           = "#005D24",   -- keywords  (dark forest green)
        foam           = "#6C00ED",   -- types  (deep purple)
        iris           = "#45009D",   -- params / special  (dark indigo)
        leaf           = "#008537",   -- success / ok  (medium green)
        highlight_low  = "#EDE9E8",   -- 5 % salmon over light base
        highlight_med  = "#EFDFD9",   -- 15 % salmon over light base
        highlight_high = "#F1D5CB",   -- 25 % salmon over light base
        none           = "NONE",
    },
    red_nori = {
        _nc            = "#141617",   -- dimmed inactive window bg
        base           = "#3B1115",   -- main editor background
        surface        = "#292B2D",   -- elevated panels
        overlay        = "#383B3D",   -- floating windows / popups
        muted          = "#7B8285",   -- disabled text, faint chrome
        subtle         = "#9BA3A8",   -- comments, punctuation
        text           = "#EDEFF0",   -- main body text
        love           = "#E65100",   -- errors  (deep orange)
        gold           = "#FFC5B1",   -- warnings / numbers  (peach)
        salmon           = "#FF885D",   -- THE salmon — functions, accents
        dill           = "#00AC49",   -- keywords  (mid green)
        foam           = "#A591FF",   -- types / dirs  (mid purple)
        iris           = "#CAC2FF",   -- params / special  (light lavender)
        leaf           = "#5DFF88",   -- success / ok  (bright green)
        highlight_low  = "#24201F",   -- 5 % salmon over base
        highlight_med  = "#3B2B25",   -- 15 % salmon over base
        highlight_high = "#52362C",   -- 25 % salmon over base
        none           = "NONE",
    },
}

if config.options.palette and next(config.options.palette) then
    for variant_name, overrides in pairs(config.options.palette) do
        if variants[variant_name] then
            variants[variant_name] = vim.tbl_extend("force", variants[variant_name], overrides)
        end
    end
end

local options = config.options
if variants[options.variant] then
    return variants[options.variant]
end
return vim.o.background == "light" and variants.light or variants[options.dark_variant or "dark"]
