vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.mouse = "a"
o.clipboard = "unnamedplus"
o.termguicolors = true

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8

o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

o.splitright = true
o.splitbelow = true

o.undofile = true
o.updatetime = 250
o.timeoutlen = 400

o.completeopt = "menu,menuone,noselect"
o.list = true
o.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
