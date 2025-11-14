-- local on_attach = require("nvchad.configs.lspconfig").on_attach
-- local capabilities = require("nvchad.configs.lspconfig").capabilities
--
-- local lspconfig = require "lspconfig"
--
-- -- if you just want default config for the servers then put them in a table
-- local servers = { "html", "cssls", "clangd", "pyright" }
--
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--   }
-- end
--
-- lspconfig.ts_ls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   init_options = {
--     preference
--       disableSuggestions = true,
--       moduleResolution = "node",
--     }
--   }
-- }

local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults() -- loads nvchad's defaults

local servers = {
  html = {},
  cssls = {},
  clangd = {},
  jsonls = {},
  -- ts_ls = {
  --   init_options = {
  --     preferences = {
  --       disableSuggestions = true,
  --       moduleResolution = "node",
  --     },
  --   },
  -- },
  pyright = { -- Only hovers
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          diagnosticMode = "openFilesOnly",
        },
      },
    },
    handlers = {
      ["textDocument/publishDiagnostics"] = function() end,
    },
  },
  ruff = { -- Except hovers
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
    end,
  },
  -- jdtls = {
  --   cmd = { vim.fn.stdpath "data" .. "/mason/bin/jdtls" },
  --   root_dir = require("lspconfig.util").root_pattern(".git", "mvnw", "gradlew"),
  -- },
}

for name, opts in pairs(servers) do
  -- !! Deprecated:
  -- require("lspconfig")[name].setup(opts)

  local custom_on_attach = opts.on_attach

  opts.on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    if custom_on_attach then
      custom_on_attach(client, bufnr)
    end
  end
  opts.capabilities = nvlsp.capabilities

  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
--
-- lspconfig.pyright.setup { blabla}
--

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.java",
  callback = function()
    vim.schedule(function() require("configs.jdtls").setup() end)
  end,
})
