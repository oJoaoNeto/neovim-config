
local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Define líder 
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

print("Keymaps GERAIS carregados!")

-- Salvar e sair 
map('n', '<leader>w', ':w<CR>', { desc = 'Salvar arquivo' })
map('n', '<leader>r', ':wq<CR>', { desc = 'Salvar e Sair' })
map('n', '<leader>q', ':q<CR>', { desc = 'Sair' })

-- Navegação entre janelas (splits) 
map('n', '<C-h>', '<C-w>h', { desc = 'Mover para janela Esquerda' })
map('n', '<C-j>', '<C-w>j', { desc = 'Mover para janela Abaixo' })
map('n', 'C-k', '<C-w>k', { desc = 'Mover para janela Acima' })
map('n', '<C-l>', '<C-w>l', { desc = 'Mover para janela Direita' })

-- Copiar/Colar 
map('v', '<C-c>', '"+y', { desc = 'Copiar para Clipboard' })
map('v', '<C-x>', '"+x', { desc = 'Recortar para Clipboard' })
map('n', '<C-v>', '"+P', { desc = 'Colar (Normal)' })
map('i', '<C-v>', '<ESC>"+Pa', { desc = 'Colar (Insert)' })

-- Fechar buffer atual 
map('n', '<Leader>u', ':bdelete<CR>', { desc = 'Fechar Buffer' })

--comandos de debug
map('n','<leader>db',function () require('dap').toggle_breakpoint() end)--liga/desliga ponto de parada
map('n','<leader>dc', function () require('dap').continue() end) -- inicia ou continua execução

-- Comando para listar TODOS os mapeamentos e identificar duplicatas
vim.api.nvim_create_user_command('MapsList', function()
  local modes = {'n', 'i', 'v', 'c', 't', 's', 'o', 'x'}
  local maps_by_key = {}

  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)

    for _, map in ipairs(maps) do
      local key = mode .. ': ' .. map.lhs
      if not maps_by_key[key] then
        maps_by_key[key] = {}
      end
      table.insert(maps_by_key[key], {
        lhs = map.lhs,
        rhs = map.rhs or '<function>',
        mode = mode,
        buffer = map.buffer or false,
        desc = map.desc or ''
      })
    end
  end

  -- Mostrar duplicatas
  local duplicates = {}
  for key, maps in pairs(maps_by_key) do
    if #maps > 1 then
      table.insert(duplicates, {key = key, maps = maps})
    end
  end

  if #duplicates > 0 then
    print("\n=== MAPEAMENTOS DUPLICADOS ENCONTRADOS ===\n")
    for _, dup in ipairs(duplicates) do
      print("KEY: " .. dup.key)
      for i, map in ipairs(dup.maps) do
        print("  " .. i .. ". RHS: " .. map.rhs .. " | DESC: " .. map.desc)
      end
      print("")
    end
  else
    print("Nenhuma duplicata encontrada!")
  end

  -- Listar TODOS os mapeamentos
  print("\n=== TODOS OS MAPEAMENTOS ===\n")
  for key, maps in pairs(maps_by_key) do
    for _, map in ipairs(maps) do
      print(key .. " -> " .. map.rhs .. " (" .. map.desc .. ")")
    end
  end
end, {})

-- Use assim: :MapsList
