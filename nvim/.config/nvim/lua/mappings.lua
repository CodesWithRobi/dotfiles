require "nvchad.mappings"
local map = vim.keymap.set
-- General mappings
map("n", "<C-d>", "<C-d>zz", { desc = "Move down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move up centered" })
map("n", "n", "nzzzv", { desc = "Center while searching next" })
map("n", "N", "Nzzzv", { desc = "Center while searching next (backward)" })

-- Visual mode mappings
map("v", ">", ">gv", { desc = "Indent and reselect" })

-- Debugger (DAP) mappings
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Run or continue the debugger" })
map("n", "<leader>dpr", function ()
  require("dap-python").test_method()
end, { desc = "Run or continue the debugger" })
