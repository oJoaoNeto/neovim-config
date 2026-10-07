if vim.loader then
  vim.loader.enable()
end

-- 0. Desativa provedores legados para evitar busca de executáveis no Windows (ganho de velocidade)
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- 1. Define as teclas líder (Obrigatório ser ANTES de carregar plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 2. Desativa o comportamento padrão do Espaço (pular caracteres)
-- Isso evita que ele mova o cursor enquanto espera pelo Which-Key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- 3. Carrega os mapeamentos principais imediatamente
require("core.keymaps")

-- 4. Define o caminho para o lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 5. \"Bootstrap\" - Instala o lazy.nvim se ele não existir
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone",
    "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Adiciona Mason e MSYS2 ao PATH (importante para o Windows encontrar compiladores e ferramentas)
local mason_path = vim.fn.stdpath("data") .. "/mason/bin"
local msys_path = "C:\\msys64\\mingw64\\bin;C:\\msys64\\clang64\\bin;C:\\msys64\\usr\\bin"
if vim.fn.has("win32") == 1 then
  vim.env.PATH = mason_path .. ";" .. msys_path .. ";" .. vim.env.PATH
else
  vim.env.PATH = mason_path .. ":" .. vim.env.PATH
end

-- CONFIGURAÇÕES GERAIS
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Abrir novas janelas sempre embaixo e à direita
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250
vim.opt.redrawtime = 1500

-- Path do python
vim.g.python3_host_prog = vim.fn.exepath("python3")

-- Cores customizadas
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "white" })
  end,
})

vim.opt.shell = "zsh"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
  },
  change_detection = { notify = false },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin", "gzip", "zipPlugin", "tarPlugin", "tutor",
      },
    },
  },
})
