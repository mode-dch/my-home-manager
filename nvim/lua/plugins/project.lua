vim.pack.add({
	"https://github.com/DrKJeff16/project.nvim",
})

require("project").setup({
	manual_mode = true,
})

vim.keymap.set("n", "<leader>cp", "<Cmd>Project root<CR>", { desc = "Set Project Root" })
