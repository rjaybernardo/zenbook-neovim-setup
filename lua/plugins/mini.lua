-- ==========================================================================
-- MINI.NVIM
-- ==========================================================================

local ok_icons, icons = pcall(require, "mini.icons")
if ok_icons then
	icons.setup()
	icons.mock_nvim_web_devicons()
end

local ok_comment, comment = pcall(require, "mini.comment")
if ok_comment then
	comment.setup({
		-- Non-overlapping mappings so which-key does not report
		-- the default `gc` / `gcc` prefix relationship.
		mappings = {
			comment = "gC",
			comment_line = "gL",
			comment_visual = "gC",
			textobject = "gT",
		},
	})

	-- VS Code style Ctrl+/ (<C-_> is what most terminals send)
	for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
		vim.keymap.set("n", lhs, "gL", { remap = true, desc = "Toggle comment" })
		vim.keymap.set("v", lhs, "gC", { remap = true, desc = "Toggle comment" })
	end
end

for _, mod in ipairs({ "pairs", "statusline", "tabline" }) do
	local ok, m = pcall(require, "mini." .. mod)
	if ok then
		m.setup()
	end
end

local ok_indent, indentscope = pcall(require, "mini.indentscope")
if ok_indent then
	indentscope.setup({
		symbol = "│",
		options = { try_as_border = true },
	})
end
