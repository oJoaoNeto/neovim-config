return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<leader>t",  "<cmd>ToggleTerm<cr>", desc = "[T]oggle [T]erminal" },
    { "<leader>ft", "<cmd>ToggleTerm direction=float<cr>", desc = "[F]loating [T]erminal" },
    { "<leader>vt", "<cmd>ToggleTerm direction=vertical<cr>", desc = "[V]ertical [T]erminal" },
    { "<leader>ht", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "[H]orizontal [T]erminal" },
    { [[<c-\>]], "<cmd>ToggleTerm<cr>", desc = "ToggleTerm (Ctrl+\\)" },
  },
  opts = {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = "zsh",
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = { border = "Normal", background = "Normal" },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { buffer = 0, noremap = true, silent = true, desc = "Sair do modo terminal" })
      end,
    })
  end,
}

