local opts = { noremap = true, silent = true }
local map = vim.keymap.set

print("Keymaps GERAIS carregados!")

-- ==============================================================================
-- 1. SALVAR E SAIR
-- ==============================================================================
map('n', '<leader>w', ':w<CR>', { desc = 'Salvar arquivo' })
map('n', '<leader>r', ':wq<CR>', { desc = 'Salvar e Sair' })
map('n', '<leader>q', ':q<CR>', { desc = 'Sair' })

-- ==============================================================================
-- 2. NAVEGAÇÃO ENTRE JANELAS (SPLITS)
-- ==============================================================================
map('n', '<leader>h', '<C-w>h', { desc = 'Mover para janela Esquerda' })
map('n', '<leader>j', '<C-w>j', { desc = 'Mover para janela Abaixo' })
map('n', '<leader>k', '<C-w>k', { desc = 'Mover para janela Acima' })
map('n', '<leader>l', '<C-w>l', { desc = 'Mover para janela Direita' })

-- Modo Terminal
map('t', '<leader>h', [[<C-\><C-n><C-w>h]], { desc = 'Sair do terminal para Esquerda' })
map('t', '<leader>j', [[<C-\><C-n><C-w>j]], { desc = 'Sair do terminal para Baixo' })
map('t', '<leader>k', [[<C-\><C-n><C-w>k]], { desc = 'Sair do terminal para Acima' })
map('t', '<leader>l', [[<C-\><C-n><C-w>l]], { desc = 'Sair do terminal para Direita' })

-- ==============================================================================
-- 3. COPIAR E COLAR
-- ==============================================================================
map('v', '<C-c>', '"+y', { desc = 'Copiar para Clipboard' })
map('v', '<C-x>', '"+x', { desc = 'Recortar para Clipboard' })
map('n', '<C-v>', '"+P', { desc = 'Colar (Normal)' })
map('i', '<C-v>', '<ESC>"+Pa', { desc = 'Colar (Insert)' })

-- Fechar buffer atual 
map('n', '<Leader>u', ':bdelete<CR>', { desc = 'Fechar Buffer' })

-- ==============================================================================
-- 4. ORGANIZAÇÃO & INDENTAÇÃO DE CÓDIGO (Multi-linhas)
-- ==============================================================================
-- Indentação no modo Visual mantendo a seleção ativa
map('v', '<', '<gv', { desc = 'Desindentar bloco' })
map('v', '>', '>gv', { desc = 'Indentar bloco' })
map('v', '<Tab>', '>gv', { desc = 'Indentar bloco com Tab' })
map('v', '<S-Tab>', '<gv', { desc = 'Desindentar bloco com Shift-Tab' })

-- Mover blocos/linhas selecionadas para cima ou para baixo com auto-reindentação
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Mover bloco para baixo' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Mover bloco para cima' })
map('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Mover bloco para baixo (Alt+j)' })
map('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Mover bloco para cima (Alt+k)' })
map('n', '<M-j>', ":m .+1<CR>==", { desc = 'Mover linha para baixo (Alt+j)' })
map('n', '<M-k>', ":m .-2<CR>==", { desc = 'Mover linha para cima (Alt+k)' })

-- Formatação de código via LSP
map({ 'n', 'v' }, '<leader>cf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Formatar código (LSP)' })

-- ==============================================================================
-- 5. BUSCA, SUBSTITUIÇÃO E DELEÇÃO POR EXPRESSÃO REGULAR (REGEX)
-- ==============================================================================

