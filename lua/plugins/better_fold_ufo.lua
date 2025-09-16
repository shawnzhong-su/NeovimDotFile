-- ~/.config/nvim/lua/plugins/ufo.lua
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
      -- 基本折叠配置
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- 快捷键
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

      -- 给 LSP 添加 foldingRange 能力
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- 这里不用手动写循环，LazyVim 已经帮你处理过 capabilities 了
      -- 如果想覆盖，可以写到 opts.servers 里

      -- 配置 ufo
      require("ufo").setup({
        provider_selector = function(_, filetype, _)
          -- treesitter > indent
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
}
