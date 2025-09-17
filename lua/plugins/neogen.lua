-- EDITING SUPPORT PLUGINS
-- some plugins that help with python-specific editing operations

-- Docstring creation
-- * quickly create docstrings via `<leader>a`
return {
  {
    "danymat/neogen",
    opts = true,
    keys = {
      {
        "<leader>ad",
        function()
          require("neogen").generate()
        end,
        desc = "Add Docstring",
      },
    },
  },

  -- f-strings
  -- * auto-convert strings to f-strings when typing `{}` in a string
  -- * also auto-converts f-strings back to regular strings when removing `{}`
  {
    "chrisgrieser/nvim-puppeteer",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
