return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader><space>", function() require("fzf-lua").files() end,                  desc = "Files" },
      { "<leader>/",       function() require("fzf-lua").live_grep() end,              desc = "Grep project" },
      { "<leader>,",       function() require("fzf-lua").buffers() end,                desc = "Buffers" },

      { "<leader>ff",      function() require("fzf-lua").files() end,                  desc = "Files" },
      { "<leader>fl",      function() require("fzf-lua").blines() end,                 desc = "Lines (current file)" },
      { "<leader>fL",      function() require("fzf-lua").lines() end,                  desc = "Lines (all buffers)" },
      { "<leader>fw",      function() require("fzf-lua").grep_cword() end,             desc = "Word under cursor (project)" },
      { "<leader>fs",      function() require("fzf-lua").lsp_document_symbols() end,   desc = "Symbols (file)" },
      { "<leader>fS",      function() require("fzf-lua").lsp_workspace_symbols() end,  desc = "Symbols (workspace)" },
      { "<leader>fr",      function() require("fzf-lua").oldfiles() end,               desc = "Recent" },
      { "<leader>fb",      function() require("fzf-lua").buffers() end,                desc = "Buffers" },
      { "<leader>fh",      function() require("fzf-lua").helptags() end,               desc = "Help" },
      { "<leader>fk",      function() require("fzf-lua").keymaps() end,                desc = "Keymaps" },
      { "<leader>fd",      function() require("fzf-lua").diagnostics_document() end,   desc = "Diagnostics" },
      { "<leader>fg",      function() require("fzf-lua").git_status() end,             desc = "Git status" },
      { "<leader>fR",      function() require("fzf-lua").resume() end,                 desc = "Resume last picker" },
    },
    opts = {
      "default-title",
      winopts = {
        height = 0.85,
        width  = 0.85,
        preview = { layout = "flex", flip_columns = 120 },
      },
      files = {
        cmd = "fdfind --type f --hidden --strip-cwd-prefix --exclude .git",
      },
    },
  },
}
