
-- 0) Evita reexecutar tudo no mesmo buffer (se já tem jdtls neste buffer, sai)
local clients = vim.lsp.get_clients({ bufnr = 0, name = "jdtls" })
if clients and #clients > 0 then
  return
end

-- 1) Carrega nvim-jdtls
local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then
  vim.notify("nvim-jdtls nao encontrado. Instale mfussenegger/nvim-jdtls", vim.log.levels.WARN)
  return
end

local ok_setup, jdtls_setup = pcall(require, "jdtls.setup")
if not ok_setup then
  vim.notify("jdtls.setup nao encontrado (algo errado com nvim-jdtls)", vim.log.levels.ERROR)
  return
end

-- 2) Paths (Windows)
local data_dir = vim.fn.stdpath("data")
local mason_dir = data_dir .. "\\mason"
local jdtls_dir = mason_dir .. "\\packages\\jdtls"

-- Lombok 
local lombok_jar = mason_dir .. "\\share\\jdtls\\lombok.jar"
if vim.fn.filereadable(lombok_jar) == 0 then
  lombok_jar = jdtls_dir .. "\\lombok.jar"
end
if vim.fn.filereadable(lombok_jar) == 0 then
  vim.notify("lombok.jar nao encontrado (mason/share/jdtls/lombok.jar ou mason/packages/jdtls/lombok.jar)", vim.log.levels.ERROR)
  return
end

-- Launcher do JDTLS
local launcher_list = vim.fn.glob(jdtls_dir .. "\\plugins\\org.eclipse.equinox.launcher_*.jar", false, true)
local launcher_jar = launcher_list[1]
if not launcher_jar or launcher_jar == "" then
  vim.notify("Launcher do JDTLS nao encontrado em: " .. jdtls_dir .. "\\plugins\\", vim.log.levels.ERROR)
  return
end

-- 3) Root do projeto (Maven ou Gradle)
local root_markers = {
  ".git",
  "mvnw", "pom.xml",
  "gradlew", "build.gradle", "settings.gradle",
  "build.gradle.kts", "settings.gradle.kts",
}
local root_dir = jdtls_setup.find_root(root_markers)

if not root_dir then
  return
end

-- 4) Workspace por projeto
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = data_dir .. "\\site\\java\\workspace-root\\" .. project_name
vim.fn.mkdir(workspace_dir, "p")

-- 5) Java do sistema (preferindo JAVA_HOME)
local java_cmd
local java_home = os.getenv("JAVA_HOME")
if java_home and java_home ~= "" then
  java_cmd = java_home .. "\\bin\\java.exe"
end
if not java_cmd or vim.fn.executable(java_cmd) == 0 then
  java_cmd = vim.fn.exepath("java")
end
if not java_cmd or java_cmd == "" then
  java_cmd = "java"
end

-- 6) Config do JDTLS
local config = {
  cmd = {
    java_cmd,

    -- Lombok: use SOMENTE -javaagent (sem -Xbootclasspath/a)
    ("-javaagent:%s"):format(lombok_jar),

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",

    "-Dlog.protocol=false",
    "-Dlog.level=WARN",

    "-Xms256m",
    "-Xmx1024m",

    -- Em vez de ALL-SYSTEM (carrega até incubator modules), dá pra usar java.se (mais leve)
    "--add-modules=java.se",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    "-jar", launcher_jar,
    "-configuration", jdtls_dir .. "\\config_win",
    "-data", workspace_dir,
  },

  root_dir = root_dir,

  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 300,
  },

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },

      configuration = {
        updateBuildConfiguration = "interactive", -- evita rebuild agressivo
        runtimes = {},
      },

      -- Maven + Gradle
      import = {
        maven = { enabled = true },
        gradle = { enabled = true },
      },

      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },

      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
        },
      },
    },
  },

  init_options = {
    bundles = {},
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

-- 7) Start/Attach
jdtls.start_or_attach(config)

-- 8) Keymaps (buffer-local)
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end

map("n", "<leader>jo", jdtls.organize_imports, "Organizar imports")
map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Extrair variável")
map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Extrair método")
map("n", "<leader>jd", vim.lsp.buf.declaration, "Declaração")
map("n", "<leader>jD", vim.lsp.buf.definition, "Definição")
map("n", "K", vim.lsp.buf.hover, "Documentação")
map("n", "<leader>jr", vim.lsp.buf.rename, "Renomear")

-- 9) Indent local
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

vim.notify(("JDTLS iniciado: %s"):format(root_dir), vim.log.levels.INFO)

