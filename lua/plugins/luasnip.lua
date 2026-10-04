-- ==========================================================================
-- LUASNIP
-- ==========================================================================

local ok, luasnip = pcall(require, "luasnip")
if not ok then
	return
end

luasnip.config.setup({
	history = true,
	update_events = "TextChanged,TextChangedI",
})

local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

-- friendly-snippets for everything except JS/TS, which use our own set.
require("luasnip.loaders.from_vscode").lazy_load({ exclude = js_filetypes })

local js_snippets = require("snippets.javascript")
for _, ft in ipairs(js_filetypes) do
	luasnip.add_snippets(ft, js_snippets)
end
