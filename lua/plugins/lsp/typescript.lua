local M = {}

function M.setup(capabilities)
	vim.lsp.config.vtsls = {
		capabilities = capabilities,
		settings = {},
	}
end

return M
