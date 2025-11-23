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

return M
