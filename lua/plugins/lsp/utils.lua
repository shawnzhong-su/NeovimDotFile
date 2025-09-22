local M = {}

-- 获取 Mason 包路径
function M.get_mason_package_path(package_name, sub_path)
  local mason_registry = require("mason-registry")
  local pkg = mason_registry.get_package(package_name)
  local base_path = vim.fn.stdpath("data") .. "/mason/packages/" .. package_name
  return sub_path and (base_path .. "/" .. sub_path) or base_path
end

-- 深度合并表
function M.deep_extend(...)
  return vim.tbl_deep_extend("force", ...)
end

return M
