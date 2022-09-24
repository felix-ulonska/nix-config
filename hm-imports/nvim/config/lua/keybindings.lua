local map = require('utils').map

vim.g.mapleader = ' '
map {'n', '<leader>a', '<Plug>(coc-codeaction-selected)'}
map {'i', 'jk', '<esc>', noremap = false}

-- COC magic tab
vim.cmd 'source ~/.config/nvim/tab-magic-coc.vim'

map {'n', 'gd', '<Plug>(coc-definition)', noremap = false}
map {'n', 'gt', '<Plug>(coc-type-definition)', noremap = false}
map {'n', 'gi', '<Plug>(coc-implementation)', noremap = false}
map {'n', 'gr', '<Plug>(coc-references)', noremap = false}

map {'n', '<leader>rn', '<Plug>(coc-rename)'}

map {'n', '<leader>ac', '<Plug>(coc-codeaction)'}

-- map {'n', '<leader>a', ':<C-u>CocList diagnostics<cr>'}
map {'n', '<leader>o', ':<C-u>CocList outline<cr>'}
map {'n', '<leader>c', ':<C-u>CocList commands<cr>'}

-- Open Navtree
map {'n', '<leader>e', ':CocCommand explorer<CR>'}
map {'n', '<leader>b', ':CocCommand explorer --preset buffer<CR>'}
-- FZF
map {'n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>'}
map {'n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>'}
map {'n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>'}

-- buffer
map {'n', '<C-L>', ':BufferNext<CR>'}
map {'n', '<C-H>', ':BufferPrevious<CR>'}
map {'n', '<C-X>', ':BufferClose<CR>'}
map {'n', '<C-J>', ':BufferMovePrevious<CR>'}
map {'n', '<C-K>', ':BufferMoveNext<CR>'}
map {'n', '<C-P>', ':BufferPin<CR>'}

-- terminal
-- Open Temrinal defined in config/toggleterm.lua
-- vim.cmd 'autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-m> <Cmd>exe v:count1 . "ToggleTerm"<CR>'
-- map {'n', '<C-m>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>'}
-- map {'t', '<C-m>', ':ToggleTerm'}
map {'t', '<C-q>', '<C-\\><C-n>'}

-- open lazygit
map {"n", "<leader>l", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true}}
map {"n", "<leader>p", "<cmd>lua _pipeline_toggle()<CR>", {noremap = true, silent = true}}
map {"n", "<leader>i", "<cmd>lua _createIssue_toggle()<CR>", {noremap = true, silent = true}}
map {"n", "<leader>t", "<cmd>lua _tasks_toggle()<CR>", {noremap = true, silent = true}}

map {"n", "<leader>w", ":HopWord<CR>"}
map {"n", "<leader>s", ":HopLine<CR>"}
