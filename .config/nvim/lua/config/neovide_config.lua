if vim.g.neovide then
  -- 字体配置（需确保系统已安装 Google Sans Code 字体）
  vim.o.guifont = "Google Sans Code:h20"

  -- 动态缩放系数（可运行时修改）
  vim.g.neovide_scale_factor = 1.0

  -- 光标特效配置
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_density = 7.0 -- 粒子密度参数

  -- 字体渲染参数
  vim.g.neovide_text_gamma = 0.8 -- 取值范围: 0.01 - 10
  vim.g.neovide_text_contrast = 0.1 -- 对比度增强，越大越明显

  -- 窗口边框控制
  vim.g.neovide_show_border = false

  -- 可选: 添加快捷键动态调整缩放
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end, { desc = "Zoom in GUI" })
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end, { desc = "Zoom out GUI" })
end
