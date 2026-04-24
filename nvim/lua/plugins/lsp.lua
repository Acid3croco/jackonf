return {
  { "williamboman/mason.nvim", opts = {} },

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      local caps = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        caps = require("blink.cmp").get_lsp_capabilities(caps)
      end)

      vim.lsp.config("*", { capabilities = caps })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
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
          k("n", "]d", function() vim.diagnostic.jump({ count =  1, float = true }) end, "Next diagnostic")
          k("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
        end,
      })

      vim.diagnostic.config({
        virtual_text  = { prefix = "●" },
        severity_sort = true,
        float         = { border = "rounded" },
      })
    end,
  },
}
