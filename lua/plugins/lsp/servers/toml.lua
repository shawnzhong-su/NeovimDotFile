local capabilities = require("plugins.lsp.capabilities")

local M = {}

function M.get_taplo_config()
  return {
    capabilities = capabilities.get_base_capabilities(),
  }
end

return M
