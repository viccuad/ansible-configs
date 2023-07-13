return {
  {
    "NeogitOrg/neogit",
    -- setup = {
    --   use_magit_keybindings = true,
    --   sections = {
    --     unstaged = {
    --       folded = false,
    --     },
    --     staged = {
    --       folded = false,
    --     },
    --   },
    -- },
    keys = {
      { "<leader>gg", ":Neogit kind=vsplit<CR>", desc = "Open Neogit" },
    },
  },
}
