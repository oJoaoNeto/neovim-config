
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>ff',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = 'Telescope find files'
    },
    { '<leader>fg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = 'Telescope live grep'
    },
    { '<leader>fb',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Telescope buffers'
    },
    { '<leader>fh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Telescope help tags'
    },
    { '<leader>fc',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end,
      desc = 'Telescope current buffer fuzzy find'
    },
  },

  config = function()
    local ok, ts_parsers = pcall(require, 'nvim-treesitter.parsers')
    if ok and type(ts_parsers.ft_to_lang) ~= 'function' then
      local get_lang = vim.treesitter
        and vim.treesitter.language
        and vim.treesitter.language.get_lang
      ts_parsers.ft_to_lang = get_lang or function(ft)
        return ft
      end
    end

    local ok_cfg, ts_configs = pcall(require, 'nvim-treesitter.configs')
    if not ok_cfg then
      package.loaded['nvim-treesitter.configs'] = {
        is_enabled = function()
          return false
        end,
      }
    elseif type(ts_configs.is_enabled) ~= 'function' then
      ts_configs.is_enabled = function()
        return false
      end
    end

    require('telescope').setup({})
  end
}
