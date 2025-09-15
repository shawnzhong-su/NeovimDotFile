return {
  "tiagovla/tokyodark.nvim",
  lazy = true,
  priority = 1000,
  opts = {
    transparent_background = false, -- set background to transparent
    gamma = 1.00, -- adjust the brightness of the theme
    styles = {
      comments = { italic = true }, -- style for comments
      keywords = { italic = true }, -- style for keywords
      identifiers = { italic = true }, -- style for identifiers
      functions = {}, -- style for functions
      variables = {}, -- style for variables
    },
    custom_highlights = {} or function(highlights, palette) return {} end, -- extend highlights
    custom_palette = {} or function(palette) return {} end, -- extend palette
    terminal_colors = true, -- enable terminal colors
  },
}
