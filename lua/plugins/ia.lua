--[[return {

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    lazy = false,
    -- CORREÇÃO: As teclas (keys) devem ficar AQUI, fora da função config
    keys = {
      {
        "<leader>gt",
        function()
          require("copilot.suggestion").toggle_auto_trigger()
          print("Copilot Ghost Text: Toggled")
        end,
        desc = "Copilot: Toggle Ghost Text"
      },
    },

    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true, 
          auto_trigger = false,
          keymap = {
            accept = "<C-l>",
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
        -- O bloco keys foi removido daqui de dentro
        panel = { enabled = false },

        -- Habilita para tudo (o filtro será feito no Chat)
        filetypes = { ["*"] = true },
      })
    end,
  },
  -- ===========================================================================
  -- 2. O CHAT: CopilotChat.nvim
  -- ===========================================================================
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main", -- MUDANÇA CRUCIAL: Branch com correções de renderização
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
      {'folke/snacks.nvim'},
    },
    build = nil,
    
    opts = {
      debug = true, -- Garante que logs de debug não vazem para o texto
      
      -- Configurações visuais simples e estáveis
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      separator = "---", -- Separador visual claro
      show_folds = false, -- Desativa dobras que podem gerar os IDs estranhos
      
      window = {
        layout = "float",
        width = 0.5,
        height = 0.8,
        border = "rounded",
      },

      -- Mapeamentos padrão para evitar erros de inicialização
      mappings = {
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
      },
    },

    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)

      -- ============================================================
      -- GUARDIÃO DO CHAT: Resolve conflitos de tecla e Ghost Text
      -- ============================================================
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          -- 1. Desliga COMPLETAMENTE o Autocomplete e Ghost Text neste buffer
          -- Isso impede que o texto "Cop# Copilot" apareça no meio da resposta
          pcall(function() 
            require("cmp").setup.buffer({ enabled = false }) 
          end)
          
          local status_sug, suggestion = pcall(require, "copilot.suggestion")
          if status_sug then
            if suggestion.is_visible() then suggestion.dismiss() end
            vim.b.copilot_suggestion_enabled = false
            vim.b.copilot_suggestion_auto_trigger = false
          end

          -- 2. Mapeamento de Envio Seguro (Enter)
          -- Usa uma função local para garantir o envio
          local function send_msg()
            local input = vim.api.nvim_get_current_line()
            if input ~= "" then
              chat.ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end

          local map_opts = { buffer = true, noremap = true, silent = true }
          vim.keymap.set("n", "<CR>", send_msg, map_opts)
          vim.keymap.set("i", "<C-CR>", send_msg, map_opts)
          vim.keymap.set("i", "<CR>", send_msg, map_opts) -- Tenta Enter no insert também
        end,
      })
    end,
    
    keys = {
-- COMANDO: ANEXAR ARQUIVO (Attach File)
      {
        "<leader>at",
        function()
          -- Verifica se o Telescope está instalado
          local status, builtin = pcall(require, "telescope.builtin")
          if not status then 
            print("Erro: Telescope não encontrado")
            return 
          end

          -- Função que será executada ao escolher o arquivo
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          builtin.find_files({
            prompt_title = "Anexar Arquivo ao Chat",
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local filepath = selection.path or selection[1]

                -- Lê o arquivo
                local file = io.open(filepath, "r")
                if not file then return end
                local content = file:read("*a")
                file:close()

                -- Pega extensão e nome
                local filename = vim.fn.fnamemodify(filepath, ":t")
                local extension = vim.fn.fnamemodify(filepath, ":e")

                -- Formata a mensagem para a IA entender que é um contexto
                local formatted_text = string.format(
                  "\n> Contexto do arquivo: %s\n```%s\n%s\n```\n", 
                  filename, extension, content
                )

                -- Garante que o chat está aberto
                local chat = require("CopilotChat")
                if vim.bo.filetype ~= "copilot-chat" then
                  chat.toggle()
                end

                -- Cola o conteúdo no cursor
                vim.api.nvim_put(vim.split(formatted_text, "\n"), "l", true, true)
                print(">> Arquivo anexado: " .. filename)
              end)
              return true
            end,
          })
        end,
        desc = "CopilotChat - Anexar Arquivo (Attach)",
        mode = { "n" } -- Funciona no modo Normal e Insert
      },
      { "<leader>aa", function() require("CopilotChat").toggle() end, desc = "CopilotChat - Toggle", mode = { "n", "v" } },
      { "<leader>ar", function() require("CopilotChat").reset() end, desc = "CopilotChat - Reset", mode = { "n", "v" } },
      { "<leader>ap", function() require("CopilotChat").select_prompt() end, desc = "CopilotChat - Prompts", mode = { "n", "v" } },
      { "<leader>am", function() 
          local models = { "gpt-4o", "gpt-4", "claude-3.5-sonnet" }
          vim.ui.select(models, { prompt = "Model:" }, function(sel)
            if sel then require("CopilotChat").setup({ model = sel }) end
          end)
        end, desc = "Select Model", mode = { "n", "v" } 
      },
    },
  },

  -- 3. Code Companion
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "zbirenbaum/copilot.lua" },
    config = function() require("codecompanion").setup({ strategies = { inline = { adapter = "copilot" } } }) end,
    keys = {
      { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Inline" },
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Actions" },
    },
  }
}]]
return {}
