vim.pack.add({ "https://github.com/Ray-D-Song/inlay-hint-trim.nvim" })

require("inlay-hint-trim").setup({
	clients = {
		["tsc"] = true,
	},
})
