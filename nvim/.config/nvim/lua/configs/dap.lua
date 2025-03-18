local dap = require "dap"

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = 8123,
  executable = {
    command = "js-debug-adapter",
  },
}

for _, language in ipairs { "typescript", "javascript" } do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${workspaceFolder}",
      runtimeExecutable = "node",
    },
  }
end

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

for _, language in ipairs { "c", "cpp", "rust", "zig" } do
  dap.configurations[language] = {
    {
      name = "Launch executable",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      runInTerminal = false,
    },
  }
end

dap.adapters.python = {
  type = "server",
  port = 5678,
  executable = {
    command = "debugpy", -- Uses the debugpy executable from your PATH
    args = { "--listen", "127.0.0.1:5678" },
  },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return "python3" -- Adjust if using a virtual environment
    end,
    args = { "-Xfrozen_modules=off" }, -- Fix the frozen module warning
  },
}
--
-- local mason_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter"
--
-- dap.adapters.java = {
--   type = "executable",
--   command = "java",
--   args = {
--     "-jar",
--     mason_path .. "/extension/server/com.microsoft.java.debug.plugin.jar",
--   },
-- }
--
-- dap.configurations.java = {
--   {
--     type = "java",
--     request = "launch",
--     name = "Launch Java App",
--     mainClass = function()
--       return require("java.utils").resolve_main_class()
--     end,
--     projectName = function()
--       return vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
--     end,
--   },
-- }
