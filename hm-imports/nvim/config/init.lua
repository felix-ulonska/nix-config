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
require('lualine').setup {
	options = {
		theme = 'auto'
	}
}


vim.cmd [[
	set guifont=agave\ Nerd\ Font\ Mono:h16
]]

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
}

vim.cmd [[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
]]

require("jester").setup {
	cmd = "npx jest -t '$result' -- $file", -- run command
}
