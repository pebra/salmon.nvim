local utilities = {}

local color_cache = {}
function utilities.parse_color(color)
    if color_cache[color] then return color_cache[color] end
    if color == nil then return nil end
    local c = color:lower()
    if not c:find("#") and c ~= "none" then
        c = require("salmon.palette")[c] or vim.api.nvim_get_color_by_name(c)
    end
    color_cache[color] = c
    return c
end

local blend_cache = {}
function utilities.blend(fg, bg, alpha)
    local key = fg .. bg .. tostring(alpha)
    if blend_cache[key] then return blend_cache[key] end

    local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return {
            r = tonumber(hex:sub(1, 2), 16),
            g = tonumber(hex:sub(3, 4), 16),
            b = tonumber(hex:sub(5, 6), 16),
        }
    end

    local fg_c = hex_to_rgb(fg)
    local bg_c = hex_to_rgb(bg)

    local result = string.format("#%02X%02X%02X",
        math.floor(alpha * fg_c.r + (1 - alpha) * bg_c.r + 0.5),
        math.floor(alpha * fg_c.g + (1 - alpha) * bg_c.g + 0.5),
        math.floor(alpha * fg_c.b + (1 - alpha) * bg_c.b + 0.5)
    )

    blend_cache[key] = result
    return result
end

return utilities
