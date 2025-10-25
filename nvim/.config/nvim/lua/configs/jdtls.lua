local M = {}
local nvlsp = require "nvchad.configs.lspconfig"

local function get_jdtls_paths()
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local jdtls_path = mason_path .. "/packages/jdtls"
  local java_dbg_path = mason_path .. "/packages/java-debug-adapter"
  local java_test_path = mason_path .. "/packages/java-test"

  local bundles = {}
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))

  return {
    jdtls_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    jdtls_config = jdtls_path .. "/config_linux", -- Change if needed
    bundles = bundles,
  }
end

M.setup = function()
  local jdtls = require("jdtls")
  local paths = get_jdtls_paths()

  if paths.jdtls_jar == "" then
    vim.notify("JDTLS launcher JAR not found!", vim.log.levels.ERROR)
    return
  end

  -- Determine project root; for single files, fallback to current directory.
  local root = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }) or vim.fn.getcwd()

  local config = {
    cmd = {
      "/home/sec/.sdkman/candidates/java/current/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", paths.jdtls_jar,
      "-configuration", paths.jdtls_config,
      "-data", vim.fn.expand("~/.cache/jdtls/workspace/") .. vim.fn.fnamemodify(root, ":p:h:t"),
    },
    root_dir = root,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        compilerOptions = { "--enable-preview" }  -- Enable preview features
      },
    },
    init_options = {
      bundles = paths.bundles,
    },
    capabilities = nvlsp.capabilities,
    -- This on_attach will be called after the client attaches.
    on_attach = function(client, bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      vim.notify("JDTLS attached to buffer " .. bufnr)
      vim.api.nvim_exec_autocmds("LspAttach", {
        buffer = bufnr,
        data = { client_id = client.id },
      })
      nvlsp.on_attach(client, bufnr)
      -- Register buffer-local keymaps, autocommands, etc.
      -- For example, setting up LSP signature (if not already handled elsewhere):
      -- vim.api.nvim_create_autocmd("CursorHoldI", {
      --   buffer = bufnr,
      --   callback = function() require("nvchad.lsp.signature").setup() end,
      -- })
    end,
  }

  local client = jdtls.start_or_attach(config)

  -- Setup DAP after jdtls
  if client then

    -- Let nvim-cmp, signature help, code actions, etc., know about it
    vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })

    -- I guess this is removed now..:
    -- Call your NvChad LSP attach logic if needed
    -- local custom_on_attach = require("nvchad.configs.lspconfig").on_attach
    -- custom_on_attach(client, vim.api.nvim_get_current_buf())

    jdtls.setup_dap({ hotcodereplace = "auto" })
  end

  -- Monkey-patch to prevent errors when classfile is opened before client is ready
  local original_open = jdtls.open_classfile
  jdtls.open_classfile = function(opts)
    local jdtls_client = vim.iter(vim.lsp.get_clients({ name = "jdtls" })):next()
    local bufnr = opts and opts.buf or vim.api.nvim_get_current_buf()

    if jdtls_client then
      vim.lsp.buf_attach_client(bufnr, jdtls_client.id)
      original_open(opts)
    else
      vim.notify("Cannot open classfile: no active JDTLS client", vim.log.levels.ERROR)
    end
  end

end

return M
