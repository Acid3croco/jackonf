return {
  { "williamboman/mason.nvim", cmd = "Mason", opts = {} },

  {
    "williamboman/mason-lspconfig.nvim",
    version = "^1.0",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls" },
      automatic_installation = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local lsp  = require("lspconfig")
      local caps = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        caps = require("blink.cmp").get_lsp_capabilities(caps)
      end)

      local on_attach = function(_, bufnr)
        local function k(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        k("n", "gd", vim.lsp.buf.definition,     "Definition")
        k("n", "gr", vim.lsp.buf.references,     "References")
        k("n", "gi", vim.lsp.buf.implementation, "Implementation")
        k("n", "K",  vim.lsp.buf.hover,          "Hover")
        k("n", "<leader>cr", vim.lsp.buf.rename,      "Rename")
        k("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        k("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        k("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        k("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace   = { checkThirdParty = false },
              telemetry   = { enable = false },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
      }

      for name, cfg in pairs(servers) do
        cfg.capabilities = caps
        cfg.on_attach    = on_attach
        lsp[name].setup(cfg)
      end

      vim.diagnostic.config({
        virtual_text   = { prefix = "●" },
        severity_sort  = true,
        float          = { border = "rounded" },
      })
    end,
  },
}
