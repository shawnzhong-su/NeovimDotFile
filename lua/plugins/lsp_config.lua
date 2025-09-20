-- 配置 Python、TOML 和 Vue3 LSP 并统一 capabilities
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) ---@class PluginLspOpts
      -- 生成基础 capabilities，支持 snippet 补全
      local base_capabilities =
        vim.tbl_deep_extend("force", opts.capabilities or {}, vim.lsp.protocol.make_client_capabilities())
      base_capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- 获取 vue-language-server 路径 (Mason v2)
      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      -- Vue TypeScript 插件配置
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      -- TypeScript 文件类型（包含 Vue）
      local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

      -- 合并 LSP 配置
      local ret = vim.tbl_deep_extend("force", opts, {
        servers = {
          -- Python LSP
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

          -- TOML LSP
          taplo = {
            capabilities = base_capabilities,
          },

          -- Ruff LSP
          ruff = {
            capabilities = base_capabilities,
            -- 禁用 hover 避免与 pyright 冲突
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          },

          -- Vue Language Server
          vue_ls = {
            capabilities = base_capabilities,
            filetypes = { "vue" },
            settings = {
              vue = {
                updateImportsOnFileMove = {
                  enabled = true,
                },
              },
            },
            -- 必须启用 on_init 来处理 tsserver 请求转发
            on_init = function(client)
              client.handlers["tsserver/request"] = function(_, result, context)
                local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
                if #vtsls_clients == 0 then
                  -- 静默返回，避免过多错误提示
                  return
                end

                local vtsls_client = vtsls_clients[1]
                local param = result and unpack(result)
                if not param then
                  return
                end

                local id, command, payload = unpack(param)

                vtsls_client:exec_cmd({
                  title = "vue_request_forward",
                  command = "typescript.tsserverRequest",
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response = r and r.body
                  local response_data = { { id, response } }
                  client:notify("tsserver/response", response_data)
                end)
              end
            end,
          },

          -- TypeScript Language Server (vtsls)
          vtsls = {
            capabilities = base_capabilities,
            filetypes = tsserver_filetypes,
            settings = {
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
                tsserver = {
                  globalPlugins = {
                    vue_plugin,
                  },
                  -- 添加最大内存限制，避免大项目内存溢出
                  maxTsServerMemory = 8192,
                },
              },
              typescript = {
                updateImportsOnFileMove = {
                  enabled = "always",
                },
                suggest = {
                  completeFunctionCalls = true,
                },
                -- 禁用 TypeScript 的语义检查，让 vue_ls 处理
                preferences = {
                  importModuleSpecifier = "relative",
                  includePackageJsonAutoImports = "auto",
                },
                tsserver = {
                  useSyntaxServer = "never",
                },
                inlayHints = {
                  parameterNames = {
                    enabled = "literals",
                  },
                  parameterTypes = {
                    enabled = true,
                  },
                  variableTypes = {
                    enabled = false,
                  },
                  propertyDeclarationTypes = {
                    enabled = true,
                  },
                  functionLikeReturnTypes = {
                    enabled = true,
                  },
                  enumMemberValues = {
                    enabled = true,
                  },
                },
              },
            },
            -- 处理 Vue 文件的语义标记
            on_attach = function(client, bufnr)
              -- 对 Vue 文件完全禁用 vtsls 的诊断
              if vim.bo[bufnr].filetype == "vue" then
                client.server_capabilities.semanticTokensProvider = nil
                -- 禁用 vtsls 在 Vue 文件中的诊断
                vim.diagnostic.disable(bufnr, vim.lsp.diagnostic.get_namespace(client.id))
              end
            end,
          },

          -- 如果你想使用 ts_ls 而不是 vtsls，取消下面的注释并注释掉上面的 vtsls 配置
          --[[
          ts_ls = {
            capabilities = base_capabilities,
            filetypes = tsserver_filetypes,
            init_options = {
              plugins = {
                vue_plugin,
              },
            },
            settings = {
              typescript = {
                updateImportsOnFileMove = {
                  enabled = "always",
                },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  includeInlayParameterNameHints = "literals",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
            on_attach = function(client, bufnr)
              if vim.bo[bufnr].filetype == 'vue' then
                client.server_capabilities.semanticTokensProvider.full = false
              else
                client.server_capabilities.semanticTokensProvider.full = true
              end
            end,
          },
          --]]
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

  -- 可选：添加 Vue 相关的语义标记高亮组配置
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- 确保安装 Vue parser
      vim.list_extend(opts.ensure_installed or {}, { "vue", "typescript", "javascript" })

      -- 设置 Vue 组件高亮组（保持旧行为）
      vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })

      return opts
    end,
  },
}
