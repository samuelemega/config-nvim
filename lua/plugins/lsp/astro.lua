local M = {}

function M.setup(capabilities)
	vim.lsp.config.astro = {
		capabilities = capabilities,
		settings = {},
	}
end

return M
