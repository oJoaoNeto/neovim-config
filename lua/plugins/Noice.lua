-- Noice desativado (comentado) para usar a linha de comando clássica e limpa na barra inferior do Neovim
--[[
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    views = {
      cmdline_popup = {
        position = { row = 3, col = "50%" },
        size = { width = 60, height = "auto" },
      },
      popupmenu = {
        relative = "editor",
        position = { row = 6, col = "50%" },
        size = { width = 60, height = 10 },
        border = { style = "rounded", padding = { 0, 1 } },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "Config Change Detected",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "written",
        },
        opts = { skip = true },
      },
    },
  },

  config = function(_, opts)
    require("noice").setup(opts)
  end,
}
]]

return {}
