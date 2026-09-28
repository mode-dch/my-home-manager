vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/scalameta/nvim-metals",
})

local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "off"
-- Coursier's metals launcher only forwards JVM flags prefixed with -J.
-- JavacMtags needs these exports on Java 16+ or completion resolve crashes the server.
-- remove once coursier apps new version is released
metals_config.cmd = {
	"metals",
	"-J--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
	"-J--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
	"-J--add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
	"-J--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED",
	"-J--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED",
}
metals_config.settings = {
	verboseCompilation = true,
	superMethodLensesEnabled = true,
	inlayHints = {
		inferredTypes = { enable = true },
		implicitArguments = { enable = true },
		implicitConversions = { enable = true },
		typeParameters = { enable = true },
		hintsInPatternMatch = { enable = true },
		hintsXRayMode = { enable = true },
	},
	testUserInterface = "Test Explorer",
}
metals_config.on_attach = function()
	require("metals").setup_dap()
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
	pattern = { "scala", "sbt", "java" },
	callback = function()
		require("metals").initialize_or_attach(metals_config)
	end,
})

-- stylua: ignore start
require("which-key").add({"<leader>m", group = "metals" })

vim.keymap.set("n", "<leader>me", function() require("metals").commands() end, { desc = "Metals commands" })
vim.keymap.set("n", "<leader>mc", function() require("metals").compile_cascade() end, { desc = "Metals compile cascade" })
vim.keymap.set("n", "<leader>mh", function() require("metals").hover_worksheet() end, { desc = "Metals hover worksheet" })
-- stylua: ignore end
