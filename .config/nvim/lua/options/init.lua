local opt = vim.opt
local g = vim.g
opt.completeopt = "menuone,noselect"

opt.fillchars = { eob = " " }

-- local hour = tonumber(os.date("%H"))

-- if hour >= 22 or hour < 6 then
-- 	vim.opt.background = "light"
-- 	vim.cmd("colorscheme base16-one-light")
-- else
-- 	vim.opt.background = "dark"
-- 	vim.cmd("colorscheme base16-ayu-dark")
-- end
vim.opt.termguicolors = true

vim.cmd("colorscheme base16-ayu-dark")
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.notify = require("notify")

g.markdown_fenced_languages = { 'html', 'python', 'lua', 'vim', 'typescript', 'javascript' }

opt.hlsearch = false
opt.undofile = true
opt.ruler = false
opt.hidden = true
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 250 -- update interval for gitsigns
opt.timeoutlen = 400
opt.clipboard = "unnamed"
opt.clipboard:append { "unnamedplus" }
opt.foldenable = false
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.number = true
opt.numberwidth = 2
opt.relativenumber = false
opt.colorcolumn = "90"
vim.wo.wrap = false

opt.fillchars = { fold = "·" } -- see `:h 'fillchars'`
opt.foldcolumn = "0"           -- <string> 'auto' or number of columns to use for the fold column
opt.foldenable = false         -- <true|false> all folds closed on buffer open? (zi to toggle)
opt.foldtext = "v:lua.myfolds()"

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

g.gitblame_enabled = 0
g.gitblame_message_template = "<summary> • <date> • <author>"
g.gitblame_highlight_group = "LineNr"

vim.g.gist_open_browser_after_post = 1
