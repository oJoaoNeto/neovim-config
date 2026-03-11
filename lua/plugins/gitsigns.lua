return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPost", "BufNewFile" }, -- Carrega quando um arquivo for lido ou criado
  config = function()
    require('gitsigns').setup({
      --Você pode customizar os ícones aqui se não gostar dos padrões
      signs = {
         add          = { text = '▎' },
         change       = { text = '▎' },
        delete       = { text = '' },
         topdelete    = { text = '' },
         changedelete = { text = '▎' },
         untracked    = { text = '▎' },
       },
      -- Atalhos (Keymaps)
      -- 'n' = Modo Normal, 'v' = Modo Visual
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set

        -- Navegação
        -- ']c' e '[c' são padrões do vim para "próxima/anterior mudança"
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = "Git: Próximo Hunk" })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = "Git: Hunk Anterior" })

        -- Ações
        -- <leader> é geralmente a tecla '\' ou 'espaço'
        map('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Git: Stage Hunk" })
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { buffer = bufnr, desc = "Git: Stage Hunk (Visual)" })
        map('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Git: Reset Hunk" })
        map('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Git: Undo Stage Hunk" })
        map('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Git: Preview Hunk" })
        map('n', '<leader>hb', gs.blame_line, { buffer = bufnr, desc = "Git: Blame Linha" })
      end
    })
  end
}
