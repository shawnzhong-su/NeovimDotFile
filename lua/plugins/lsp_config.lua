-- 配置 Python 与 TOML LSP (pyright, taplo, ruff) 并统一 capabilities
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) ---@class PluginLspOpts
      -- 生成基础 capabilities，支持 snippet 补全
      local base_capabilities =
        vim.tbl_deep_extend("force", opts.capabilities or {}, vim.lsp.protocol.make_client_capabilities())
      base_capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- 合并 LSP 配置
      local ret = vim.tbl_deep_extend("force", opts, {
        servers = {
          pyright = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic",
                  useLibraryCodeForTypes = true,
                  autoSearchPaths = true,
                  diagnosticMode = "openFiles",
                  diagnosticSeverityOverrides = {
                    reportArgumentType = "none",
                    reportGeneralTypeIssues = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalSubscript = "none",
                    reportUnknownMemberType = "none",
                    reportAssignmentType = "none",
                  },
                },
              },
            },
            capabilities = base_capabilities,
            mason = false,
          },
          taplo = {
            capabilities = base_capabilities,
          },
          ruff = {
            capabilities = base_capabilities,
            -- 禁用 hover 避免与 pyright 冲突
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          },
        },
        capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
          positionEncodings = { "utf-8" },
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        }),
      })
      return ret
    end,
  },
}
