return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = function()
      require("venv-selector").setup({
        auto_refresh = true,
        search_paths = {
          "/opt/miniconda3/envs/*/",
          -- 搜索所有项目文件夹
          "/opt/miniconda3/envs/*/.venv",
          -- 直接搜索 .venv 文件夹
          "/opt/miniconda3/envs/*/venv",
          -- 也搜索 venv 文件夹
          "/opt/miniconda3/envs/*/env",
          -- 也搜索 env 文件夹
        },
        stay_on_this_version = true,
      })
    end,
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>" } },
  },
}
