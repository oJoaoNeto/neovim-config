return {
  "mrcjkb/rustaceanvim",
  ft = "rust",
  init  = function ()

    --Grupo para formatar on save do Rust(rustfmt e rust-analyzer)
    local rust_fmt_group = vim.api.nvim_create_augroup("RustFmtOnSave", { clear = true })

    --config via vim.g.rustaceanvim
    vim.g.rustaceanvim = {

      server = {
        settings = {
          ["rust-analyzer"] = {
            cargo = { buildScripts = { enable = true } },
            procMacro = { enable = true },
            checkOnSave = true,
          },
        },
        on_attach = function (client, bufnr)

          -- Rustfmt no save do arquivo
          if client and client.supports_method and client:supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = rust_fmt_group, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = rust_fmt_group,
              buffer = bufnr,

              callback = function ()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  async = true,
                  filter = function (c)
                    return c.name == "rust-analyzer"
                  end,
                })
              end,
            })
          end


        end,
      },
    }
  end,
}

