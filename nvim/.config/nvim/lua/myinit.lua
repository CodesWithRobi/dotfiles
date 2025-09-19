local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
vim.opt.relativenumber = true

-- Show Nvdash when all buffers are closed
autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

-- This autocmd will restore cursor position on file open
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
      vim.cmd 'normal! zz' -- Center the screen on the restored line
    end
  end,
})

-- Dynamic terminal padding
autocmd("VimEnter", {
  command = ":silent !kitty @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
  command = ":silent !kitty @ set-spacing padding=20 margin=10",
})

-- Save folds when leaving markdown buffers
autocmd("BufWinLeave", {
  pattern = "*.md",
  command = "mkview",
})

-- Restore folds when reopening markdown buffers
autocmd("BufWinEnter", {
  pattern = "*.md",
  command = "silent! loadview",
})

-- Run sync in background when quitting with todo.md open
autocmd("VimLeavePre", {
  pattern = "*/todo.md",
  callback = function()
    -- start detached process
    vim.fn.jobstart({"bash", "-c", "~/Documents/CloudStorage/todo.sh & disown"})
  end,
})
