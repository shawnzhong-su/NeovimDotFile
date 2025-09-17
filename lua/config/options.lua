-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options her
opts = {
  dashboard = {
    preset = {
      pick = function(cmd, opts)
        return LazyVim.pick(cmd, opts)()
      end,
      header = [[
₊      ・      ₊               ₊            °        ☆
     ☆    ₊          ⋆.       ₊        ★           ⊹    
              ⟡     ⊹             .                     ☾
 ⋆      .                  ⟡      .         ₊         .      
                   ˖                   ˖           °  
      ☾     ｡   ∩―――――∩  ₊        ⊹         ☆
            || ∧,,∧ ∧,,,∧     ||       .            ⋆
    .  ⋆   ||(˶´ ｰ(˶-ω-˶)   ||  𝓂𝓌𝒶 💖       ₊
        ☆      |ﾉ￣づ⌒⌒￣  ＼     ⋆         . 
  .      .    (　ノ　⌒⌒ ヽ   ＼      ₊         ☾
      ₊     ＼   ノ||￣￣￣￣￣||         ₊  
　             ＼,ﾉ||￣￣￣￣￣||
]],
       -- stylua: ignore
       ---@type snacks.dashboard.Item[]
       keys = {
         { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
         { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
         { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
         { icon = " ", key = "s", desc = "Restore Session", section = "session" },
         { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
       },
    },
  },
}
