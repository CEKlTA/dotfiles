--[[ Globals ]]--

local globals = {
	autoformat = false,
	have_nerd_font = false,
	netrw_banner = 0,
	netrw_hide = 0,
	netrw_liststyle = 3,
	mapleader = " ",
	maplocalleader = " ",
	netrw_sizestyle = "H",
	netrw_timefmt = "%a %d-%m-%Y  %I-%M-%S",
}

for key, value in pairs(globals) do
	vim.g[key] = value
end

--[[ Options ]]--

local opts = {
	number = true,
	relativenumber = true,
	breakindent = true,
	undofile = true,
	ignorecase = true,
	smartcase = true,
	splitright = true,
	cursorline = true,
	termguicolors = true,
	wildmenu = true,
	showmode = false,
	hlsearch = false,
	-- list = false,
	updatetime = 250,
	timeoutlen = 300,
	scrolloff = 15,
	shiftwidth = 4,
	tabstop = 4,
	path = vim.opt.path + "**",
	mouse = "a",
	clipboard = "unnamedplus",
	belloff = "all",
	inccommand = "split",
	-- signcolumn = "yes",
	-- listchars = { tab = "» ", trail = "·", nbsp = "␣" },
}

for key, value in pairs(opts) do
	vim.opt[key] = value
end

--[[ Keymaps ]]--

local keymaps = {
	{ "n", "<leader>E",  vim.cmd.Exp,                      { desc = "Open file [E]xplorer" } },
	{ "n", "<leader>bp", vim.cmd.bprevious,                { desc = "Switch to previous buffer" } },
	{ "n", "<leader>bn", vim.cmd.bnext,                    { desc = "Switch to next buffer" } },
	{ "n", "<leader>bd", vim.cmd.bdelete,                  { desc = "Delete current buffer" } },
	{ "n", "<leader>t", vim.cmd.terminal,                 { desc = "Open terminal" } },
	{ "n", "<leader>bb", ":buffers<CR>:b ",                { desc = "Display all buffers" } },
	{ "v", "J",          ":m '>+1<CR>gv=gv" },
	{ "v", "K",          ":m '<-2<CR>gv=gv" },

	{ "n", "[d",         vim.diagnostic.goto_prev,         { desc = "Go to previous [D]iagnostic message" } },
	{ "n", "]d",         vim.diagnostic.goto_next,         { desc = "Go to next [D]iagnostic message" } },
	{ "n", "<leader>e",  vim.diagnostic.open_float,        { desc = "Show diagnostic [E]rror messages" } },
	{ "n", "<leader>q",  vim.diagnostic.setloclist,        { desc = "Open diagnostic [Q]uickfix list" } },
	{ "t", "<Esc><Esc>", "<C-\\><C-n>",                    { desc = "Exit terminal mode" } },

	{ "n", "<left>",     '<cmd>echo "Use h to move!!"<CR>' },
	{ "n", "<right>",    '<cmd>echo "Use l to move!!"<CR>' },
	{ "n", "<up>",       '<cmd>echo "Use k to move!!"<CR>' },
	{ "n", "<down>",     '<cmd>echo "Use j to move!!"<CR>' },

	{ "n", "<C-h>",      "<C-w><C-h>",                     { desc = "Move focus to the left window" } },
	{ "n", "<C-l>",      "<C-w><C-l>",                     { desc = "Move focus to the right window" } },
	{ "n", "<C-j>",      "<C-w><C-j>",                     { desc = "Move focus to the lower window" } },
	{ "n", "<C-k>",      "<C-w><C-k>",                     { desc = "Move focus to the upper window" } },
}

for _, map in pairs(keymaps) do
	local mode, lhs, rhs, opts = map[1], map[2], map[3], map[4] or {}
	vim.keymap.set(mode, lhs, rhs, opts)
end

--[[ Autocmds ]]--

local autocmds = {
	{ "TextYankPost", "Highlight when yanking (copying) text", function() vim.highlight.on_yank() end },
	--	{ "BufEnter",     "Update the file so diagnostics show upon entenring a buffer", function() vim.cmd("e") end }
}

for _, map in pairs(autocmds) do
	local event, desc, callback = map[1], map[2], map[3]
	vim.api.nvim_create_autocmd(event, {
		desc = desc,
		callback = callback
	})
end

--[[ Package Manager: lazy.nvim ]]--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"savq/melange-nvim",
		init = function()
			vim.cmd.colorscheme("melange")
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"xml",
				"yaml",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = {
					"ruby",
				},
			},
			ident = {
				enable = true,
				disable = {
					"ruby",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
	},
	{
		"williamboman/mason.nvim",
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/nvim-cmp",
	},
	{
		"L3MON4D3/LuaSnip",
	},
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = '',
				desc = "[F]ormat buffer",
			},
		},
	},
})

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

require("mason").setup({})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})
