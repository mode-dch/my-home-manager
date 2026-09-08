vim.pack.add({
	"https://github.com/folke/noice.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
})

require("noice").setup({
	lsp = {
		signature = {
			auto_open = { enabled = false },
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	routes = {
		{
			filter = {
				event = "msg_show",
				any = {
					{ find = "%d+L, %d+B" },
					{ find = "; after #%d+" },
					{ find = "; before #%d+" },
				},
			},
			view = "mini",
		},
		{
			filter = {
				event = "notify",
				find = "neocursor ready",
			},
			opts = { skip = true },
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		lsp_doc_border = true,
	},
})

-- vibe-coded hacks from github to fix noice confirm prompt, remove once upstream fixes are merged
local M = require("noice.ui.cmdline")
local State = require("noice.ui.state")
local Manager = require("noice.message.manager")
local Hacks = require("noice.util.hacks")

M.message_in = false

local original_show = M.on_show

M.on_show = function(event, content, pos, firstc, prompt, indent, level)
	M.message_in = true

	if M.confirm_message and State.skip(event, content, pos, firstc, prompt, indent, level) then
		return
	end

	if M.confirm_message then
		M.skipped = true

		local message = M.confirm_message
		-- put the [Y]es/(N)o/(C)ancel prompt on its own line
		message:newline()
		message:append(prompt)
		Manager.add(message)

		-- the dialog places no cursor of its own, so stop the real one
		-- from blinking in the buffer behind it
		Hacks.hide_cursor()

		M._on_hide = function()
			vim.schedule(function()
				Manager.remove(message)
				State.clear(event)
				State.clear(message.event)
				M.confirm_message = nil
				M.skipped = false
				Hacks.show_cursor()
			end)
		end

		return
	end

	original_show(event, content, pos, firstc, prompt, indent, level)
end

local original_hide = M.on_hide

M.on_hide = function(event, level)
	M.message_in = false

	if M._on_hide then
		vim.defer_fn(function()
			if not M.message_in then
				M._on_hide()
				M._on_hide = nil
			end
		end, 10)

		return
	end

	-- safety net: no-op unless the confirm branch hid it
	Hacks.show_cursor()
	original_hide(event, level)
end

-- stylua: ignore start
vim.keymap.set({ "n" }, "<leader>sn", "", { desc = "+noice" })
vim.keymap.set("c", "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, { desc = "Redirect Cmdline" })
vim.keymap.set("n", "<leader>snl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
vim.keymap.set("n", "<leader>snh", function() require("noice").cmd("history") end, { desc = "Noice History" })
vim.keymap.set("n", "<leader>sna", function() require("noice").cmd("all") end, { desc = "Noice All" })
vim.keymap.set("n", "<leader>snd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" })
vim.keymap.set("n", "<leader>snt", function() require("noice").cmd("pick") end, { desc = "Noice Picker" })
vim.keymap.set({ "i", "n", "s" }, "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, { silent = true, expr = true, desc = "Scroll Forward" })
vim.keymap.set({ "i", "n", "s" }, "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, { silent = true, expr = true, desc = "Scroll Backward" })
-- stylua: ignore end
