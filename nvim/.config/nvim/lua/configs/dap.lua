local dap = require("dap")

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = 8123,
  executable = {
    command = "js-debug-adapter",
  }
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
    args = {"--port", "${port}"},
  }
}

for _, language in ipairs({ "c", "cpp", "rust", "zig" }) do
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

dap.adapters.debugpy = {
  type = "server",
  port = "${port}",
  executable = {
    command = "debugpy",
    args = {"--port", "${port}"},
  }
}
