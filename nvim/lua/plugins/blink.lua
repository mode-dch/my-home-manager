require("utils").update_handler("LuaSnip", { "make", "install_jsregexp" })

vim.pack.add({
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.*") },
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("luasnip").setup({})
require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-y>"] = { "select_and_accept" },
	},

	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
			},
		},
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		ghost_text = { enabled = true },
	},

	sources = {
		default = { "lsp", "path", "snippets" },
	},

	snippets = { preset = "luasnip" },

	fuzzy = { implementation = "prefer_rust_with_warning" },
})
