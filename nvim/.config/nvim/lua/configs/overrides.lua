local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "python",
    "markdown",
    "markdown_inline",
    "java",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  log_level = vim.log.levels.DEBUG,
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "js-debug-adapter",
    "typescript-language-server",
    "eslint-lsp",
    "deno",
    "prettierd",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    --python stuff
    "pyright",
    "mypy",
    "ruff",
    "black",

    --java stuff
    "jdtls",
    "java-debug-adapter",
    "java-test"
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
