return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
      },
    },
  },

  {
    "echasnovski/mini.statusline",
    version = false,
    event = "VeryLazy",
    config = function()
      local mst = require("mini.statusline")
      mst.setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = mst.section_mode({ trunc_width = 120 })
            local git           = mst.section_git({ trunc_width = 40 })
            local diagnostics   = mst.section_diagnostics({ trunc_width = 75 })
            local filename      = mst.section_filename({ trunc_width = 140 })
            local fileinfo      = mst.section_fileinfo({ trunc_width = 120 })
            local location      = mst.section_location({ trunc_width = 75 })
            local search        = mst.section_searchcount({ trunc_width = 75 })

            local hints = "%#Comment#␣␣files  ␣/grep  ␣fl line  ␣fw word  gd def  K hover%*"

            return mst.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              { hl = "MiniStatuslineDevinfo",  strings = { git, diagnostics } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFilename", strings = { hints } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })
          end,
        },
      })
    end,
  },
}
