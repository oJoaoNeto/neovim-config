return{
  "akinsho/git-conflict.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("git-conflict").setup({
      -- Desabilitar 'select_resolution' para que você possa editar livremente,
      -- ou deixar 'true' para que ele remova os marcadores após a escolha.
      disable_diagnostics = true, -- Opcional: Desabilita os diagnósticos se for muito poluído
      default_mappings = true,     -- Define os mapeamentos padrão
      -- Opcional: Mapeamentos padrão (se 'default_mappings = true')
      -- Você pode mapear para outras teclas se preferir
      keymaps = {
        next = "<leader>cn",
        prev = "<leader>cp",
        ours = "<leader>co", -- Choose Ours
        theirs = "<leader>ct", -- Choose Theirs
        both = "<leader>cb",
        none = "<leader>c0", -- Remove all markers
      },
    })
  end
}
