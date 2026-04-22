return {
  'numToStr/Comment.nvim',
  event = "VeryLazy", -- Carrega quando for necessário

  -- 'opts' é uma forma mais limpa de passar a configuração para o 'setup'
  opts = {
    -- Mapeamentos
    toggler = {
      line = 'gcc', -- Atalho para comentar/descomentar a linha atual
      block = 'gbc', -- Atalho para comentar/descomentar em bloco
    },
    -- Mapeamentos para modo visual
    opleader = {
      line = 'gc', -- gc + (movimento)
      block = 'gb', -- gb + (movimento)
    },
  },
  
  -- A função config garante que o setup seja chamado com as 'opts'
  config = function(_, opts)
    require('Comment').setup(opts)
  end,
}
