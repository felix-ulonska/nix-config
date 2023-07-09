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

require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.cmd [[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
]]

require("jester").setup {
	cmd = "npx jest -t '$result' -- $file", -- run command
}
