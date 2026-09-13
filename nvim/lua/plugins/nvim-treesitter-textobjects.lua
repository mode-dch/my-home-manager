vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" })

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
})

local move = require("nvim-treesitter-textobjects.move")

-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next Function Start" })
vim.keymap.set({ "n", "x", "o" }, "]g", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next Class Start" })
vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next Parameter Start" })

vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next Function End" })
vim.keymap.set({ "n", "x", "o" }, "]G", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next Class End" })
vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.inner", "textobjects") end, { desc = "Next Parameter End" })

vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev Function Start" })
vim.keymap.set({ "n", "x", "o" }, "[g", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev Class Start" })
vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Prev Parameter Start" })

vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev Function End" })
vim.keymap.set({ "n", "x", "o" }, "[G", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Prev Class End" })
vim.keymap.set({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.inner", "textobjects") end, { desc = "Prev Parameter End" })
-- stylua: ignore end
