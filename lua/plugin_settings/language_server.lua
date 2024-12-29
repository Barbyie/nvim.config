local language_server = {}

-- local mason_registry = require("mason-registry")

local on_attach = function(client, bufnr)
	local opts = {
		noremap = true,
		silent = true,
		buffer = bufnr,
	}

	local keymap = vim.keymap

	keymap.set("n", "<leader>fd", ":Lspsaga finder<CR>", opts)
	keymap.set("n", "<leader>gd", ":Lspsaga peek_definition<CR>", opts)
	keymap.set("n", "<leader>gD", ":Lspsaga goto_definition<CR>", opts)
	keymap.set("n", "<leader>ca", ":Lspsaga code_action<CR>", opts)
	keymap.set("n", "<leader>rn", ":Lspsaga rename<CR>", opts)
	keymap.set("n", "<leader>D", ":Lspsaga show_line_diagnostics<CR>", opts)
	keymap.set("n", "<leader>d", ":Lspsaga show_cursor_diagnostics<CR>", opts)
	keymap.set("n", "<leader>pd", ":Lspsaga diagnostic_jump_prev<CR>", opts)
	keymap.set("n", "<leader>nd", ":Lspsaga diagnostic_jump_next<CR>", opts)
	keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opts)
end

language_server.default_setup = function(server_name)
	require("lspconfig")[server_name].setup({
		on_attach = on_attach,
	})
end

language_server.efm = function()
	require("lspconfig").efm.setup({
		on_attach = on_attach,
		filetypes = {
			"lua",
			"vue",
			"javascript",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				lua = {
					require("efmls-configs.linters.luacheck"),
					require("efmls-configs.formatters.stylua"),
				},
        vue = {
          require("efmls-configs.linters.eslint_d"),
					require("efmls-configs.formatters.prettier"),
        }
			},
		},
	})
end

language_server.volar = function()
	require("lspconfig").volar.setup({
		on_attach = on_attach,
		filetypes = { "vue", "javascript" },
    init_options = {
      vue = {
        hybridMode = false,
      }
    }
	})
end

-- Only enable this if your VUE project uses typescript
-- language_server.ts_ls = function()
-- 	require("lspconfig").ts_ls.setup({
-- 		on_attach = on_attach,
-- 		init_options = {
-- 			plugins = {
-- 				{
-- 					name = "@vue/typescript-plugin",
-- 					location = vim.fn.stdpath("data")
-- 						.. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
-- 					languages = { "javascript", "typescript", "vue" },
-- 				},
-- 			},
-- 		},
-- 		filetypes = {
-- 			"javascript",
-- 			"typescript",
-- 			"vue",
-- 		},
-- 	})
-- end

language_server.format_on_save = function()
	local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = lsp_fmt_group,
		callback = function(ev)
			local efm = vim.lsp.get_clients({
				name = "efm",
				bufnr = ev.buf,
			})

			if vim.tbl_isempty(efm) then
				return
			end

			vim.lsp.buf.format({
				name = "efm",
			})
		end,
	})
end

return language_server
