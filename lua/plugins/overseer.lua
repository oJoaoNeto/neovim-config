return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerToggle", "OverseerRun", "OverseerConfig",
      "OverseerInfo", "OverseerTaskAction", "OverseerClearCache",
      "OverseerClose", "OverseerOpen"
    },
    opts = {
      templates = { "builtin", "user.cpp_run", "user.run_script" },
      task_list = {
        direction = "right",
        bindings = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = "ScrollCursorUp",
          ["<C-j>"] = "ScrollCursorDown",
          ["q"] = "Quit",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
    end
  }
}
