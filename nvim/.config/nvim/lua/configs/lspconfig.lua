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
  pyright = {},
  jsonls = {},
  ts_ls = {
    init_options = {
      preferences = {
        disableSuggestions = true,
        moduleResolution = "node",
      },
    },
  },
  -- jdtls = {
  --   cmd = { vim.fn.stdpath "data" .. "/mason/bin/jdtls" },
  --   root_dir = require("lspconfig.util").root_pattern(".git", "mvnw", "gradlew"),
  -- },
}

for name, opts in pairs(servers) do
  opts.on_init = nvlsp.on_init
  opts.on_attach = nvlsp.on_attach
  opts.capabilities = nvlsp.capabilities

  require("lspconfig")[name].setup(opts)
end
--
-- lspconfig.pyright.setup { blabla}
--

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("configs.jdtls").setup()
  end,
})
