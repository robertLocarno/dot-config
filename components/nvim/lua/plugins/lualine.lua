-- The status line!

return {
	'nvim-lualine/lualine.nvim',
	enabled = true,
	opts = function(_, opts)
		opts.icons_enabled = true
		opts.theme = 'auto'
		opts.sections = {
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "encoding", "filetype", "lsp_status" } -- I removed "encoding" here and added "lsp_status"
		}

		return opts
	end,
}

