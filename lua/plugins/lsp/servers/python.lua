local capabilities = require("plugins.lsp.capabilities")

local M = {}

function M.get_pyright_config()
  return {
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
    capabilities = capabilities.get_base_capabilities(),
    mason = false,
  }
end

function M.get_ruff_config()
  return {
    capabilities = capabilities.get_base_capabilities(),
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false
    end,
  }
end

return M
