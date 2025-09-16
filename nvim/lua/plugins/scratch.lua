return {
  "LintaoAmons/scratch.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- 或者 "ibhagwan/fzf-lua"
    "stevearc/dressing.nvim", -- 可选，更好的 UI
  },
  config = function()
    require("scratch").setup({
      scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",
      window_cmd = "rightbelow vsplit", -- 也可以是 "edit", "tabedit"

      use_telescope = true,
      file_picker = "telescope", -- "telescope" | "fzflua" | "snacks"

      -- 支持的文件类型
      filetypes = { "python", "markdown", "lua", "javascript", "typescript" },

      -- 每个文件类型的详细配置
      filetype_details = {
        python = {
          content = {
            "#!/usr/bin/env python3",
            "# -*- coding: utf-8 -*-",
            "",
            "def main():",
            "    pass",
            "",
            "if __name__ == '__main__':",
            "    main()",
          },
          cursor = {
            location = { 5, 8 }, -- 光标位置：第5行第8列
            insert_mode = true,
          },
        },
        markdown = {
          content = {
            "# 临时笔记",
            "",
            "## 日期：" .. os.date("%Y-%m-%d %H:%M:%S"),
            "",
            "---",
            "",
            "",
          },
          cursor = {
            location = { 7, 0 },
            insert_mode = true,
          },
        },
      },
    })

    -- 快捷键映射
    vim.keymap.set("n", "<leader>fs", "<cmd>Scratch<cr>", { desc = "Create scratch file" })
    vim.keymap.set("n", "<leader>fo", "<cmd>ScratchOpen<cr>", { desc = "Open scratch file" })
    vim.keymap.set("n", "<leader>fn", "<cmd>ScratchWithName<cr>", { desc = "Create named scratch file" })
  end,
}
