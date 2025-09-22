local servers = require("plugins.lsp.servers")
local capabilities = require("plugins.lsp.capabilities")
local utils = require("plugins.lsp.utils")

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 基础 capabilities
      local base_capabilities = utils.deep_extend(
        opts.capabilities or {},
        capabilities.get_base_capabilities()
      )

      -- 构建最终配置
      local ret = utils.deep_extend(opts, {
        servers = servers.get_servers_config(),
        capabilities = utils.deep_extend(
          opts.capabilities or {},
          capabilities.get_global_capabilities()
        ),
      })

      return ret
    end,
  },
}
