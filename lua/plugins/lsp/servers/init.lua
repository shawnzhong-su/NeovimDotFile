local python = require("plugins.lsp.servers.python")
local typescript = require("plugins.lsp.servers.typescript")
local vue = require("plugins.lsp.servers.vue")
local toml = require("plugins.lsp.servers.toml")

local M = {}

-- 获取所有服务器配置
function M.get_servers_config()
  return {
    -- Python LSP
    pyright = python.get_pyright_config(),
    ruff = false, -- disable Ruff LSP in favor of Pyright only
    ruff_lsp = false, -- cover legacy server name

    -- TOML LSP
    taplo = toml.get_taplo_config(),

    -- Vue LSP
    vue_ls = vue.get_vue_ls_config(),

    -- TypeScript LSP
    ts_ls = typescript.get_ts_ls_config(),
  }
end

return M
