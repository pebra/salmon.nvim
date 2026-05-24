local M = {}

local function set_highlights()
    local config     = require("salmon.config")
    local palette    = require("salmon.palette")
    local utilities  = require("salmon.utilities")
    local styles     = config.options.styles

    local groups = {}
    for name, color in pairs(config.options.groups) do
        groups[name] = utilities.parse_color(color)
    end

    local function make_border(fg)
        fg = fg or groups.border
        return {
            fg = fg,
            bg = (config.options.extend_background_behind_borders and not styles.transparency)
                 and palette.surface or "NONE",
        }
    end

    local highlights = {}

    -- ── default highlights ────────────────────────────────────────────────────

    local default_highlights = {
        -- editor chrome
        ColorColumn      = { bg = palette.highlight_low },
        Conceal          = { fg = palette.muted },
        CurSearch        = { fg = palette.base, bg = palette.salmon },
        Cursor           = { fg = palette.text, bg = palette.salmon },
        CursorColumn     = { bg = palette.highlight_low },
        CursorIM         = { link = "Cursor" },
        CursorLine       = { bg = palette.highlight_low },
        CursorLineNr     = { fg = palette.salmon },
        DiffAdd          = { bg = groups.git_add,    blend = 20 },
        DiffChange       = { bg = groups.git_change, blend = 20 },
        DiffDelete       = { bg = groups.git_delete, blend = 20 },
        DiffText         = { bg = groups.git_change, blend = 40 },
        Directory        = { fg = palette.foam },
        EndOfBuffer      = { fg = palette.highlight_low },
        ErrorMsg         = { fg = groups.error },
        FloatBorder      = make_border(),
        FloatTitle       = {
            fg = palette.salmon,
            bg = (config.options.extend_background_behind_borders and not styles.transparency)
                 and palette.surface or "NONE",
        },
        FoldColumn       = { fg = palette.muted },
        Folded           = { fg = palette.text, bg = palette.surface },
        IncSearch        = { fg = palette.base, bg = palette.gold },
        LineNr           = { fg = palette.muted },
        MatchParen       = { fg = palette.salmon },
        ModeMsg          = { fg = palette.subtle },
        MoreMsg          = { fg = palette.salmon },
        NonText          = { fg = palette.muted },
        Normal           = { fg = palette.text, bg = palette.base },
        NormalFloat      = { fg = palette.text, bg = palette.surface },
        NormalNC         = {
            fg = palette.text,
            bg = config.options.dim_inactive_windows and palette._nc or palette.base,
        },
        Pmenu            = { fg = palette.subtle,  bg = palette.surface },
        PmenuExtra       = { fg = palette.muted,   bg = palette.surface },
        PmenuExtraSel    = { fg = palette.subtle,  bg = palette.overlay },
        PmenuKind        = { fg = palette.foam,    bg = palette.surface },
        PmenuKindSel     = { fg = palette.foam,    bg = palette.overlay },
        PmenuSbar        = { bg = palette.overlay },
        PmenuSel         = { fg = palette.text,    bg = palette.overlay },
        PmenuThumb       = { bg = palette.salmon },
        Question         = { fg = palette.gold },
        QuickFixLine     = { fg = palette.salmon, italic = styles.italic },
        Search           = { fg = palette.base, bg = palette.salmon },
        SignColumn       = { fg = palette.text, bg = palette.base },
        SpecialKey       = { fg = palette.iris },
        SpellBad         = { sp = groups.error,  undercurl = true },
        SpellCap         = { sp = palette.iris,  undercurl = true },
        SpellLocal       = { sp = palette.foam,  undercurl = true },
        SpellRare        = { sp = palette.leaf,  undercurl = true },
        StatusLine       = { fg = palette.subtle, bg = palette.surface },
        StatusLineNC     = { fg = palette.muted,  bg = palette.surface },
        Substitute       = { fg = palette.base,  bg = palette.salmon },
        TabLine          = { fg = palette.subtle, bg = palette.surface },
        TabLineFill      = { fg = palette.subtle, bg = palette.overlay },
        TabLineSel       = { fg = palette.text,   bg = palette.base, bold = styles.bold },
        Title            = { fg = palette.salmon,  bold = styles.bold },
        VertSplit        = { link = "WinSeparator" },
        Visual           = { bg = palette.salmon,  blend = 20 },
        WarningMsg       = { fg = groups.warn },
        WildMenu         = { fg = palette.base,  bg = palette.salmon },
        WinBar           = { fg = palette.subtle, bg = palette.base },
        WinBarNC         = { fg = palette.muted,  bg = palette.base },
        WinSeparator     = { fg = palette.highlight_high },

        -- classic syntax groups
        Boolean          = { fg = palette.gold },
        Character        = { fg = palette.gold },
        Comment          = { fg = palette.subtle, italic = styles.italic },
        Conditional      = { fg = palette.dill },
        Constant         = { fg = palette.gold },
        Debug            = { fg = palette.salmon },
        Define           = { fg = palette.dill },
        Delimiter        = { fg = palette.subtle },
        Error            = { fg = groups.error },
        Exception        = { fg = palette.love },
        Float            = { fg = palette.gold },
        Function         = { fg = palette.salmon },
        Identifier       = { fg = palette.text },
        Include          = { fg = palette.dill },
        Keyword          = { fg = palette.dill },
        Label            = { fg = palette.foam },
        Macro            = { fg = palette.iris },
        Number           = { fg = palette.gold },
        Operator         = { fg = palette.subtle },
        PreCondit        = { fg = palette.dill },
        PreProc          = { fg = palette.dill },
        Repeat           = { fg = palette.dill },
        Special          = { fg = palette.iris },
        SpecialChar      = { fg = palette.iris },
        SpecialComment   = { fg = palette.subtle, italic = styles.italic },
        Statement        = { fg = palette.dill },
        StorageClass     = { fg = palette.foam },
        String           = { fg = palette.gold },
        Structure        = { fg = palette.foam },
        Tag              = { fg = palette.salmon },
        Todo             = { fg = palette.base, bg = groups.todo },
        Type             = { fg = palette.foam },
        TypeDef          = { fg = palette.foam },
        Underlined       = { fg = palette.iris, underline = true },

        -- diff
        Added            = { fg = groups.git_add },
        Changed          = { fg = groups.git_change },
        Removed          = { fg = groups.git_delete },

        -- diagnostics
        DiagnosticError                = { fg = groups.error },
        DiagnosticWarn                 = { fg = groups.warn },
        DiagnosticInfo                 = { fg = groups.info },
        DiagnosticHint                 = { fg = groups.hint },
        DiagnosticOk                   = { fg = groups.ok },
        DiagnosticDefaultError         = { link = "DiagnosticError" },
        DiagnosticDefaultWarn          = { link = "DiagnosticWarn" },
        DiagnosticDefaultInfo          = { link = "DiagnosticInfo" },
        DiagnosticDefaultHint          = { link = "DiagnosticHint" },
        DiagnosticDefaultOk            = { link = "DiagnosticOk" },
        DiagnosticFloatingError        = { fg = groups.error, bg = palette.surface },
        DiagnosticFloatingWarn         = { fg = groups.warn,  bg = palette.surface },
        DiagnosticFloatingInfo         = { fg = groups.info,  bg = palette.surface },
        DiagnosticFloatingHint         = { fg = groups.hint,  bg = palette.surface },
        DiagnosticFloatingOk           = { fg = groups.ok,   bg = palette.surface },
        DiagnosticSignError            = { fg = groups.error },
        DiagnosticSignWarn             = { fg = groups.warn },
        DiagnosticSignInfo             = { fg = groups.info },
        DiagnosticSignHint             = { fg = groups.hint },
        DiagnosticSignOk               = { fg = groups.ok },
        DiagnosticUnderlineError       = { sp = groups.error, undercurl = true },
        DiagnosticUnderlineWarn        = { sp = groups.warn,  undercurl = true },
        DiagnosticUnderlineInfo        = { sp = groups.info,  undercurl = true },
        DiagnosticUnderlineHint        = { sp = groups.hint,  undercurl = true },
        DiagnosticUnderlineOk          = { sp = groups.ok,   undercurl = true },
        DiagnosticVirtualTextError     = { fg = groups.error, bg = groups.error, blend = 10 },
        DiagnosticVirtualTextWarn      = { fg = groups.warn,  bg = groups.warn,  blend = 10 },
        DiagnosticVirtualTextInfo      = { fg = groups.info,  bg = groups.info,  blend = 10 },
        DiagnosticVirtualTextHint      = { fg = groups.hint,  bg = groups.hint,  blend = 10 },
        DiagnosticVirtualTextOk        = { fg = groups.ok,   bg = groups.ok,    blend = 10 },

        -- treesitter current capture names
        ["@variable"]                        = { fg = palette.text, italic = styles.italic },
        ["@variable.builtin"]               = { fg = palette.iris, italic = styles.italic },
        ["@variable.member"]                = { fg = palette.foam },
        ["@variable.parameter"]             = { fg = palette.iris, italic = styles.italic },
        ["@variable.parameter.builtin"]     = { fg = palette.iris, italic = styles.italic },
        ["@constant"]                  = { fg = palette.gold },
        ["@constant.builtin"]          = { fg = palette.gold },
        ["@string"]                    = { fg = palette.gold },
        ["@string.regexp"]             = { fg = palette.dill },
        ["@string.escape"]             = { fg = palette.iris },
        ["@string.special.url"]        = { fg = palette.foam, underline = true },
        ["@type"]                      = { fg = palette.foam },
        ["@type.builtin"]              = { fg = palette.foam },
        ["@function"]                  = { fg = palette.salmon },
        ["@function.builtin"]          = { fg = palette.salmon },
        ["@function.method"]           = { fg = palette.salmon },
        ["@function.method.call"]      = { fg = palette.salmon },
        ["@constructor"]               = { fg = palette.foam },
        ["@keyword"]                   = { fg = palette.dill },
        ["@keyword.import"]            = { fg = palette.dill, italic = styles.italic },
        ["@keyword.return"]            = { fg = palette.love },
        ["@keyword.conditional"]       = { fg = palette.dill },
        ["@keyword.repeat"]            = { fg = palette.dill },
        ["@operator"]                  = { fg = palette.subtle },
        ["@attribute"]                 = { fg = palette.iris },
        ["@property"]                  = { fg = palette.foam, italic = styles.italic },
        ["@label"]                     = { fg = palette.foam },
        ["@module"]                    = { fg = palette.text },
        ["@punctuation.delimiter"]     = { fg = palette.subtle },
        ["@punctuation.bracket"]       = { fg = palette.subtle },
        ["@punctuation.special"]       = { fg = palette.iris },
        ["@comment"]                   = { fg = palette.subtle, italic = styles.italic },
        ["@comment.error"]             = { fg = groups.error },
        ["@comment.warning"]           = { fg = groups.warn },
        ["@comment.todo"]              = { fg = groups.todo },
        ["@comment.note"]              = { fg = groups.note },
        ["@markup.strong"]             = { bold = styles.bold },
        ["@markup.italic"]             = { italic = styles.italic },
        ["@markup.heading"]            = { fg = palette.salmon, bold = styles.bold },
        ["@markup.heading.1"]          = { fg = groups.h1, bold = styles.bold },
        ["@markup.heading.2"]          = { fg = groups.h2, bold = styles.bold },
        ["@markup.heading.3"]          = { fg = groups.h3, bold = styles.bold },
        ["@markup.heading.4"]          = { fg = groups.h4, bold = styles.bold },
        ["@markup.heading.5"]          = { fg = groups.h5, bold = styles.bold },
        ["@markup.heading.6"]          = { fg = groups.h6, bold = styles.bold },
        ["@markup.link.url"]           = { fg = palette.foam, underline = true },
        ["@markup.list"]               = { fg = palette.salmon },
        ["@tag"]                       = { fg = palette.salmon },
        ["@tag.attribute"]             = { fg = palette.iris },
        ["@tag.delimiter"]             = { fg = palette.subtle },
        ["@diff.plus"]                 = { fg = groups.git_add },
        ["@diff.minus"]                = { fg = groups.git_delete },
        ["@diff.delta"]                = { fg = groups.git_change },

        -- lsp semantic tokens
        ["@lsp.type.comment"]                    = { link = "@comment" },
        ["@lsp.type.keyword"]                    = { link = "@keyword" },
        ["@lsp.type.variable"]                   = { link = "@variable" },
        ["@lsp.type.parameter"]                  = { link = "@variable.parameter" },
        ["@lsp.type.property"]                   = { link = "@property" },
        ["@lsp.type.enum"]                       = { fg = palette.foam },
        ["@lsp.type.interface"]                  = { fg = palette.foam, italic = styles.italic },
        ["@lsp.type.namespace"]                  = { link = "@module" },
        ["@lsp.typemod.variable.constant"]       = { link = "@constant" },
        ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
        ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
        ["@lsp.typemod.variable.injected"]       = { link = "@variable" },

        -- lsp document highlights
        LspReferenceText                = { bg = palette.highlight_med },
        LspReferenceRead                = { bg = palette.highlight_med },
        LspReferenceWrite               = { bg = palette.highlight_high },
        LspSignatureActiveParameter     = { fg = palette.salmon, italic = styles.italic },
        LspInlayHint                    = { fg = palette.muted, italic = styles.italic },

        -- telescope
        TelescopeBorder         = make_border(),
        TelescopeNormal         = { fg = palette.subtle,  bg = palette.surface },
        TelescopePromptNormal   = { fg = palette.text,    bg = palette.overlay },
        TelescopePromptBorder   = make_border(palette.salmon),
        TelescopeResultsTitle   = { fg = palette.base,   bg = palette.salmon },
        TelescopePreviewTitle   = { fg = palette.base,   bg = palette.dill },
        TelescopeSelection      = { fg = palette.text,   bg = palette.overlay },
        TelescopeSelectionCaret = { fg = palette.salmon,   bg = palette.overlay },
        TelescopeMatching       = { fg = palette.salmon },

        -- gitsigns
        GitSignsAdd             = { fg = groups.git_add },
        GitSignsChange          = { fg = groups.git_change },
        GitSignsDelete          = { fg = groups.git_delete },
        GitSignsAddNr           = { fg = groups.git_add },
        GitSignsChangeNr        = { fg = groups.git_change },
        GitSignsDeleteNr        = { fg = groups.git_delete },
        GitSignsAddLn           = { bg = groups.git_add,    blend = 10 },
        GitSignsChangeLn        = { bg = groups.git_change, blend = 10 },

        -- nvim-tree
        NvimTreeNormal          = { fg = palette.text,   bg = palette.surface },
        NvimTreeNormalNC        = { fg = palette.muted,  bg = palette.surface },
        NvimTreeFolderName      = { fg = palette.text },
        NvimTreeOpenedFolderName = { fg = palette.salmon },
        NvimTreeRootFolder      = { fg = palette.salmon },
        NvimTreeGitNew          = { fg = groups.git_add },
        NvimTreeGitDirty        = { fg = groups.git_dirty },
        NvimTreeGitDeleted      = { fg = groups.git_delete },
        NvimTreeGitStaged       = { fg = groups.git_stage },
        NvimTreeIndentMarker    = { fg = palette.highlight_high },
        NvimTreeWinSeparator    = { fg = palette.highlight_high, bg = palette.surface },
        NvimTreeCursorLine      = { bg = palette.highlight_low },
        NvimTreeSymlink         = { fg = palette.foam },
        NvimTreeExecFile        = { fg = palette.leaf },
        NvimTreeImageFile       = { fg = palette.iris },

        -- neo-tree
        NeoTreeNormal           = { fg = palette.text,   bg = palette.surface },
        NeoTreeNormalNC         = { fg = palette.muted,  bg = palette.surface },
        NeoTreeRootName         = { fg = palette.salmon },
        NeoTreeDirectoryName    = { fg = palette.text },
        NeoTreeDirectoryIcon    = { fg = palette.foam },
        NeoTreeGitAdded         = { fg = groups.git_add },
        NeoTreeGitModified      = { fg = groups.git_change },
        NeoTreeGitDeleted       = { fg = groups.git_delete },
        NeoTreeGitUntracked     = { fg = groups.git_untracked },
        NeoTreeIndentMarker     = { fg = palette.highlight_high },
        NeoTreeExpander         = { fg = palette.muted },
        NeoTreeFileNameOpened   = { fg = palette.salmon, italic = styles.italic },

        -- which-key
        WhichKey                = { fg = palette.salmon },
        WhichKeyDesc            = { fg = palette.text },
        WhichKeyGroup           = { fg = palette.foam },
        WhichKeySeparator       = { fg = palette.subtle },
        WhichKeyFloat           = { bg = palette.surface },
        WhichKeyBorder          = make_border(),
        WhichKeyValue           = { fg = palette.muted },

        -- indent-blankline
        IblIndent               = { fg = palette.highlight_med },
        IblScope                = { fg = palette.salmon, blend = 40 },
        IndentBlanklineChar     = { fg = palette.highlight_med },
        IndentBlanklineContextChar = { fg = palette.salmon },

        -- nvim-cmp
        CmpItemAbbr             = { fg = palette.subtle },
        CmpItemAbbrDeprecated   = { fg = palette.muted, strikethrough = true },
        CmpItemAbbrMatch        = { fg = palette.salmon },
        CmpItemAbbrMatchFuzzy   = { fg = palette.salmon },
        CmpItemKind             = { fg = palette.foam },
        CmpItemKindVariable     = { fg = palette.text },
        CmpItemKindFunction     = { fg = palette.salmon },
        CmpItemKindKeyword      = { fg = palette.dill },
        CmpItemMenu             = { fg = palette.muted },

        -- noice
        NoiceCmdline            = { fg = palette.text },
        NoiceCmdlineBorder      = { fg = palette.salmon },
        NoiceCmdlineIcon        = { fg = palette.salmon },
        NoiceConfirm            = { bg = palette.surface },
        NoiceConfirmBorder      = { fg = palette.salmon },

        -- flash / leap
        FlashLabel              = { fg = palette.base, bg = palette.salmon, bold = styles.bold },
        FlashMatch              = { fg = palette.base, bg = palette.gold },
        FlashCurrent            = { fg = palette.base, bg = palette.love },
        LeapMatch               = { fg = palette.base, bg = palette.salmon, bold = styles.bold },
        LeapLabelPrimary        = { fg = palette.base, bg = palette.salmon, bold = styles.bold },
        LeapLabelSecondary      = { fg = palette.base, bg = palette.gold },

        -- mini
        MiniStatuslineModeNormal  = { fg = palette.base, bg = palette.salmon, bold = styles.bold },
        MiniStatuslineModeInsert  = { fg = palette.base, bg = palette.foam, bold = styles.bold },
        MiniStatuslineModeVisual  = { fg = palette.base, bg = palette.iris, bold = styles.bold },
        MiniStatuslineModeReplace = { fg = palette.base, bg = palette.love, bold = styles.bold },
        MiniStatuslineModeCommand = { fg = palette.base, bg = palette.gold, bold = styles.bold },
        MiniStatuslineInactive    = { fg = palette.muted, bg = palette.surface },
        MiniCursorword            = { bg = palette.highlight_med },
        MiniIndentscopeSymbol     = { fg = palette.salmon },
        MiniPickMatchCurrent      = { fg = palette.text,  bg = palette.overlay },
        MiniPickMatchRanges       = { fg = palette.salmon },

        -- trouble
        TroubleNormal           = { fg = palette.text,   bg = palette.surface },
        TroubleText             = { fg = palette.text },
        TroubleCount            = { fg = palette.salmon },
        TroubleError            = { fg = groups.error },
        TroubleWarning          = { fg = groups.warn },
        TroubleInformation      = { fg = groups.info },
        TroubleHint             = { fg = groups.hint },

        -- dashboard / alpha
        AlphaHeader             = { fg = palette.salmon },
        AlphaButtons            = { fg = palette.foam },
        AlphaShortcut           = { fg = palette.gold },
        AlphaFooter             = { fg = palette.muted, italic = styles.italic },

        -- fidget
        FidgetTitle             = { fg = palette.salmon },
        FidgetTask              = { fg = palette.subtle },
    }

    for group, hl in pairs(default_highlights) do
        highlights[group] = hl
    end

    -- ── legacy highlights ─────────────────────────────────────────────────────

    if config.options.enable.legacy_highlights then
        local legacy = {
            ["@text"]        = { link = "Normal" },
            ["@text.strong"] = { link = "@markup.strong" },
            ["@text.italic"] = { link = "@markup.italic" },
            ["@text.title"]  = { link = "@markup.heading" },
            ["@text.uri"]    = { link = "@markup.link.url" },
            ["@text.todo"]   = { link = "@comment.todo" },
            ["@method"]      = { link = "@function.method" },
            ["@method.call"] = { link = "@function.method.call" },
            ["@field"]       = { link = "@variable.member" },
            ["@parameter"]   = { link = "@variable.parameter" },
            ["@namespace"]   = { link = "@module" },
            ["@float"]       = { link = "@number.float" },
            ["@symbol"]      = { fg = palette.iris },
        }
        for group, hl in pairs(legacy) do
            highlights[group] = hl
        end
    end

    -- ── transparency overrides ────────────────────────────────────────────────

    if styles.transparency then
        local transparent = {
            Normal         = { fg = palette.text,   bg = "NONE" },
            NormalFloat    = { fg = palette.text,   bg = "NONE" },
            NormalNC       = { fg = palette.text,   bg = "NONE" },
            SignColumn     = { fg = palette.text,   bg = "NONE" },
            StatusLine     = { fg = palette.subtle, bg = "NONE" },
            StatusLineNC   = { fg = palette.muted,  bg = "NONE" },
            WinBar         = { fg = palette.subtle, bg = "NONE" },
            WinBarNC       = { fg = palette.muted,  bg = "NONE" },
            TabLine        = { fg = palette.subtle, bg = "NONE" },
            TabLineFill    = { fg = palette.subtle, bg = "NONE" },
            FloatBorder    = { fg = groups.border,  bg = "NONE" },
            FloatTitle     = { fg = palette.salmon,   bg = "NONE" },
            NvimTreeNormal = { fg = palette.text,   bg = "NONE" },
            NeoTreeNormal  = { fg = palette.text,   bg = "NONE" },
        }
        for group, hl in pairs(transparent) do
            highlights[group] = hl
        end
    end

    -- ── user highlight_groups overrides ───────────────────────────────────────

    for group, highlight in pairs(config.options.highlight_groups) do
        local existing = highlights[group] or {}
        while existing.link do
            existing = highlights[existing.link] or {}
        end
        local parsed = vim.tbl_extend("force", {}, highlight)
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

    -- ── final pass: blend → hook → apply ─────────────────────────────────────

    for group, highlight in pairs(highlights) do
        if config.options.before_highlight then
            config.options.before_highlight(group, highlight, palette)
        end
        if highlight.blend and highlight.bg and highlight.bg ~= "NONE" then
            highlight.bg = utilities.blend(
                highlight.bg,
                highlight.blend_on or palette.base,
                highlight.blend / 100
            )
        end
        highlight.blend     = nil
        highlight.blend_on  = nil
        vim.api.nvim_set_hl(0, group, highlight)
    end

    -- ── terminal colors ───────────────────────────────────────────────────────

    if config.options.enable.terminal then
        vim.g.terminal_color_0  = palette.overlay
        vim.g.terminal_color_8  = palette.subtle
        vim.g.terminal_color_1  = palette.love
        vim.g.terminal_color_9  = palette.love
        vim.g.terminal_color_2  = palette.dill
        vim.g.terminal_color_10 = palette.dill
        vim.g.terminal_color_3  = palette.gold
        vim.g.terminal_color_11 = palette.gold
        vim.g.terminal_color_4  = palette.foam
        vim.g.terminal_color_12 = palette.foam
        vim.g.terminal_color_5  = palette.iris
        vim.g.terminal_color_13 = palette.iris
        vim.g.terminal_color_6  = palette.salmon
        vim.g.terminal_color_14 = palette.salmon
        vim.g.terminal_color_7  = palette.text
        vim.g.terminal_color_15 = palette.text

        vim.cmd([[
augroup salmon
    autocmd!
    autocmd TermOpen * if &buftype=='terminal'
        \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
        \|else|setlocal winhighlight=|endif
    autocmd ColorSchemePre * autocmd! salmon
augroup END
        ]])
    end
end

-- ── public api ────────────────────────────────────────────────────────────────

function M.setup(options)
    require("salmon.config").extend_options(options or {})
end

function M.colorscheme(variant)
    local config = require("salmon.config")
    config.extend_options({ variant = variant })

    vim.opt.termguicolors = true
    if vim.g.colors_name then
        vim.cmd("hi clear")
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "salmon"

    if variant == "light" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end

    set_highlights()
end

return M
