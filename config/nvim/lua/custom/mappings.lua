---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },

    ["<A-s>"] = {"<cmd> Gwrite <CR>"},
    ["<A-k>"] = {"<cmd> G commit <CR>"},
    ["<A-p>"] = {"<cmd> G push <CR>"},

    --  format with conform
  --   ["<leader>fm"] = {
  --     function()
  --       require("conform").format()
  --     end,
  --     "formatting",
  --   }
  --
  },
  i = {
    ["<A-s>"] = {"<ESC> <cmd> Gwrite <CR>"},
    ["<A-k>"] = {"<ESC> <cmd> G commit <CR>"},
    ["<A-p>"] = {"<ESC> <cmd> G push <CR>"},
  },
}

-- more keybinds!

return M
