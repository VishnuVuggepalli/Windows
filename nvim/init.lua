-- ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
-- ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
-- ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
-- ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
-- ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
-- ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝

-- TODO:
-- try  sindrets/winshift.nvim
-- check out vim.quickui
-- folke/todo-comments.nvim
-- {"folke/flash.nvim"}
-- check out sidebar-nvim/sidebar.nvim
-- check gbprod/yanky.nvim
-- vim.loader.enable()

--require("vim._extui").enable({})

-- general configurations
require("options")

-- Plugins
require("plugins")
local config_path = vim.fn.stdpath("config")


-- Functions, Commands, Autocommands
vim.cmd("source " .. config_path .. "/viml/commands.vim")
require("autocommands")
-- vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Mappings
vim.cmd("source " .. config_path .. "/viml/mappings.vim")
-- Diagnostics
require("diagnostics-config")

-- UI
require("win_ui_input")

-- Other
require("grep")
-- require("marks")
require("searchyank")
require("session")
require("hex")
