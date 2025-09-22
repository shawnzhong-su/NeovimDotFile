local utils = require("plugins.lsp.utils")
local capabilities = require("plugins.lsp.capabilities")

local M = {}

-- 获取 Vue TypeScript 插件配置
function M.get_vue_typescript_plugin()
  local vue_language_server_path = utils.get_mason_package_path(
    "vue-language-server",
    "node_modules/@vue/language-server"
  )

  return {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
  }
end

-- Vue Language Server 配置
function M.get_vue_ls_config()
  return {
    capabilities = capabilities.get_base_capabilities(),
    filetypes = { "vue" },
    init_options = {
      typescript = {
        hybridMode = false,
      },
    },
    settings = {
      vue = {
        updateImportsOnFileMove = {
          enabled = true,
        },
        inlayHints = {
          destructuredProps = { enabled = true },
          inlineHandlers = { enabled = true },
          missingProps = { enabled = true },
          optionsWrapper = { enabled = true },
          vBindShorthand = { enabled = true },
        },
      },
    },
  }
end

return M
