return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },

    config = function()
      require("nvim-ts-autotag").setup()

      -- Nova API: setup() só aceita install_dir
      require("nvim-treesitter").setup()

      -- Instala parsers necessários
      vim.schedule(function()
        require("nvim-treesitter.install").install({
          "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx",
          "python", "java", "rust",
          "html", "css", "json", "toml",
        })
      end)

      -- Highlight e indent via treesitter nativo do Neovim
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if ok then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
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

