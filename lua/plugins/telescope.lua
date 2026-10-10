-- ==========================================================================
-- TELESCOPE
-- ==========================================================================

local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

telescope.setup({})
pcall(telescope.load_extension, "fzf") -- only if the C library has been built

local builtin = require("telescope.builtin")
local map = vim.keymap.set

map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
map("n", "<C-p>", builtin.find_files, { desc = "Quick open file" })
