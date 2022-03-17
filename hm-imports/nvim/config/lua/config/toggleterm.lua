vim.cmd 'set hidden'

require('toggleterm').setup {
  direction = 'window',
  open_mapping = [[<c-n>]],
}
local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new {
	cmd = "lazygit",
	hidden = true,
	direction = 'float'
}

local pipeline = Terminal:new {
	cmd = "glab ci view",
	hidden = true,
	direction = 'float'
}

local createIssue = Terminal:new {
	cmd = "glab issue create",
	hidden = true,
	direction = 'float'
}

local viewTasks = Terminal:new {
	cmd = "pter ~/Nextcloud/todo.txt",
	hidden = true,
	direction = 'float'
}

function _createIssue_toggle() 
	createIssue:toggle()
end

function _pipeline_toggle() 
	pipeline:toggle()
end

function _lazygit_toggle() 
	lazygit:toggle()
end

function _tasks_toggle() 
	viewTasks:toggle()
end
