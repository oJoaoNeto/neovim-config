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
      -- Configurações específicas para Windows
      local install_ok, install = pcall(require, 'nvim-treesitter.install')
      if install_ok then
        install.prefer_git = false
        install.compilers = { "gcc", "clang" }
      end

      -- Proteção contra crash: Só tenta configurar se o módulo existir
      -- Isso permite que o Neovim abra para que você possa rodar :Lazy sync
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if not status then
        print("Aguardando download da branch master do Treesitter... Rode :Lazy sync")
        return
      end

      configs.setup({
        parser_install_dir = vim.fn.stdpath("data") .. "/site",
        ensure_installed = {
          "php", "javascript", "typescript", "tsx", "python", 
          "java", "rust", "html", "css", "json", "toml", "cpp", "c", "bash"
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
    end,
  },
}
