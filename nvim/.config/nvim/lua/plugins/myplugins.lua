local overrides = require "configs.overrides"
local map = vim.keymap.set

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "configs.null-ls"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local opts = require "nvchad.configs.treesitter"
      return vim.tbl_deep_extend("force", opts, overrides.treesitter or {})
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin

  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      require("dapui").setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "configs.conform"
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      require "configs.dap"
      --   map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint at line" })
      --   map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Run or continue the debugger" })
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function(_)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },

  { "nvim-neotest/nvim-nio" },
  { "ThePrimeagen/vim-be-good" },
  { "mfussenegger/nvim-jdtls" },
  { "echasnovski/mini.nvim", version = "*" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  -- Blink plugin test
  {
    import = "nvchad.blink.lazyspec",
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
    },
    ft = "python", -- Load when opening Python files
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
    },
    opts = { -- this can be an empty lua table - just showing below for clarity.
      search = {}, -- if you add your own searches, they go here.
      options = {} -- if you add plugin options, they go here.
    },
  },
  -- {
  --   "nvim-java/nvim-java",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-java/lua-async-await",
  --     "nvim-java/nvim-java-core",
  --     "nvim-java/nvim-java-test",
  --     "nvim-java/nvim-java-dap",
  --     "MunifTanjim/nui.nvim",
  --     "neovim/nvim-lspconfig",
  --     "mfussenegger/nvim-dap",
  --     {
  --       "williamboman/mason.nvim",
  --       opts = {
  --         registries = {
  --           "github:nvim-java/mason-registry",
  --           "github:mason-org/mason-registry",
  --         },
  --       },
  --     },
  --   },
  --   config = function()
  --     -- require("java").setup {}
  --   end,
  -- },
  -- {
  --  "nvim-java/nvim-java",
  --  config = false,
  --  dependencies = {
  --    {
  --      "neovim/nvim-lspconfig",
  --      opts = {
  --        servers = {
  --          -- Your JDTLS configuration goes here
  --          jdtls = {
  --            -- settings = {
  --            --   java = {
  --            --     configuration = {
  --            --       runtimes = {
  --            --         {
  --            --           name = "JavaSE-23",
  --            --           path = "/usr/local/sdkman/candidates/java/23-tem",
  --            --         },
  --            --       },
  --            --     },
  --            --   },
  --            -- },
  --          },
  --        },
  --        setup = {
  --          jdtls = function()
  --            -- Your nvim-java configuration goes here
  --            require("java").setup({
  --              -- root_markers = {
  --              --   "settings.gradle",
  --              --   "settings.gradle.kts",
  --              --   "pom.xml",
  --              --   "build.gradle",
  --              --   "mvnw",
  --              --   "gradlew",
  --              --   "build.gradle",
  --              --   "build.gradle.kts",
  --              -- },
  --            })
  --          end,
  --        },
  --      },
  --    },
  --  },
  -- },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
