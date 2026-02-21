local M = {}

function M.setup(capabilities)
	vim.lsp.config.eslint = {
		capabilities = capabilities,
		settings = {},
	}
end

return M
