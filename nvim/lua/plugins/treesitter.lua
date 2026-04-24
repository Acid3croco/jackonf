return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "diff", "html", "css",
        "javascript", "typescript", "tsx",
        "json", "lua", "luadoc",
        "markdown", "markdown_inline",
        "python", "query", "regex",
        "toml", "vim", "vimdoc", "yaml",
      },
      highlight = { enable = true },
      indent    = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
