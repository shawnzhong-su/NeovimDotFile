return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) ---@class PluginLspOpts
      -- 基础 capabilities，包括 snippet support
      local base_capabilities =
        vim.tbl_deep_extend("force", opts.capabilities or {}, vim.lsp.protocol.make_client_capabilities())
      base_capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- 获取 vue-language-server 的路径（Mason 安装位置）
      local mason_registry = require("mason-registry")
      local vue_ls_pkg = mason_registry.get_package("vue-language-server")
      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      -- Vue TS 插件
      local vue_typescript_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      -- 文件类型统一
      local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

      local ret = vim.tbl_deep_extend("force", opts, {
        servers = {
          -- Python LSP 保持不变
          pyright = {
            settings = {
              python = {
                analysis = {
                  -- 你的设置
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
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          },

          -- Vue LSP (Vol​ar / vue-language-server)
          vue_ls = {
            capabilities = base_capabilities,
            filetypes = { "vue" },
            init_options = {
              typescript = {
                ts_ls = 
              }
              vue = {
                -- 比如禁用 Hy​brid mode 如果需要
                hybridMode = false,
              },
            },
            settings = {
              vue = {
                updateImportsOnFileMove = {
                  enabled = true,
                },
                inlayHints = {
                  -- 根据 RÉMINO 推荐的一些 Vue 内嵌提示选项
                  destructuredProps = { enabled = true },
                  inlineHandlers = { enabled = true },
                  missingProps = { enabled = true },
                  optionsWrapper = { enabled = true },
                  vBindShorthand = { enabled = true },
                },
              },
            },
            capabilities = base_capabilities,
          },

          -- TypeScript + Vue plugin via ts_ls
          ts_ls = {
            capabilities = base_capabilities,
            filetypes = tsserver_filetypes,
            init_options = {
              plugins = {
                vue_typescript_plugin,
              },
            },
            settings = {
              typescript = {
                -- RÉMINO 建议关闭某些 TS server 的 hybrid/语法 server特性
                tsserver = {
                  useSyntaxServer = false,
                },
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
            on_attach = function(client, bufnr)
              -- 如果是 vue 文件，可以停用 ts_ls 的 semanticTokens.full（避免重复）
              if vim.bo[bufnr].filetype == "vue" then
                if client.server_capabilities.semanticTokensProvider then
                  client.server_capabilities.semanticTokensProvider.full = false
                end
              end
            end,
          },
        },

        -- 全局 capabilities 配置
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

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "vue", "typescript", "javascript" })
      vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })
      return opts
    end,
  },
}
