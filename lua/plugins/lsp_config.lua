return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) ---@class PluginLspOpts
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
                    reportArgumentType = "none", -- ✅ 这里才对
                    reportGeneralTypeIssues = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalSubscript = "none",
                    reportUnknownMemberType = "none",
                    reportAssignmentType = "none",
                  },
                },
              },
            },
            mason = false,
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
