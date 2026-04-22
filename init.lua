if vim.loader then
  vim.loader.enable()
end

-- Linha 1: Define o caminho para o lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 2. "Bootstrap" - Instala o lazy.nvim se ele não existir

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

--desativa a quebra de linha
vim.opt.wrap = false

--ativa suporte a cores hexadecimais
vim.opt.termguicolors = true

--numeros na lateral esquerda 
vim.opt.number = true

vim.opt.relativenumber = true

--abilita highlight
vim.opt.cursorline = true

--configurar o highlight para apenas numeros
--vim.opt.cursorlineopt = "number"

--define a largura da indentação
vim.opt.shiftwidth = 2

--define o tamanho de um tab 
vim.opt.tabstop = 2

--define que <tab> deve inserir espaços em vez de um caractere <tab>
vim.opt.expandtab = true

vim.opt.timeoutlen = 300

--path do python
local python_host = vim.fn.exepath("python3")
if python_host == "" then
  python_host = vim.fn.exepath("python")
end
if python_host ~= "" then
  vim.g.python3_host_prog = python_host
end

--fuction para mudar a cor do highlight do numero da linha
vim.api.nvim_create_autocmd("ColorScheme", {

  pattern = "*",

  callback = function()

    vim.api.nvim_set_hl(0,"CursorLineNr", {fg = "white"})

    end,

})
vim.g.mapleader = " "

vim.g.maplocalleader = "\\"

-- Configuração específica para Windows (PowerShell)
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end


require("core.keymaps")
-- Setup lazy.nvim

require("lazy").setup({

  spec = {

    -- importe seus plugins

    { import = "plugins" },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },

  },

  change_detection = {
    notify = false,
  },

  checker = { enabled = true, frequency = 86400 },

  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin",
        "gzip",
        "zipPlugin",
        "tarPlugin",
        "tutor",
      },
    },
  },
})

