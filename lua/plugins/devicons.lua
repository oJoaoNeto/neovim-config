return{
  'nvim-tree/nvim-web-devicons',
  lazy = true,
  event = "VeryLazy",
  config = function()

    require('nvim-web-devicons').setup()
  end,
}


