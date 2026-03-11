return {
  name = "G++ Compile & Run",
  builder = function()
    local file = vim.fn.expand("%:p")
    local outfile = vim.fn.expand("%:p:r")

    local cmd = string.format('g++ -g "%s" -o "%s" && "%s"',
      file, outfile, outfile)

    return {
      cmd = { "zsh", "-c", cmd },
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
