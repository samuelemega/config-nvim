local M = {}

-- single source of truth for enabled servers
local SERVER_MODULES = {
	vtsls = "plugins.lsp.typescript",
	eslint = "plugins.lsp.eslint",
	astro = "plugins.lsp.astro",
}

function M.names()
	local out = {}
	for name, _ in pairs(SERVER_MODULES) do
		table.insert(out, name)
	end
	table.sort(out)
	return out
end

function M.setup(capabilities)
	for _, mod in pairs(SERVER_MODULES) do
		local ok, server = pcall(require, mod)
		if ok and type(server) == "table" and type(server.setup) == "function" then
			server.setup(capabilities)
		end
	end
end

return M
