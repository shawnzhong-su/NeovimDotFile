---@type LazySpec
return {
  "chaozwn/auto-save.nvim",
  opts = {
    debounce_delay = 3000,
    print_enabled = false,
    trigger_events = { "TextChanged", "InsertLeave" },
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        -- check weather not in normal mode
        if fn.mode() ~= "n" then
          return false
        else
          return true
        end
      end
      return false -- can't save
    end,
  },
  config = function(_, opts)
    local autoformat_group = vim.api.nvim_create_augroup("AutoformatToggle", { clear = true })

    -- Disable autoformat before saving
    vim.api.nvim_create_autocmd("User", {
      group = autoformat_group,
      pattern = "AutoSaveWritePre",
      desc = "Disable autoformat before saving",
      callback = function()
        -- Save global autoformat status
        vim.g.OLD_AUTOFORMAT = vim.g.autoformat
        vim.g.autoformat = false

        local old_autoformat_buffers = {}
        -- Disable all manually enabled buffers
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.b[bufnr].autoformat then
            table.insert(old_autoformat_buffers, bufnr)
            vim.b[bufnr].autoformat = false
          end
        end

        vim.g.OLD_AUTOFORMAT_BUFFERS = old_autoformat_buffers
      end,
    })

    -- Re-enable autoformat after saving
    vim.api.nvim_create_autocmd("User", {
      group = autoformat_group,
      pattern = "AutoSaveWritePost",
      desc = "Re-enable autoformat after saving",
      callback = function()
        -- Restore global autoformat status
        vim.g.autoformat = vim.g.OLD_AUTOFORMAT
        -- Re-enable all manually enabled buffers
        for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
          vim.b[bufnr].autoformat = true
        end
      end,
    })

    require("auto-save").setup(opts)
  end,
}
