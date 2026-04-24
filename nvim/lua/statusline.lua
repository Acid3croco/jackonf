local M = {}

local mode_map = {
  ["n"]   = "NOR",
  ["no"]  = "OP",
  ["i"]   = "INS",
  ["ic"]  = "INS",
  ["v"]   = "VIS",
  ["V"]   = "V-L",
  ["\22"] = "V-B",
  ["s"]   = "SEL",
  ["S"]   = "S-L",
  ["c"]   = "CMD",
  ["R"]   = "REP",
  ["t"]   = "TRM",
  ["nt"]  = "TRM",
}

local function mode()
  local m = vim.fn.mode(1)
  return mode_map[m] or mode_map[m:sub(1, 1)] or m
end

local function diag()
  local e, w = 0, 0
  for _, d in ipairs(vim.diagnostic.get(0)) do
    if     d.severity == 1 then e = e + 1
    elseif d.severity == 2 then w = w + 1 end
  end
  local parts = {}
  if e > 0 then parts[#parts + 1] = "✗" .. e end
  if w > 0 then parts[#parts + 1] = "⚠" .. w end
  return #parts > 0 and ("  " .. table.concat(parts, " ")) or ""
end

local HINTS = table.concat({
  "%#Special#FIND%* ␣␣:files ␣/:grep ␣,:bufs",
  "%#Special#LSP%* K:hover gd:def ␣ca:action ␣cr:rename",
  "%#Special#GIT%* ]h:next ␣gp:preview ␣gb:blame ",
}, "  ")

function M.render()
  return string.format(
    " %%#ModeMsg#%s%%* %%f%%m%%r%s %%= %s  %%l:%%c %%p%%%% ",
    mode(), diag(), HINTS
  )
end

function M.setup()
  vim.opt.laststatus = 3
  vim.opt.showmode = false
  vim.opt.statusline = "%!v:lua.require'statusline'.render()"
end

return M
