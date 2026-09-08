require("utils").update_handler("neocursor.nvim", {
	"uv",
	"run",
	"--with",
	"httpx[http2]",
	"python",
	"-c",
	"import httpx",
})

vim.pack.add({ "https://github.com/teocns/neocursor.nvim" })

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		require("neocursor").setup({
			show_hints = false,
		})
	end,
})
