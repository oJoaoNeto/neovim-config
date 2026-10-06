return {
  name = "GCC/G++ Compile & Run",
  builder = function()
    local file = vim.fn.expand("%:p")
    local outfile = vim.fn.expand("%:p:r") .. ".exe"
    local extension = vim.fn.expand("%:e")
    local compiler = (extension == "c") and "gcc" or "g++"
    
    local cmd = string.format('%s -g "%s" -o "%s" ; if ($?) { & "%s" }', 
      compiler, file, outfile, outfile)

    return {
      cmd = cmd,
      shell = true,
      components = {
        "on_exit_set_status",
        { "on_complete_dispose", timeout = 30 },
        -- Removido quickfix para evitar excesso de janelas
        -- Abre a janela de saída na lateral com foco automático
        { "open_output", direction = "vertical", on_start = "always" },
      },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
}
