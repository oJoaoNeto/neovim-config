return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    {
      '<leader>e',
      function()
          vim.cmd('Neotree filesystem toggle')
      end,
      desc = 'Explorer (Neo-tree)',
    },
    {
      '<leader>bb',
      function()
        vim.cmd.Neotree 'buffers'
      end,
      desc = 'Explorer (Buffers)',
    },
    {
      '<leader>ge',
      function()
        vim.cmd.Neotree 'git_status'
      end,
      desc = 'Explorer (Git Status)',
    },
  },
  opts = {
    sources = {
      'filesystem',
      'buffers',
      'git_status',
    },
    source_selector = {
      winbar = true,
      tabs_layout = 'equal',
      sources = {
        { source = 'filesystem', display_name = ' Files' },
        { source = 'buffers', display_name = ' Buffers' },
        { source = 'git_status', display_name = '󰊢 Git' }
      }
    },
    window = {
      position = 'left',
      width = 30,
      border = 'rounded',
      padding_top = 1,
      padding_bottom = 1,
      mappings = {
        ['[b'] = 'prev_source',
        [']b'] = 'next_source',
        ['<cr>'] = 'open',
        ['o'] = 'open',
        ['S'] = 'open_split',
        ['s'] = 'open_vsplit',
        ['t'] = 'open_tabnew',
        ['q'] = 'close_window',
        ['R'] = 'refresh',
        ['z'] = 'close_all_nodes',
        ['?'] = 'show_help',
      },
    },
    renderers = {
      indent_markers = {
        enable = true,
        icons = {
          corner = '└',
          edge = '│',
          ['default'] = '│',
          end_of_list = ' ',
          bottom_corner = '└',
          top_corner = '┌',
          middle_corner = '├',
        },
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        highlight = 'NeoTreeFileActive',
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          '.git', '.DS_Store', 'thumbs.db', 'node_modules', '__pycache__',
        },
      },
    },
    enable_git_status = true,
    enable_diagnostics = true,
    use_popups_for_input = false,
    use_default_for_input = false,
  },

  config = function(_, opts)
    -- (Isto aplica as bordas, linhas, padding, etc. da tabela 'opts')
    require("neo-tree").setup(opts)

    -- 2. DEPOIS, aplicar as nossas cores
    vim.api.nvim_set_hl(0, 'NeoTreeWinBarActive', { link = 'TabLineSel' })
    vim.api.nvim_set_hl(0, 'NeoTreeWinBar', { link = 'TabLine' })
    vim.api.nvim_set_hl(0, 'NeoTreeFileActive', { link = 'Search' })
  end,
}
