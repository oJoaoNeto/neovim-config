return{
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    ft = { "rust" },
    keys = {
      { "<F5>",  function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Breakpoint" },
    },
    dependencies = {
      { "rcarriga/nvim-dap-ui", opts = {} },
      { "nvim-neotest/nvim-nio" },
      { "jay-babu/mason-nvim-dap.nvim"},
    },
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        automatic_setup = true,
        ensure_installed = {
          "codelldb",
        },
        handlers = {},
      })

      dapui.setup()

      --abre e fecha a UI automaticamente
      dap.listeners.before.attach.depui_config = function ()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function ()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function ()
        dapui.close()
      end
    end,
  },
}
