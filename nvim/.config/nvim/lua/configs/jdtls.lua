local M = {}

local function get_jdtls_paths()
  local mason_registry = require("mason-registry")
  local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
  local java_dbg_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
  local java_test_path = mason_registry.get_package("java-test"):get_install_path()

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
      },
    },
    init_options = {
      bundles = paths.bundles,
    },
    -- This on_attach will be called after the client attaches.
    on_attach = function(client, bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      vim.notify("JDTLS attached to buffer " .. bufnr)
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
    jdtls.setup_dap({ hotcodereplace = "auto" })
  end
end

return M
