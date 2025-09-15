local is_available = require("astrocore").is_available

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
      -- telescope plugin mappings
      if is_available "telescope.nvim" then
        opts.mappings.v["<Leader>f"] = { desc = "󰍉 Find" }
        opts.mappings.n["<Leader>fT"] = { "<cmd>TodoTelescope<cr>", desc = "Find TODOs" }
      end
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = function(_, opts)
      local actions = require "telescope.actions"

      return require("astrocore").extend_tbl(opts, {
        pickers = {
          find_files = {
            -- dot file
            hidden = true,
          },
          buffers = {
            path_display = { "smart" },
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer + actions.move_to_top },
              n = { ["d"] = actions.delete_buffer + actions.move_to_top },
            },
          },
        },
      })
    end,
    -- config = function(...) require "astronvim.plugins.configs.telescope"(...) end,
    -- config = function(...) require "astronvim.plugins.configs.telescope"(...) end,
  },
}
