return {
  { "CodesWithRobi/stylize.nvim", -- My own plugin
    ft = {"", "text"},
    config = function()
      require("stylize").setup()
    end
  },
  {
    --"CodesWithRobi/qfsearch.nvim",
    --
    dir = "~/Projects/qfsearch.nvim", -- Path to where you created the folder
    name = "qfsearch",
    opts = {
      auto_open = true, -- Automatically open the quickfix window if matches are found
    },
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
