return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- 确保安装必要的解析器
      vim.list_extend(opts.ensure_installed or {}, { "vue", "typescript", "javascript" })
      
      -- 设置语法高亮
      vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })
      
      return opts
    end,
  },
}
