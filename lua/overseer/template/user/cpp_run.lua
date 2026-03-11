return {
  name = "G++ Compile & Run",
  builder = function()
    local file = vim.fn.expand("%:p")
    local outfile = vim.fn.expand("%:p:r") .. ".exe"
    
    -- Usamos o caminho absoluto para evitar erros de PATH
    local gpp_path = "C:\\mingw64\\bin\\g++.exe"
    
    local cmd = string.format('& "%s" -g "%s" -o "%s" ; if ($?) { & "%s" }', 
      gpp_path, file, outfile, outfile)

    return {
      cmd = cmd,
      shell = true,
      components = {
        "on_exit_set_status",
        { "on_complete_dispose", timeout = 30 },
        "on_output_quickfix",
      },
    }
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
}
