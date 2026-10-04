-- ==========================================================================
-- AUTOCOMMANDS
-- ==========================================================================

local augroup = function(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- Transparent diagnostic virtual text. Re-applied on every colorscheme
-- change, otherwise switching themes would reset it.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup("diagnostic_hl"),
	callback = function()
		for _, level in ipairs({ "Error", "Warn", "Info", "Hint" }) do
			local name = "DiagnosticVirtualText" .. level
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			hl.bg = nil
			vim.api.nvim_set_hl(0, name, hl)
		end
	end,
})

-- LazyGit: let <Esc> reach lazygit instead of leaving terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup("lazygit_esc"),
	pattern = "term://*lazygit*",
	callback = function()
		vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = true, nowait = true })
		vim.keymap.set("t", "<Esc><Esc>", "<Esc><Esc>", { buffer = true, nowait = true })
	end,
})
