return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = "modern",
    spec = {
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>d", group = "Debug (DAP) / Diagnostics" },
      { "<leader>k", group = "LSP Code Action" },
      { "<leader>r", group = "Rename / Save & Exit" },
      { "<leader>l", group = "LSP Navigation" },
    },
  },
}
