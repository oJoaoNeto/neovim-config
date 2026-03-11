return{
  'kdheepak/lazygit.nvim',
  -- Carrega o plugin quando o comando 'LazyGit' for chamado
  cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- Opcional: Adicionar um atalho para abrir o lazygit
  keys =  { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' }, -- '<leader>gg' = "git git" (fácil de lembrar)
}
