return {
  -- 1) Mason
  { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
  
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    
    init = function()
      vim.diagnostic.config({
        update_in_insert = false,
        severity_sort = true,
        virtual_text = true,
      })

      local diagnostic_opts = { noremap = true, silent = true, desc = "Diagnostics" }
      vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, diagnostic_opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, diagnostic_opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, diagnostic_opts)

      vim.lsp.inlay_hint.enable(false)

      local ruff_fmt_grp = vim.api.nvim_create_augroup("RuffFormatOnSave", { clear = true })

      local grp = vim.api.nvim_create_augroup("UserLspAttach", {clear = true})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          local function bmap(mode,lhs,rhs,desc)
            vim.keymap.set(mode,lhs,rhs, {buffer = bufnr, noremap = true, silent = true, desc = desc})
          end

          bmap("n", "ld", vim.lsp.buf.definition, "LSP: Definition")
          bmap("n", "K", vim.lsp.buf.hover, "LSP: Hover")
          bmap("n", "li", vim.lsp.buf.implementation, "LSP: Implementation")
          bmap("n", "lr", vim.lsp.buf.references, "LSP: References")
          bmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
          bmap("n", "<leader>ka", vim.lsp.buf.code_action, "LSP: Code Action")
          bmap("n", "<leader>D", vim.lsp.buf.type_definition, "LSP: Type Definition")

          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- Formatar no save: APENAS com ruff (evita duplicar)
          if client and client.name == "ruff" and client:supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = ruff_fmt_grp, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = ruff_fmt_grp,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  timeout_ms = 3000,
                  filter = function(c) return c.name == "ruff" end,
                })
              end,
            })
          end
        end,
      })
    end,

    config = function()
      -- Capabilities pro nvim-cmp (autocomplete bom via LSP)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Detecta se o mason-lspconfig conhece ts_ls; se não, usa tsserver (compat)
      local ts_server = "ts_ls"
      do
        local ok_map, map = pcall(require, "mason-lspconfig.mappings.server")
        if ok_map then
          local has_ts_ls = map.lspconfig_to_package["ts_ls"] ~= nil
          local has_tsserver = map.lspconfig_to_package["tsserver"] ~= nil
          if (not has_ts_ls) and has_tsserver then
            ts_server = "tsserver"
          end
        end
      end

      -- TypeScript/React
      vim.lsp.config(ts_server, {
        capabilities = capabilities,
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      })

      -- Php (Intelephense)
      vim.lsp.config("intelephense", {
        capabilities = capabilities,
        root_markers = { "composer.json", ".git", "index.php" },
      })

      -- Tailwind (autocomplete de classes + regex pra cn/clsx/cva/twMerge)
      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
        root_markers = {
          "tailwind.config.js",
          "tailwind.config.cjs",
          "tailwind.config.mjs",
          "tailwind.config.ts",
          "postcss.config.js",
          "package.json",
          ".git",
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "clsx%(([^)]*)%)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "cn%(([^)]*)%)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "cva%(([^)]*)%)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "twMerge%(([^)]*)%)", "[\"'`]([^\"'`]*)[\"'`]" },
              },
            },
          },
        },
      })

      -- ESLint
      vim.lsp.config("eslint", {
        capabilities = capabilities,
        root_markers = {
          "eslint.config.js",
          ".eslintrc",
          ".eslintrc.json",
          ".eslintrc.js",
          "package.json",
          ".git",
        },
      })

      -- HTML/CSS/JSON/Emmet
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("cssls", { capabilities = capabilities })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("emmet_ls", {
        capabilities = capabilities,
        filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
      })

      vim.lsp.config("pyrefly", {
        capabilities = capabilities,
        cmd = { "python3", "-m", "pyrefly", "lsp" },
        single_file_support = true,
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "manage.py", ".git" },
      })
      -- basedpyright (config antiga para referência)
      --[[ vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        single_file_support = true,
        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "pyrightconfig.json",
          ".git",
          ".venv",
          "venv",
        },
        settings = {
          basedpyright = {
            analysis = {
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      }) ]]

      -- ty (config antiga, mantida comentada)
      --[[ vim.lsp.config("ty", {
        capabilities = capabilities,
        cmd = { "py", "-m", "ty", "server" },
        single_file_support = true,
        root_markers = {
          "ty.toml",
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          ".git",
        },
        settings = {
          ty = {
            diagnosticMode = "workspace",
            completions = {
              autoImport = false,
            },
          },
        },
      })
      vim.lsp.enable("ty") ]]

      -- ruff (config antiga para referência)
      --[[ vim.lsp.config("ruff", {
        capabilities = capabilities,
        single_file_support = true,
      }) ]]
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        single_file_support = true,
        init_options = {
          settings = {
            organizeImports = true,
            fixAll = true,
          },
        },
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      vim.lsp.config("clangd", {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--log=error",
          "--offset-encoding=utf-16",
          "--limit-results=100",
          "--query-driver=/usr/bin/gcc,/usr/bin/g++,/usr/bin/clang,/usr/bin/clang++",
        },
      })
      vim.lsp.config("arduino",{
        capabilities = capabilities
      })
      --[[ vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
        check = { command = "check" },
        checkOnSave = false,
      }) ]]

      -- Instala e auto-enable (via vim.lsp.enable) — exclui jdtls (você usa no ftplugin)
      local ensure = {
        "lua_ls",
        -- "basedpyright",
        "pyrefly",
        "ruff",
        "clangd",
        ts_server,
        "tailwindcss",
        "eslint",
        "html",
        "cssls",
        "jsonls",
        "emmet_ls",
        "rust_analyzer",
        "intelephense",
      }

      require("mason-lspconfig").setup({
        ensure_installed = ensure,
        automatic_enable = {
          exclude = { "jdtls", "rust_analyzer", "basedpyright", "ty" },
        },
      })
    end,
  },

  -- 3) Autocomplete (mantive seu setup, só “limpei” formatação)
  {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      vim.schedule(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)

      local has_tw, tw = pcall(require, "tailwindcss-colorizer-cmp")
      if has_tw then
        tw.setup({ color_square_width = 2 })
      end

      local source_menu = {
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]"
      }

      local tw_formatter = function (entry, item)
        if has_tw then
          return tw.formatter(entry,item)
        end
        return item
      end

      cmp.setup({
        -- Performance máxima: debounce rápido, limite de renderização de itens na tela
        performance = {
          debounce = 40,
          throttle = 20,
          fetching_timeout = 200,
          max_view_entries = 20,
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Fontes balanceadas e com limites de itens para resposta instantânea
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000, max_item_count = 15 },
          { name = "luasnip", priority = 750, max_item_count = 4 },
          { name = "buffer", priority = 500, keyword_length = 3, max_item_count = 4 },
          { name = "path", priority = 250, max_item_count = 3 },
        }),

        -- Ordenação inteligente de relevância
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            scrolloff = 2,
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
          },
        },

        formatting = {
          format = function(entry, item)
            item.menu = source_menu[entry.source.name]
            if item.abbr and #item.abbr > 40 then
              item.abbr = string.sub(item.abbr, 1, 37) .. "..."
            end
            return tw_formatter(entry, item)
          end,
        },
      })
    end,
  }
}


