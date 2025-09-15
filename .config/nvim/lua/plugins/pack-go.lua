--- NOTE: To develop golang, enable it
if true then
  return {}
else
  local utils = require "astrocore"
  --TODO: https://github.com/golang/go/issues/60903

  -- NOTE: gopls commands
  -- GoTagAdd add tags
  -- GOTagRm remove tags
  -- GoCmt add cmt
  -- GoFillStruct	auto fill struct
  -- GoFillSwitch	fill switch
  -- GoIfErr	Add if err
  -- GoFixPlurals	change func foo(b int, a int, r int) -> func foo(b, a, r int)

  ---@type LazySpec
  return {
    {
      "AstroNvim/astrolsp",
      optional = true,
      ---@type AstroLSPOpts
      opts = {
        ---@diagnostic disable: missing-fields
        config = {
          gopls = {
            on_attach = function(client, _)
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end,
            settings = {
              gopls = {
                analyses = {
                  ST1003 = false,
                  SA5008 = false,
                  fieldalignment = false,
                  fillreturns = true,
                  nilness = true,
                  nonewvars = true,
                  shadow = true,
                  undeclaredname = true,
                  unreachable = true,
                  unusedparams = true,
                  unusedwrite = true,
                  useany = true,
                },
                codelenses = {
                  gc_details = false, -- Show a code lens toggling the display of gc's choices.
                  generate = true, -- show the `go generate` lens.
                  regenerate_cgo = true,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                  vendor = true,
                },
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
                buildFlags = { "-tags", "integration" },
                completeUnimported = true,
                diagnosticsDelay = "500ms",
                matcher = "Fuzzy",
                semanticTokens = true,
                staticcheck = true,
                symbolMatcher = "fuzzy",
                usePlaceholders = false,
              },
            },
          },
        },
      },
    },
    -- Golang support
    {
      "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed = require("astrocore").list_insert_unique(
            opts.ensure_installed,
            { "go", "gomod", "gosum", "gowork", "goctl", "gotmpl" }
          )
        end
      end,
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      optional = true,
      opts = function(_, opts)
        -- lsp
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
          "gomodifytags",
          "gotests",
          "iferr",
          "impl",
          "gopls",
          "delve",
        })
      end,
    },
    {
      "leoluz/nvim-dap-go",
      ft = "go",
      dependencies = {
        "mfussenegger/nvim-dap",
        { "PongKJ/mason-nvim-dap.nvim", optional = true },
      },
    },
    {
      "olexsmir/gopher.nvim",
      ft = "go",
      build = function()
        if not require("lazy.core.config").spec.plugins["mason.nvim"] then
          vim.print "Installing go dependencies..."
          vim.cmd.GoInstallDeps()
        end
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "williamboman/mason.nvim", optional = true }, -- by default use Mason for go dependencies
      },
      opts = {},
    },
    {
      "nvim-neotest/neotest",
      optional = true,
      dependencies = { "nvim-neotest/neotest-go" },
      opts = function(_, opts)
        if not opts.adapters then opts.adapters = {} end
        table.insert(opts.adapters, require "neotest-go"(require("astrocore").plugin_opts "neotest-go"))
      end,
    },
    {
      "chaozwn/goctl.nvim",
      ft = "goctl",
      enabled = vim.fn.executable "goctl" == 1,
      opts = function()
        local group = vim.api.nvim_create_augroup("GoctlAutocmd", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          group = group,
          pattern = "goctl",
          callback = function()
            -- set up format keymap
            vim.keymap.set(
              "n",
              "<Leader>lf",
              "<Cmd>GoctlApiFormat<CR>",
              { silent = true, noremap = true, buffer = true, desc = "Format Buffer" }
            )
          end,
        })
      end,
    },
  }
end
