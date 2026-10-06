return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    ft = { "rust", "c", "cpp" },
    keys = {
      { "<F5>",  function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Breakpoint" },
      { 
        "<leader>dt", 
        function() 
          require("dap").terminate() 
          require("dapui").close()
          -- Fecha janelas de assembly ou terminais de debug que sobraram
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "terminal" or vim.bo[buf].filetype == "dap-float" then
              vim.api.nvim_win_close(win, true)
            end
          end
        end, 
        desc = "DAP Terminate (Stop Everything)" 
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI: Toggle" },
    },
    dependencies = {
      { "rcarriga/nvim-dap-ui", opts = {} },
      { "nvim-neotest/nvim-nio" },
      { "jay-babu/mason-nvim-dap.nvim" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        automatic_setup = true,
        ensure_installed = {
          "codelldb",
        },
        handlers = {
          function(config)
            -- Mantenha o setup padrão do mason-nvim-dap
            require('mason-nvim-dap').default_setup(config)
          end,
        },
      })

      -- Configuração específica para C e C++ usando codelldb
      dap.configurations.c = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      dapui.setup()

      -- Abre e fecha a UI automaticamente
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
