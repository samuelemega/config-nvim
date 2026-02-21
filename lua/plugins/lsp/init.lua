return {
	-- Mason (installer)
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonLog" },
		opts = {},
	},

	-- Mason bridge to lspconfig
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = function()
			local servers = require("plugins.lsp.servers").names()
			return { ensure_installed = servers }
		end,
	},

	-- LSP core (Neovim 0.11+)
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- global attach behavior (keymaps + save hooks)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(ev)
					local bufnr = ev.buf
					local opts = { buffer = bufnr, remap = false }
					local map = vim.keymap.set

					map("n", "gd", vim.lsp.buf.definition, opts)
					map("n", "K", vim.lsp.buf.hover, opts)
					map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
					map("n", "<leader>vd", vim.diagnostic.open_float, opts)
					map("n", "<leader>vv", vim.diagnostic.setloclist, opts)
					map("n", "[d", vim.diagnostic.goto_next, opts)
					map("n", "]d", vim.diagnostic.goto_prev, opts)
					map("n", "<leader>vca", vim.lsp.buf.code_action, opts)
					map("n", "<leader>vrr", vim.lsp.buf.references, opts)
					map("n", "<leader>vrn", vim.lsp.buf.rename, opts)
					map("n", "<leader>vh", vim.lsp.buf.signature_help, opts)
					map("n", "ca", vim.lsp.buf.code_action, opts)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end

					-- eslint: fix-all on save; skip formatting
					if client.name == "eslint" then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("UserEslintFixAll:" .. bufnr, { clear = true }),
							buffer = bufnr,
							command = "EslintFixAll",
						})
						return
					end

					-- format on save for other servers (if supported)
					if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("UserLspFormatOnSave:" .. bufnr, { clear = true }),
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									async = false,
									filter = function(c)
										return c.name ~= "eslint"
									end,
								})
							end,
						})
					end
				end,
			})

			-- load per-language server configs
			require("plugins.lsp.servers").setup(capabilities)

			-- enable/start servers when matching buffers open
			vim.lsp.enable(require("plugins.lsp.servers").names())
		end,
	},
}
