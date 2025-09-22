local vue_config = require("plugins.lsp.servers.vue")
local capabilities = require("plugins.lsp.capabilities")

local M = {}

-- TypeScript 文件类型
M.filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

-- TypeScript Language Server 配置
function M.get_ts_ls_config()
  return {
    capabilities = capabilities.get_base_capabilities(),
    filetypes = M.filetypes,
    init_options = {
      plugins = {
        vue_config.get_vue_typescript_plugin(),
      },
    },
    settings = {
      typescript = {
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
      -- 如果是 vue 文件，停用 ts_ls 的 semanticTokens.full（避免重复）
      if vim.bo[bufnr].filetype == "vue" then
        if client.server_capabilities.semanticTokensProvider then
          client.server_capabilities.semanticTokensProvider.full = false
        end
      end
    end,
  }
end

return M
