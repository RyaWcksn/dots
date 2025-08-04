require('options.autocmd')
require('options.statusline')
require('options.winbar')
require('options.netrw')


local o = vim.o
local g = vim.g

o.completeopt = "menuone,noselect"
o.hlsearch = false
o.undofile = true
o.mouse = "a"
o.signcolumn = "yes"
o.foldenable = false
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.number = true
o.relativenumber = true
o.foldcolumn = "0"   -- <string> 'auto' or number of columns to use for the fold column
o.foldenable = false -- <true|false> all folds closed on buffer open? (zi to toggle)
o.foldtext = "v:lua.myfolds()"


vim.opt.termguicolors = true
vim.o.termguicolors = true

vim.opt.clipboard = "unnamed"
vim.opt.clipboard:append { "unnamedplus" }

vim.wo.wrap = false


g.mapleader = " "

function _G.myfolds()
	local line = vim.fn.getline(vim.v.foldstart)
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	return line .. " --------- " .. line_count .. " lines "
end

-- Fold
local vim = vim
local api = vim.api
local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command('augroup ' .. group_name)
		api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(
				vim.iter({ 'autocmd', def }):flatten():totable(),
				' '
			)
			api.nvim_command(command)
		end
		api.nvim_command('augroup END')
	end
end

local autoCommands = {
	open_folds = {
		{ "BufReadPost,FileReadPost", "*", "normal zR" }
	}
}

M.nvim_create_augroups(autoCommands)

local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"matchit",
	"matchparen",
	"tar",
	"tarPlugin",
	"rrhelper",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end
