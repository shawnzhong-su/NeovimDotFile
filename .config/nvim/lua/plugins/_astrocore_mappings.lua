local utils = require "utils"

return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    -- 初始化映射表
    if not opts.mappings then
      opts.mappings = require("astrocore").empty_map_table()
    end

    -- 检测当前工作区类型
    local workspace_type = require("utils").detect_workspace_type()
    local overseer = require "overseer"
    vim.notify("Workspace Type:" .. workspace_type, vim.log.levels.INFO)

    local maps = opts.mappings
    if maps then
      ----------------------------------------------------------------------
      -- Workspace 相关快捷键
      ----------------------------------------------------------------------
      if workspace_type ~= "unkown" then
        maps.n["<Leader>W"] = { "", desc = "Workspace" }
        maps.n["<Leader>Wd"] = {
          function() require("helper.workspace").ensure_workspace_dotfiles "c_cpp" end,
          desc = "Ensure dotfiles",
        }
      end

      ----------------------------------------------------------------------
      -- 通用 Tasks / Overseer
      ----------------------------------------------------------------------
      maps.n["<Leader>n"] = { "", desc = "Tasks" }
      maps.n["<Leader>nn"] = { "<Cmd>CopilotChatToggle<CR>", desc = "Copilot Chat Toggle" }
      maps.n["<Leader>o"] = { "", desc = "Overseer" }

      ----------------------------------------------------------------------
      -- C/C++ 工作区配置
      ----------------------------------------------------------------------
      if workspace_type == "c_cpp" then
        maps.n["<Leader>ns"]  = { "", desc = "Select Target" }
        maps.n["<Leader>nh"]  = { "<Cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch between source and header" }
        maps.n["<Leader>nsr"] = {
          function()
            vim.ui.input({ prompt = "target to run:" }, function(target)
              if target then
                require("toggleterm").exec("tsx project.mts run " .. target)
              else
                vim.notify("No target specified, run last target", vim.log.levels.INFO)
              end
            end)
          end,
          desc = "Run specific target",
        }
        maps.n["<Leader>nc"]  = { "<Cmd>TermExec cmd='tsx project.mts config'<CR>", desc = "Cmake config" }
        maps.n["<Leader>nb"]  = { "<Cmd>TermExec cmd='tsx project.mts build'<CR>", desc = "Build target" }
        maps.n["<Leader>nsb"] = {
          function()
            vim.ui.input({ prompt = "target to build:" }, function(target)
              if target then
                vim.cmd("TermExec cmd='tsx project.mts build " .. target .. "'")
              else
                vim.notify("No target specified, build last target", vim.log.levels.INFO)
              end
            end)
          end,
          desc = "Build specific target",
        }
        maps.n["<Leader>nt"] = { "<Cmd>TermExec cmd='tsx project.mts test'<CR>", desc = "Test" }
        maps.n["<Leader>nd"] = { "<Cmd>CMakeDebug<CR>", desc = "Debug" }
        maps.n["<F5>"]       = { "<cmd>CMakeDebug<CR>", desc = "Start Debug" }
      end

      ----------------------------------------------------------------------
      -- Rust 工作区配置
      ----------------------------------------------------------------------
      if workspace_type == "rust" then
        maps.n["<Leader>ns"]  = { "", desc = "Select Target" }
        maps.n["<F5>"]        = { "<Cmd>RustLsp! debuggables<CR>", desc = "Start Debug" }
        maps.n["<Leader>nd"]  = { "<CMd>RustLsp! debuggables<CR>", desc = "Debug" }
        maps.n["<Leader>nsd"] = { "<Cmd>RustLsp debuggables<CR>", desc = "Select Debug Target" }
        maps.n["<Leader>nb"]  = {
          function() overseer.run_template { tags = { overseer.TAG.BUILD } } end,
          desc = "Build",
        }
        maps.n["<Leader>nr"]  = { "<Cmd>RustLsp! runnables<CR>", desc = "Run" }
        maps.n["<Leader>nsr"] = { "<Cmd>RustLsp runnables<CR>", desc = "Select Run Target" }
      end

      ----------------------------------------------------------------------
      -- Terminal 模式相关快捷键
      ----------------------------------------------------------------------
      maps.t["<esc>"]  = { "<C-\\><C-n><CR>", desc = "Exit term mode" }
      maps.n["<Leader>w"]  = { "", desc = "󱂬 Window" }
      maps.n["<Leader>ww"] = { "<cmd><cr>", desc = "Save" }
      maps.n["<Leader>wc"] = { "<C-w>c", desc = "Close current screen" }
      maps.n["<Leader>wo"] = { "<C-w>o", desc = "Close other screen" }
      maps.n["<Leader>we"] = { "<C-w>=", desc = "Make all window equal" }
      maps.t["<Leader>wh"]  = { "<Cmd>wincmd h<CR>", desc = "Move to left window" }
      maps.t["<Leader>wl"]  = { "<Cmd>wincmd j<CR>", desc = "Move to down window" }
      maps.t["<Leader>wk"]  = { "<Cmd>wincmd k<CR>", desc = "Move to up window" }
      maps.t["<Leader>wj"]  = { "<Cmd>wincmd l<CR>", desc = "Move to right window" }

      ----------------------------------------------------------------------
      -- Buffer 操作
      ----------------------------------------------------------------------
      maps.n["<Leader>bd"] = { function() require("astrocore.buffer").close(0) end, desc = "Close Current Buffer" }
      maps.n["<TAB>"]      = { function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" }
      maps.n["<S-TAB>"]    = { function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer" }

      ----------------------------------------------------------------------
      -- 搜索增强
      ----------------------------------------------------------------------
      maps.n.n = { utils.better_search "n", desc = "Next search" }
      maps.n.N = { utils.better_search "N", desc = "Previous search" }

      ----------------------------------------------------------------------
      -- 编辑增强 (保存等)
      ----------------------------------------------------------------------
      maps.i["<C-S>"] = { "<esc>:w<cr>a", desc = "Save file", silent = true }
      maps.x["<C-S>"] = { "<esc>:w<cr>a", desc = "Save file", silent = true }
      maps.n["<C-S>"] = { "<Cmd>w<cr>", desc = "Save file", silent = true }

      ----------------------------------------------------------------------
      -- 光标移动增强
      ----------------------------------------------------------------------
      maps.n["n"] = { "nzz" }
      maps.n["N"] = { "Nzz" }
      maps.v["n"] = { "nzz" }
      maps.v["N"] = { "Nzz" }
      maps.n["H"] = { "^", desc = "Go to start without blank" }
      maps.n["L"] = { "$", desc = "Go to end without blank" }
      maps.v["H"] = { "^", desc = "Go to start without blank" }
      maps.v["L"] = { "$", desc = "Go to end without blank" }
      maps.v["<"] = { "<gv", desc = "Unindent line" }
      maps.v[">"] = { ">gv", desc = "Indent line" }

      ----------------------------------------------------------------------
      -- 其它增强功能
      ----------------------------------------------------------------------
      maps.n["x"] = { '"_x', desc = "Cut without copy" } -- 在 visual 模式下粘贴不会复制
      maps.n["<Leader>lm"] = { "<Cmd>LspRestart<CR>", desc = "Lsp restart" }
      maps.n["<Leader>lg"] = { "<Cmd>LspLog<CR>", desc = "Show lsp log" }

      -- 外部工具 (LazyGit / LazyDocker)
      if vim.fn.executable "lazygit" == 1 then
        maps.n["<Leader>tl"] = { require("utils").toggle_lazy_git(), desc = "ToggleTerm lazygit" }
      end
      if vim.fn.executable "lazydocker" == 1 then
        maps.n["<Leader>td"] = { require("utils").toggle_lazy_docker(), desc = "ToggleTerm lazydocker" }
      end
    end

    opts.mappings = maps

    ------------------------------------------------------------------------
    -- NeoScroll 平滑滚动配置
    ------------------------------------------------------------------------
    local neoscroll = require "neoscroll"
    local keymap = {
      ["<C-u>"] = function() neoscroll.ctrl_u { duration = 100 } end,
      ["<C-d>"] = function() neoscroll.ctrl_d { duration = 100 } end,
      ["<C-b>"] = function() neoscroll.ctrl_b { duration = 200 } end,
      ["<C-f>"] = function() neoscroll.ctrl_f { duration = 200 } end,
      ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,
      ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 100 }) end,
      ["zt"]    = function() neoscroll.zt { half_win_duration = 150 } end,
      ["zz"]    = function() neoscroll.zz { half_win_duration = 150 } end,
      ["zb"]    = function() neoscroll.zb { half_win_duration = 150 } end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)

    end

    ------------------------------------------------------------------------
    -- 修复 VISUAL -> SELECT 模式下的冲突
    ------------------------------------------------------------------------
    vim.schedule(function()
      vim.api.nvim_del_keymap("s", "n")
      vim.api.nvim_del_keymap("s", "N")
      vim.api.nvim_del_keymap("s", "H")
      vim.api.nvim_del_keymap("s", "L")
    end)
  end,
}
