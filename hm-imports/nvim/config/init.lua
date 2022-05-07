require('utils')
-- TODO find better place for this
require('config.toggleterm')
require('keybindings')

vim.g.base16_shell_path = '~/.dotfiles/output/shell/scripts/'

vim.cmd 'if has("termguicolors") \n set termguicolors\n endif'
vim.cmd 'source ~/.config/nvim/cursos-tmux.vim'
-- vim.cmd 'colorscheme base'
-- vim.g.colors_name = "base"
vim.cmd 'syntax reset'
vim.cmd [[
colorscheme base16-scheme
set background=dark
let base16colorspace=256
]]

vim.g.coc_filetype_map = {tex = "latex"}

-- vim.opt.signcolumn = 'number'
-- vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

require('telescope').setup {
	defaults = {
		file_ignore_patterns = { "node_modules" }
	}
}

require('telescope').load_extension('coc')

require('hop').setup()

require('gitsigns').setup()
require('lualine').setup()
