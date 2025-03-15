local M = {}

local function get_jdtls_paths()
  local mason_registry = require("mason-registry")
  local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

  return {
    jdtls_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    jdtls_config = jdtls_path .. "/config_linux", -- Change if needed
  }
end

M.setup = function()
  local jdtls = require("jdtls")
  local paths = get_jdtls_paths()

  if paths.jdtls_jar == "" then
    vim.notify("JDTLS launcher JAR not found!", vim.log.levels.ERROR)
    return
  end

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
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      paths.jdtls_jar,
      "-configuration",
      paths.jdtls_config,
      "-data",
      vim.fn.expand("~/.cache/jdtls/workspace/") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
    },
    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
      },
    },
    init_options = {
      bundles = {},
    },
  }

  jdtls.start_or_attach(config)
end

return M
