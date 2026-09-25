local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp-attach"),
	callback = function(event)
		local map = function(keys, func, desc, mode, opts)
			opts = opts or {}
			opts.buffer = event.buf
			opts.desc = desc
			vim.keymap.set(mode or "n", keys, func, opts)
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		local supports = function(method)
			return client:supports_method(method, event.buf)
		end

		map("K", vim.lsp.buf.hover, "Hover")

		if supports("textDocument/signatureHelp") then
			map("gK", vim.lsp.buf.signature_help, "Signature Help")
			map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
		end

		if supports("textDocument/codeAction") then
			map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
		end

		if supports("textDocument/codeLens") then
			map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
			map("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
		end

		if supports("textDocument/rename") then
			map("<leader>cr", vim.lsp.buf.rename, "Rename")
		end

		if supports("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end
	end,
})

---@type table<string, vim.lsp.Config>
local servers = {
	pyrefly = {
		settings = {
			python = {
				pyrefly = {
					displayTypeErrors = "force-on",
				},
			},
		},
	},
	ruff = {
		on_attach = function(client)
			client.server_capabilities.hoverProvider = false
		end,
	},
	stylua = {}, -- Used to format Lua code
	tsc = {},
	oxlint = {
		root_dir = function(bufnr, on_dir)
			-- prefer the top-level oxlint config if it exists (monorepo support)
			local git = vim.fs.root(bufnr, ".git")
			local markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
			local root = git and vim.fs.root(git, markers) or vim.fs.root(bufnr, markers)
			if root then
				on_dir(root)
			end
		end,
		settings = {
			fixKind = "all",
		},
	},
	metals = {}, -- install metals outside of mason
	nil_ls = {},
	marksman = {},
	-- Special Lua Config, as recommended by neovim help docs
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
			client.config.settings.Lua = vim.tbl_deep_extend("force", current_settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					--  See https://github.com/neovim/nvim-lspconfig/issues/3189
					library = vim.api.nvim_get_runtime_file("", true),
				},
			})
		end,
		---@type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
}

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

-- Automatically install LSPs and related tools to stdpath for Neovim
require("mason").setup({})

-- Translates between nvim-lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server)
require("mason-lspconfig").setup({
	automatic_enable = false, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
})

-- Ensure the servers and tools above are installed
local ensure_installed = vim.tbl_filter(function(name)
	return name ~= "metals"
end, vim.tbl_keys(servers or {}))
vim.list_extend(ensure_installed, {
	-- Formatters and other tools that are not LSP servers
	"oxfmt",
	"markdownlint-cli2",
	"markdown-toc",
	"prettier",
	"js-debug-adapter",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end
