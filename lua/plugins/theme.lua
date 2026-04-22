return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VimEnter",
  priority = 1000,

  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = true,
      integrations = {
        treesitter = true,
        lsp_trouble = false,
        gitsigns = true,
        telescope = true,
        cmp = true,
        native_lsp = { enabled = true },
        dap = false,
        dap_ui = false,
        neotree = false,
        notify = false,
        noice = true,
      },
    })

    vim.cmd.colorscheme("catppuccin-macchiato")

    local function apply_transparency()
      local groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "EndOfBuffer",
        "MsgArea",
        "WinSeparator",
      }

      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end

    apply_transparency()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = apply_transparency,
    })
  end,
}
