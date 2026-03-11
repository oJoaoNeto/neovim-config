
-- Remove o autocmd do rust.vim que roda rustfmt no BufWritePre.
pcall(vim.api.nvim_clear_autocmds, { group = "rust.vim.PreWrite" })

local function rmap(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { buffer = true, noremap = true, silent = true, desc = desc })
end

rmap("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Rust: Runnables")
rmap("<leader>rt", function() vim.cmd.RustLsp("testables") end, "Rust: Testables")
rmap("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Rust: Debuggables (DAP)")

if vim.fn.exists(":RustAnalyzer") == 2 then
  pcall(vim.cmd, "RustAnalyzer start")
end
