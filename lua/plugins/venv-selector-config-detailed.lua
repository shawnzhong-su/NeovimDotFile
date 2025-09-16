local function shorter_name(filename)
  -- 去掉 /bin/python
  local name = filename:gsub("/bin/python", "")
  -- 只保留最后一级目录名（环境名）
  return name:match("([^/]+)$") or name
end
return {
  "linux-cultist/venv-selector.nvim",
  config = function(_, _)
    require("venv-selector").setup({
      settings = {
        options = {
          -- If you put the callback here as a global option, its used for all searches (including the default ones by the plugin)
          on_telescope_result_callback = shorter_name,
        },
        keys = {
          { "<leader>cv", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
        },
        search = {
          cwd = false,
          anaconda_envs = {
            command = "fd bin/python$ /opt/miniconda3 --full-path --color never -E /proc", -- change path here to your anaconda envs
            type = "anaconda",
          },
          anaconda_base = {
            command = "fd /python$ /opt/miniconda3/envs --full-path --color never -E /proc", -- change path here to your anaconda base
            type = "anaconda",
          },
        },
      },
    })
  end,
}