-- 1) Substituir a palavra/variável sob o cursor no arquivo inteiro
local function replace_word_under_cursor()
  local cword = vim.fn.expand("<cword>")
  if not cword or cword == "" then
    vim.notify("Nenhuma palavra sob o cursor!", vim.log.levels.WARN)
    return
  end
  local replacement = vim.fn.input(string.format("Substituir '%s' por: ", cword))
  if replacement and replacement ~= "" then
    local ok, err = pcall(function()
      vim.cmd(string.format("%%s/\\<%s\\>/%s/g", cword, replacement))
      vim.cmd("noh")
    end)
    if ok then
      vim.notify(string.format("'%s' foi substituído por '%s'!", cword, replacement), vim.log.levels.INFO)
    else
      vim.notify("Erro ao substituir: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end
map('n', '<leader>sr', replace_word_under_cursor, { desc = 'Substituir palavra sob cursor no arquivo' })

-- 2) Deletar OCORRÊNCIAS de regex em todo o arquivo
local function delete_regex_prompt()
  local pattern = vim.fn.input("Padrão Regex para DELETAR do arquivo: ")
  if pattern and pattern ~= "" then
    local ok, err = pcall(function()
      vim.cmd(string.format("%%s/%s//g", pattern))
      vim.cmd("noh")
    end)
    if ok then
      vim.notify(string.format("Texto correspondente a '%s' foi deletado!", pattern), vim.log.levels.INFO)
    else
      vim.notify("Erro na regex: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end
map('n', '<leader>dr', delete_regex_prompt, { desc = 'Deletar ocorrências de Regex no arquivo' })

-- 3) Deletar seleção visual ou regex dentro da seleção
map('v', '<leader>dr', [[:s///g<Left><Left>]], { desc = 'Deletar Regex na seleção' })

-- 4) Deletar LINHAS INTEIRAS que casam com uma expressão regular
local function delete_lines_prompt()
  local pattern = vim.fn.input("Deletar LINHAS contendo Regex: ")
  if pattern and pattern ~= "" then
    local ok, err = pcall(function()
      vim.cmd(string.format("g/%s/d", pattern))
      vim.cmd("noh")
    end)
    if ok then
      vim.notify(string.format("Linhas contendo '%s' foram deletadas!", pattern), vim.log.levels.INFO)
    else
      vim.notify("Erro na regex: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end
map('n', '<leader>dl', delete_lines_prompt, { desc = 'Deletar linhas com Regex' })

-- 5) Deletar LINHAS que NÃO casam com a expressão regular (inverso / filtro)
local function delete_lines_inverse_prompt()
  local pattern = vim.fn.input("Deletar LINHAS que NÃO contêm Regex: ")
  if pattern and pattern ~= "" then
    local ok, err = pcall(function()
      vim.cmd(string.format("v/%s/d", pattern))
      vim.cmd("noh")
    end)
    if ok then
      vim.notify(string.format("Linhas sem '%s' foram deletadas!", pattern), vim.log.levels.INFO)
    else
      vim.notify("Erro na regex: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end
map('n', '<leader>dv', delete_lines_inverse_prompt, { desc = 'Deletar linhas sem Regex (Inverso)' })

-- 6) Comandos customizados para barra de comandos (:)
vim.api.nvim_create_user_command('ReplaceAll', function(command_opts)
  local args = vim.split(command_opts.args, "%s+", { trimempty = true })
  if #args < 2 then
    vim.notify("Uso: :ReplaceAll <antigo> <novo>", vim.log.levels.WARN)
    return
  end
  local find_str, replace_str = args[1], args[2]
  vim.cmd(string.format("bufdo %%s/%s/%s/ge | update", find_str, replace_str))
  vim.cmd("noh")
  vim.notify(string.format("Substituído '%s' por '%s' em todos os buffers!", find_str, replace_str), vim.log.levels.INFO)
end, { nargs = "*" })

vim.api.nvim_create_user_command('DeleteRegex', function(command_opts)
  local pattern = command_opts.args
  if not pattern or pattern == "" then
    vim.notify("Uso: :DeleteRegex <expressao_regular>", vim.log.levels.WARN)
    return
  end
  vim.cmd(string.format("%%s/%s//g", pattern))
  vim.cmd("noh")
  vim.notify(string.format("Texto correspondente a '%s' foi deletado!", pattern), vim.log.levels.INFO)
end, { nargs = 1 })

vim.api.nvim_create_user_command('DeleteLines', function(command_opts)
  local pattern = command_opts.args
  if not pattern or pattern == "" then
    vim.notify("Uso: :DeleteLines <expressao_regular>", vim.log.levels.WARN)
    return
  end
  vim.cmd(string.format("%%g/%s/d", pattern))
  vim.cmd("noh")
  vim.notify(string.format("Linhas contendo '%s' foram deletadas!", pattern), vim.log.levels.INFO)
end, { nargs = 1 })

-- ==============================================================================
-- 6. OVERSEER (Tarefas)
-- ==============================================================================
map('n', '<leader>oo', '<cmd>OverseerToggle<cr>', { desc = 'Overseer: Task List' })
map('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = 'Overseer: Run Task' })
map('n', '<leader>os', '<cmd>OverseerTaskAction<cr>', { desc = 'Overseer: Actions' })

local function close_all_overseer()
  vim.cmd("OverseerClose")
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "overseer_output" or vim.bo[buf].buftype == "terminal" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  vim.cmd("cclose")
  vim.cmd("lclose")
end

map('n', '<leader>oq', close_all_overseer, { desc = 'Overseer: Close All side windows' })
map('t', '<leader>os', [[<C-\><C-n><cmd>OverseerTaskAction<cr>]], { desc = 'Overseer Actions (Terminal)' })
map('t', '<leader>oq', function() 
  vim.cmd([[stopinsert]])
  close_all_overseer() 
end, { desc = 'Fechar Overseer (Terminal)' })

-- ==============================================================================
-- 7. DEBUGGER (DAP)
-- ==============================================================================
local dap_keys = {
  { key = '<F5>',  func = function() require('dap').continue() end,  desc = 'DAP: Continue' },
  { key = '<F10>', func = function() require('dap').step_over() end, desc = 'DAP: Step Over' },
  { key = '<F11>', func = function() require('dap').step_into() end, desc = 'DAP: Step Into' },
  { key = '<F12>', func = function() require('dap').step_out() end,  desc = 'DAP: Step Out' },
  { key = '<leader>dc', func = function() require('dap').continue() end,  desc = 'DAP: Continue' },
  { key = '<leader>db', func = function() require('dap').toggle_breakpoint() end, desc = 'DAP: Breakpoint' },
}

for _, m in ipairs(dap_keys) do
  map('n', m.key, m.func, { desc = m.desc })
  map('t', m.key, function()
    vim.cmd([[stopinsert]])
    m.func()
  end, { desc = m.desc })
end

map('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'DAP: UI Toggle' })
map('n', '<leader>dt', function()
  require('dap').terminate()
  require('dapui').close()
  vim.defer_fn(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft:find("dapui") or ft == "dap-repl" or vim.bo[buf].buftype == "terminal" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end, 100)
end, { desc = 'DAP: Terminate' })

map('t', '<leader>dt', [[<C-\><C-n><leader>dt]], { desc = 'DAP Terminate (Terminal)' })

-- ==============================================================================
-- 8. LSP RESTART
-- ==============================================================================
map('n', '<leader>ll', '<cmd>LspRestart<cr>', { desc = 'LSP: Restart' })

-- ==============================================================================
-- 9. LISTAGEM DE MAPS
-- ==============================================================================
vim.api.nvim_create_user_command('MapsList', function()
  local modes = {'n', 'i', 'v', 'c', 't', 's', 'o', 'x'}
  local maps_by_key = {}
  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, item in ipairs(maps) do
      local key = mode .. ': ' .. item.lhs
      if not maps_by_key[key] then maps_by_key[key] = {} end
      table.insert(maps_by_key[key], {
        lhs = item.lhs,
        rhs = item.rhs or '<function>',
        mode = mode,
        buffer = item.buffer or false,
        desc = item.desc or ''
      })
    end
  end
  print("\n=== TODOS OS MAPEAMENTOS ===\n")
  for key, maps in pairs(maps_by_key) do
    for _, item in ipairs(maps) do
      print(key .. " -> " .. item.rhs .. " (" .. item.desc .. ")")
    end
  end
end, {})
