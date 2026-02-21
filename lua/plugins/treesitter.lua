return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {},
			},
		},

		opts = {
			ensure_installed = {
				"typescript",
				"javascript",
				"tsx",
				"lua",
				"json",
				"yaml",
				"astro",
			},
			sync_install = false,
			auto_install = true,

			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = { enable = true },

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
				},
			},
		},
	},
}
