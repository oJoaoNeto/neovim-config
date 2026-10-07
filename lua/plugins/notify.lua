-- nvim-notify desativado (comentado) para remover notificações flutuantes na tela
--[[
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    background_colour = "#000000",
    render = "wrapped-compact",
    stages = "static",
  },
  config = function(_, opts)
    require("notify").setup(opts)
    vim.notify = require("notify")
  end
}
]]

return {}
