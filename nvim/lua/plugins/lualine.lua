vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

require("lualine").setup({
	options = {
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "b:gitsigns_head", icon = "" } },
		lualine_c = {
            -- stylua: ignore
			{
				"project", format = "name", no_project = nil, separator = " ", enclose_pair = nil,
                color = function() return { fg = Snacks.util.color("Directory") } end
            },
            -- stylua: ignore
			{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            -- stylua: ignore
			{ "filename", path = 1, separator = "", color = function() return { fg = Snacks.util.color("Normal") } end },
            -- stylua: ignore
			{
                function() return vim.b.gitsigns_blame_line or "" end,
                cond = function() return vim.b.gitsigns_blame_line ~= nil end,
                color = function() return { fg = Snacks.util.color("Comment") } end,
                padding = { left = 1, right = 0 },
            },
		},
		lualine_x = {
			-- stylua: ignore
			{
				function() return require("noice").api.status.command.get() end,
				cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
				color = function() return { fg = Snacks.util.color("Statement") } end,
                separator = ""
			},
			-- stylua: ignore
			{
				function() return require("noice").api.status.mode.get() end,
				cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
				color = function() return { fg = Snacks.util.color("Constant") } end,
			},
			{
				"diff",
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				},
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end,
			},
		},
		lualine_y = {
			{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},
		lualine_z = {
			function()
				return " " .. os.date("%R")
			end,
		},
	},
})
