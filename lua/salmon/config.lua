local config = {}

local function migrate(options)
    return options
end

config.options = {
    variant      = "auto",
    dark_variant = "dark",

    dim_inactive_windows             = false,
    extend_background_behind_borders = true,

    enable = {
        legacy_highlights = true,
        migrations        = true,
        terminal          = true,
    },

    styles = {
        bold         = true,
        italic       = true,
        transparency = false,
    },

    palette = {},

    groups = {
        border        = "muted",
        link          = "iris",
        panel         = "surface",
        error         = "love",
        warn          = "gold",
        hint          = "iris",
        info          = "foam",
        ok            = "leaf",
        note          = "dill",
        todo          = "salmon",
        git_add       = "leaf",
        git_change    = "salmon",
        git_delete    = "love",
        git_dirty     = "salmon",
        git_ignore    = "muted",
        git_merge     = "iris",
        git_rename    = "dill",
        git_stage     = "iris",
        git_text      = "salmon",
        git_untracked = "subtle",
        h1            = "salmon",
        h2            = "foam",
        h3            = "gold",
        h4            = "dill",
        h5            = "iris",
        h6            = "leaf",
    },

    highlight_groups = {},
    before_highlight = nil,
}

function config.extend_options(options)
    config.options = vim.tbl_deep_extend("force", config.options, options or {})
    if config.options.enable.migrations then
        config.options = migrate(config.options)
    end
end

return config
