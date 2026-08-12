return {
	'neovim/nvim-lspconfig',
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local M = {}
		local map = vim.keymap.set

		M.on_attach = function(_, bufnr)
			local function opts(desc)
				return { buffer = bufnr, desc = "LSP" .. desc }
			end

			map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
			map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
			map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
			map("n", "<leader>ca", vim.lsp.buf.code_action, opts "Perform Code Action")

			map("n", "<leader>lr", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, client in ipairs(clients) do
					vim.lsp.stop_client(client.id, true)
				end
				vim.defer_fn(function()
					vim.cmd("edit")
				end, 500)
			end, opts "Restart LSP client")
		end

		M.capabilities = vim.lsp.protocol.make_client_capabilities()

		M.capabilities.textDocument.completion.completionItem = {
			documentationFormat = { "markdown", "plaintext" },
			snippetSupport = true,
			preselectSupport = true,
			insertReplaceSupport = true,
			labelDetailsSupport = true,
			deprecatedSupport = true,
			commitCharactersSupport = true,
			tagSupport = { valueSet = { 1 } },
			resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			},
		}

		M.defaults = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					M.on_attach(_, args.buf)
				end,
			})

			vim.lsp.config("*", { capabilities = M.capabilities })
		end

		M.defaults()
	end
}

