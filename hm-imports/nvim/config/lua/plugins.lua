-- need to load config for coc before load 
require('config/coc')
require('config/explorer')
require('config/barbar')

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

	-- use 'dart-lang/dart-vim-plugin'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }
  -- coc
  use {'neoclide/coc.nvim',
    branch = 'release',
  }

  -- gui
  use {
    'glepnir/galaxyline.nvim',
      branch = 'main',
      -- your statusline
      config = function() require'config/galaxyline' end,
      -- some optional icons
      requires = {{'kyazdani42/nvim-web-devicons', opt = true}, 'airblade/vim-gitgutter' }
  }
  
  -- bar
  use 'romgrk/barbar.nvim'
	--
	-- vim-fugite
  use 'tpope/vim-fugitive'
	--
  -- 
  -- indent blankline
  -- use 'lukas-reineke/indent-blankline.nvim'
	
	-- use 'NoahTheDuke/vim-just'

  -- fzf
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- color
  use 'folke/tokyonight.nvim'

  -- BLAME
  use 'APZelos/blamer.nvim'

  -- terminal Term
  use 'akinsho/toggleterm.nvim'

	-- -- mutli line
	-- use {'mg979/vim-visual-multi', branch = "master"}
	-- 
	-- -- nginx
  -- use 'chr4/nginx.vim'

	-- -- latex
	-- use 'lervag/vimtex'
	use 'LnL7/vim-nix'
end)
