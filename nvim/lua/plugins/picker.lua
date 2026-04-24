return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader><space>", function() require("telescope.builtin").find_files() end, desc = "Files" },
      { "<leader>/",       function() require("telescope.builtin").live_grep()  end, desc = "Grep" },
      { "<leader>,",       function() require("telescope.builtin").buffers()    end, desc = "Buffers" },
      { "<leader>fh",      function() require("telescope.builtin").help_tags()  end, desc = "Help" },
      { "<leader>fr",      function() require("telescope.builtin").oldfiles()   end, desc = "Recent" },
      { "<leader>fk",      function() require("telescope.builtin").keymaps()    end, desc = "Keymaps" },
      { "<leader>fd",      function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
      { "<leader>fg",      function() require("telescope.builtin").git_status() end, desc = "Git status" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config   = { prompt_position = "top" },
        sorting_strategy = "ascending",
        path_display = { "truncate" },
      },
      pickers = {
        find_files = {
          find_command = { "fdfind", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" },
        },
      },
    },
  },
}
