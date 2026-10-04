-- ==========================================================================
-- LSP, MASON, NAVIC & DIAGNOSTICS
-- ==========================================================================

-- Servers to enable. Mason installs all of these except vtsls and
-- shopify_theme_ls, which are installed separately (npm / Shopify CLI).
local servers = {
	"lua_ls",
	"basedpyright",
	"vtsls",
	"html",
	"cssls",
	"jsonls",
	"eslint",
	"emmet_ls",
	"shopify_theme_ls",
	"tailwindcss",
}

local mason_servers = {
	"lua_ls",
	"basedpyright",
	"html",
	"cssls",
	"emmet_ls",
	"jsonls",
	"eslint",
	"tailwindcss",
}

-- --------------------------------------------------------------------------
-- Mason
-- --------------------------------------------------------------------------

local ok_mason, mason = pcall(require, "mason")
if ok_mason then
	mason.setup()
end

local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
if ok_mason_lsp then
	mason_lsp.setup({
		ensure_installed = mason_servers,
		automatic_enable = false, -- enabled explicitly below
	})
end

-- --------------------------------------------------------------------------
-- Diagnostics
-- --------------------------------------------------------------------------

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
		source = "if_many",
	},
	signs = {
		text = {
			[severity.ERROR] = "󰅚 ",
			[severity.WARN] = "󰀪 ",
			[severity.HINT] = "󰌶 ",
			[severity.INFO] = "󰋽 ",
		},
	},
	float = { source = "if_many" },
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- --------------------------------------------------------------------------
-- Navic (breadcrumbs). auto_attach picks one server per buffer, so
-- multiple symbol providers (e.g. html + emmet) don't conflict.
-- --------------------------------------------------------------------------

local ok_navic, navic = pcall(require, "nvim-navic")
if ok_navic then
	navic.setup({
		lsp = {
			auto_attach = true,
			preference = { "vtsls" },
		},
		highlight = true,
		separator = " > ",
	})
end

-- --------------------------------------------------------------------------
-- LspAttach
-- --------------------------------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(args)
		-- Neovim 0.11+ already provides grn, gra, grr, gri, gO, K, [d, ]d.
		vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, {
			buffer = args.buf,
			desc = "Go to type definition",
		})
	end,
})

-- --------------------------------------------------------------------------
-- Server configs
-- --------------------------------------------------------------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				-- Only the Neovim runtime: indexing every plugin on the
				-- runtimepath makes lua_ls slow to start.
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("emmet_ls", {
	filetypes = {
		"html",
		"css",
		"scss",
		"sass",
		"less",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"liquid",
	},
})

vim.lsp.config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"liquid",
	},
	init_options = {
		userLanguages = { liquid = "html" },
	},
})

vim.lsp.config("cssls", {
	settings = {
		css = {
			validate = true,
			lint = { unknownAtRules = "ignore" },
		},
	},
})

vim.lsp.enable(servers)
