return {
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    opts = {
      style       = "dark",
      transparent = false,
      italics     = false,
      terminal    = vim.fn.has("gui_running") == 1,
    },
    config = function(_, opts)
      require("bluloco").setup(opts)
      vim.cmd.colorscheme("bluloco-dark")
    end,
  },
}
