return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
      { "-",         "<cmd>Oil<cr>", desc = "Parent directory" },
    },
    opts = {
      view_options = { show_hidden = true },
      keymaps = { ["q"] = "actions.close" },
    },
  },

  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.ai").setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function k(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        k("n", "]h", gs.next_hunk,    "Next hunk")
        k("n", "[h", gs.prev_hunk,    "Prev hunk")
        k("n", "<leader>gs", gs.stage_hunk,   "Stage hunk")
        k("n", "<leader>gr", gs.reset_hunk,   "Reset hunk")
        k("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        k("n", "<leader>gb", gs.blame_line,   "Blame line")
      end,
    },
  },
}
