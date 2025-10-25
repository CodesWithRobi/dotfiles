return {
  { "CodesWithRobi/stylize.nvim", -- My own plugin
    ft = {"", "text"},
    config = function()
      require("stylize").setup()
    end
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
