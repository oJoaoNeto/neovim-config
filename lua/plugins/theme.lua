return{

  'catppuccin/nvim',

  name = 'catppuccin',

  event = "VimEnter",

  priority = 1000,

  config = function()

    require('catppuccin').setup({

      integrations = {
        treesitter = true,
        lsp_trouble = false,
        gitsigns = true,
        telescope = true,
        cmp = true,
        native_lsp = { enabled = true },
        dap = false,
        dap_ui = false,
        neotree = false,
        notify = false,
        noice = true,
      },

       flavour = 'macchiato',

      transparent_background = false,

      })

      vim.cmd.colorscheme("catppuccin-macchiato")
  end,
}



