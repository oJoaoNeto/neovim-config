return {
  'akinsho/bufferline.nvim',
  -- 'nvim-web-devicons' é necessário para os ícones
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- A 'version' é recomendada para estabilidade
  version = "*",
  keys = {
    { '<C-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Buffer Próximo' },
    { '<C-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Buffer Anterior' },
  },
  -- 'opts' é a forma do lazy.nvim de passar opções para o .setup()
  opts = {
    options = {
      -- Estilo dos separadores. 
      -- O que você tem na imagem parece ser o 'slant' ou 'slope'
      separator_style = 'slant', -- 'slope', 'thick', 'thin'

      -- Mostra os ícones de diagnóstico (LSP)
      -- Requer que 'core.diagnostics' esteja a funcionar
      diagnostics = 'nvim_lsp',

      -- Mostra o ícone de fechar 'X' em cada aba
      show_buffer_close_icons = true,
      show_close_icon = true,

      -- Permite fechar buffers com o clique do meio do rato
      right_mouse_command = 'buffer_close',

      -- Move a barra para a esquerda para dar espaço ao nvim-tree
      -- Se o seu nvim-tree tiver um 'filetype' diferente, mude aqui
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'File Explorer', -- Texto opcional
          text_align = 'left',
          separator = true,
        },
      }, 
      -- Mostra os ícones dos ficheiros (requer nvim-web-devicons)
      show_buffer_icons = true,

      -- Configuração customizada para os indicadores de diagnóstico
      diagnostics_indicator = function(count, level)
        local icon = level == 'error' and ' ' or level == 'warning' and ' ' or ' '
        return ' ' .. icon .. count
      end,

      -- Sempre mostrar a linha de buffers, mesmo que só haja um
      always_show_bufferline = true,

      -- Pode adicionar um 'hover' para ver mais detalhes
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
    },
  },
}
