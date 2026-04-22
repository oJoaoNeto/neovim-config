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
      -- 1. Ignorar mensagem de reload do Lazy
      {
        filter = {
          event = "notify",
          find = "Config Change Detected",
        },
        opts = { skip = true },
      },

      -- 2. ESCONDER a mensagem de save padrão do Neovim
      -- (Nós vamos criar a nossa própria mais bonita abaixo)
      {
        filter = {
          event = "msg_show",
          find = "written",
        },
        opts = { skip = true }, -- Aqui escondemos a original feia
      },
    },
  },

  -- AQUI ESTÁ A MÁGICA
  config = function(_, opts)
    require("noice").setup(opts)

    -- Criamos um Autocomando que roda toda vez que você salva
    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        -- Pega apenas o nome do arquivo (sem o caminho completo)
        local filename = vim.fn.expand("%:t")

        -- Envia a notificação bonita
        vim.notify("Save!!", "info", {
          title = filename,
          timeout = 2000, -- Some depois de 2 segundos
        })
      end,
    })
  end,
}
