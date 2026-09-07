vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })

require("diffview").setup({
	view = {
		default = {
			disable_diagnostics = true,
		},
	},
})

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Diffview Close" })
