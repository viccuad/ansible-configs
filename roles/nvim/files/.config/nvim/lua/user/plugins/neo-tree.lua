return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<Tab>"] = "open",
      },
    },
    filesystem = {
      filtered_items = {
	    visible = false,
	    show_hidden_count = true,
	    hide_dotfiles = false,
	    hide_gitignored = false,
	    hide_by_name = {
	      '.git',
	    },
	    never_show = {},
      },
    }
  }
}
