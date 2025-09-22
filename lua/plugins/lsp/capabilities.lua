local M = {}

-- 获取基础 capabilities
function M.get_base_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  
  return capabilities
end

-- 获取全局 capabilities 配置
function M.get_global_capabilities()
  return {
    positionEncodings = { "utf-8" },
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }
end

return M
