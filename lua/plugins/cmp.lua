-- ==========================================================================
-- NVIM-CMP
-- ==========================================================================

local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local has_luasnip, luasnip = pcall(require, "luasnip")
local has_icons, icons = pcall(require, "mini.icons")

-- Jump through snippet placeholders first, then cycle completion items.
local function tab(direction)
	return cmp.mapping(function(fallback)
		if has_luasnip and luasnip.locally_jumpable(direction) then
			luasnip.jump(direction)
		elseif cmp.visible() then
			if direction > 0 then
				cmp.select_next_item()
			else
				cmp.select_prev_item()
			end
		else
			fallback()
		end
	end, { "i", "s" })
end

cmp.setup({
	completion = {
		autocomplete = { cmp.TriggerEvent.TextChanged },
	},

	snippet = {
		expand = function(args)
			if has_luasnip then
				luasnip.lsp_expand(args.body)
			else
				vim.snippet.expand(args.body)
			end
		end,
	},

	formatting = {
		format = function(_, item)
			if has_icons then
				local icon = icons.get("lsp", item.kind)
				if icon then
					item.kind = icon .. " " .. item.kind
				end
			end
			return item
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = tab(1),
		["<S-Tab>"] = tab(-1),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "luasnip", priority = 750 },
		{ name = "path", priority = 500 },
		{ name = "buffer", priority = 250 },
	}),
})
