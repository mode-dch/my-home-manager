require("utils").update_handler("markdown-preview.nvim", { "npm", "install", "--prefix", "app" })

vim.g.mkdp_auto_close = 0
vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
		vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
	end,
})
