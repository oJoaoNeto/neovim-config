return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Usamos a branch 'master' pois ela é a versão legada compatível com Neovim 0.11
    branch = "master", 
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- Compiladores disponíveis
      local install_ok, install = pcall(require, 'nvim-treesitter.install')
      if install_ok then
        install.prefer_git = false
        install.compilers = { "gcc", "clang" }
      end

      -- Proteção contra crash: Só tenta configurar se o módulo existir
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if not status then
        pcall(function()
          require("nvim-treesitter").setup()
        end)
        return
      end

      configs.setup({
        parser_install_dir = vim.fn.stdpath("data") .. "/site",
        ensure_installed = {
          "php", "javascript", "typescript", "tsx", "python", 
          "java", "rust", "html", "css", "json", "toml", "cpp", "c", "bash", "lua", "vim", "vimdoc"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { 
          enable = false,
        },
        autotag = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      })

      -- Textobjects: select
      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move   = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move   = { set_jumps = true },
      })

      local function sel(query)
        return function() ts_select.select_textobject(query) end
      end

      vim.keymap.set({ "x", "o" }, "af", sel("@function.outer"), { desc = "TS: outer function" })
      vim.keymap.set({ "x", "o" }, "if", sel("@function.inner"), { desc = "TS: inner function" })
      vim.keymap.set({ "x", "o" }, "ac", sel("@class.outer"),    { desc = "TS: outer class" })
      vim.keymap.set({ "x", "o" }, "ic", sel("@class.inner"),    { desc = "TS: inner class" })

      local function mv(method, query)
        return function() ts_move[method](query) end
      end

      vim.keymap.set("n", "]m", mv("goto_next_start",  "@function.outer"), { desc = "TS: next function" })
      vim.keymap.set("n", "]c", mv("goto_next_start",  "@class.outer"),    { desc = "TS: next class" })
      vim.keymap.set("n", "[m", mv("goto_previous_start", "@function.outer"), { desc = "TS: prev function" })
      vim.keymap.set("n", "[c", mv("goto_previous_start", "@class.outer"),    { desc = "TS: prev class" })
    end,
  },
}
