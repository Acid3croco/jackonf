return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "bash", "c", "diff", "html", "css",
        "javascript", "typescript", "tsx",
        "json", "lua", "luadoc",
        "markdown", "markdown_inline",
        "python", "query", "regex",
        "toml", "vim", "vimdoc", "yaml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if lang and vim.treesitter.language.add(lang) then
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })
    end,
  },
}
