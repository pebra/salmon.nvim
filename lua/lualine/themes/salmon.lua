local p = require("salmon.palette")
local c = require("salmon.config")
local bg = c.options.styles.transparency and "NONE" or p.surface

return {
    normal = {
        a = { fg = p.base,   bg = p.salmon,    gui = "bold" },
        b = { fg = p.salmon,   bg = p.overlay },
        c = { fg = p.subtle, bg = bg },
    },
    insert = {
        a = { fg = p.base,   bg = p.foam,    gui = "bold" },
        b = { fg = p.foam,   bg = p.overlay },
        c = { fg = p.subtle, bg = bg },
    },
    visual = {
        a = { fg = p.base,   bg = p.iris,    gui = "bold" },
        b = { fg = p.iris,   bg = p.overlay },
        c = { fg = p.subtle, bg = bg },
    },
    replace = {
        a = { fg = p.base,   bg = p.dill,    gui = "bold" },
        b = { fg = p.dill,   bg = p.overlay },
        c = { fg = p.subtle, bg = bg },
    },
    command = {
        a = { fg = p.base,   bg = p.love,    gui = "bold" },
        b = { fg = p.love,   bg = p.overlay },
        c = { fg = p.subtle, bg = bg },
    },
    inactive = {
        a = { fg = p.muted,  bg = bg, gui = "bold" },
        b = { fg = p.muted,  bg = bg },
        c = { fg = p.muted,  bg = bg },
    },
}
