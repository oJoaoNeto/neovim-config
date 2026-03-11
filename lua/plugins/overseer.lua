return{
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerToggle", "OverseerRun", "OverseerConfig", "OverseerInfo", "OverseerQuickAction" },
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Task List" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>oc", "<cmd>OverseerConfig<cr>", desc = "Task Config" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>os", "<cmd>OverseerQuickAction stop<cr>", desc = "Overseer: Stop" },
      { "<leader>od", "<cmd>OverseerQuickAction dispose<cr>", desc = "Overseer: Dispose" },
    },
    opts = {
      --configs visuais
      templates = { "builtin", "user.cpp_run","user.run_script"},
      task_list = {
        direction = "right",
        bindings  = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = "ScrollCursorUp",
          ["<C-j>"] = "ScrollCursorDown",
        },
      },
    },
    config = function (_,opts)
      local overseer = require("overseer")
      overseer.setup(opts)
    end
  }
}
