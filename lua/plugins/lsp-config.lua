-- LSP 统一配置文件 (Windows 本地化适配)
-- 基于 Neovim 0.11+ 和 nvim-lspconfig 2024 最新标准
-- 职责：统一管理所有 LSP 服务器配置，避免重复和冲突
-- 参考：https://github.com/neovim/nvim-lspconfig#quickstart

-- Windows 本地化工具检测
local function get_windows_tool_path(tool_name, fallback_cmd)
  -- 优先使用 Mason 安装的工具
  local mason_path = vim.fn.stdpath("data") .. "/mason/bin/" .. tool_name .. ".exe"
  if vim.fn.executable(mason_path) == 1 then
    return mason_path
  end
  
  -- 回退到系统 PATH 中的工具
  if vim.fn.executable(tool_name) == 1 then
    return tool_name
  end
  
  -- 使用提供的备用命令
  return fallback_cmd or tool_name
end

-- Windows 路径处理
local function normalize_windows_path(path)
  if vim.fn.has("win32") == 1 then
    return path:gsub("/", "\\")
  end
  return path
end

return {
  -- nvim-lspconfig：提供预配置的 LSP 服务器配置
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/neoconf.nvim", 
        cmd = "Neoconf", 
        config = false,
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv", "vim%.loop" } },
            { path = "LazyVim", words = { "LazyVim" } },
            { path = "lazy.nvim", words = { "Lazy" } },
          },
        },
      },
      -- 可选：JSON/YAML schema 支持
      {
        "b0o/schemastore.nvim",
        lazy = true,
      },
    },
    
    opts = function()
      return {
        -- 诊断配置 (现代化版本)
        diagnostics = {
          underline = true,
          update_in_insert = false, -- 推荐：减少干扰
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true, -- 按严重程度排序
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.HINT] = " ",
              [vim.diagnostic.severity.INFO] = " ",
            },
          },
          float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
            max_width = 80,
            max_height = 20,
          },
        },
        
        -- 内联提示配置 (Neovim 0.10+)
        inlay_hints = {
          enabled = true,
          exclude = { "vue" },
        },
        
        -- Codelens 配置
        codelens = {
          enabled = true,
        },
        
        -- 文档高亮配置
        document_highlight = {
          enabled = true,
        },
        
        
        -- 服务器配置映射 (整合所有原有功能并增强，Windows 本地化适配)
        servers = {
          -- Lua LSP 增强配置 (整合 LSP/lua_ls.lua)
          lua_ls = {
            cmd = { get_windows_tool_path("lua-language-server", "lua-language-server") },
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                  return
                end
              end
              
              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  version = 'LuaJIT',
                  path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                  },
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                },
              })
            end,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { 
                  globals = { "vim" },
                  disable = { "missing-fields" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
                completion = {
                  callSnippet = "Replace",
                },
                hint = {
                  enable = true,
                  arrayIndex = "Auto",
                  await = true,
                  paramName = "All",
                  paramType = true,
                  semicolon = "All",
                },
              },
            },
          },
          
          -- Python LSP 配置 (整合 LSP/pyright.lua 和 basedpyright.lua)
          pyright = {
            cmd = { get_windows_tool_path("pyright-langserver", "pyright-langserver"), "--stdio" },
            root_dir = function(fname)
              local util = require('lspconfig.util')
              return util.root_pattern(
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                'requirements.txt',
                'Pipfile',
                'pyrightconfig.json',
                '.git'
              )(fname)
            end,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  autoImportCompletions = true,
                  diagnosticMode = "openFilesOnly",
                  completeFunctionParens = true,
                  indexing = true,
                  inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                  },
                  autoImportCompletions = true,
                  importFormat = "absolute",
                },
              },
            },
            on_attach = function(client, bufnr)
              -- 添加 Pyright 特定命令
              vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
                client:exec_cmd {
                  command = 'pyright.organizeimports',
                  arguments = { vim.uri_from_bufnr(bufnr) },
                }
              end, {
                desc = 'Organize Imports',
              })
              
              vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', function(opts)
                local path = opts.args
                local clients = vim.lsp.get_clients {
                  bufnr = bufnr,
                  name = 'pyright',
                }
                for _, c in ipairs(clients) do
                  if c.settings then
                    c.settings.python = vim.tbl_deep_extend('force', c.settings.python, { pythonPath = path })
                  else
                    c.config.settings = vim.tbl_deep_extend('force', c.config.settings, { python = { pythonPath = path } })
                  end
                  c.notify('workspace/didChangeConfiguration', { settings = nil })
                end
              end, {
                desc = 'Reconfigure pyright with the provided python path',
                nargs = 1,
                complete = 'file',
              })
            end,
          },
          
          -- BasedPyright (替代 Pyright，更快速)
          basedpyright = {
            cmd = { get_windows_tool_path("basedpyright-langserver", "basedpyright-langserver"), "--stdio" },
            root_dir = function(fname)
              local util = require('lspconfig.util')
              local dir_name = util.root_pattern(
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                'requirements.txt',
                'Pipfile',
                'pyrightconfig.json',
                '.git'
              )(fname)
              
              if dir_name == nil then
                return vim.fs.dirname(fname)
              else
                return dir_name
              end
            end,
            settings = {
              basedpyright = {
                analysis = { typeCheckingMode = 'off' },
              },
            },
          },
          
          -- Ruff (快速 Python Linter 和 Formatter)
          ruff = {
            cmd = { get_windows_tool_path("ruff", "ruff"), "server", "--preview" },
            init_options = {
              settings = {
                -- Ruff 配置
                args = {},
              }
            },
          },
          
          -- C/C++ LSP 配置 (整合 LSP/clangd.lua)
          clangd = {
            cmd = {
              get_windows_tool_path("clangd", "clangd"),
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",          -- 格式化兜底风格
            },
            capabilities = {
              textDocument = {
                completion = {
                  editsNearCursor = true,
                  completionItem = {
                    snippetSupport = true,
                  },
                },
                formatting = {
                  dynamicRegistration = true,     -- 显式开启格式化能力
                },
              },
              offsetEncoding = { "utf-8", "utf-16" },
            },
            settings = {
              clangd = {
                arguments = {
                  "--header-insertion=iwyu",
                  "--completion-style=detailed",
                  "--function-arg-placeholders",
                  "--fallback-style=llvm",
                },
              },
            },
            root_dir = function(fname)
              local util = require('lspconfig.util')
              return util.root_pattern(
                '.clangd',
                '.clang-tidy',
                '.clang-format',
                'compile_commands.json',
                'compile_flags.txt',
                'configure.ac'
              )(fname)
            end,
            single_file_support = true,
          },
          
          -- TypeScript/JavaScript LSP
          ts_ls = {
            cmd = { get_windows_tool_path("typescript-language-server", "typescript-language-server"), "--stdio" },
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                },
                suggest = {
                  autoImports = true,
                  includeCompletionsForModuleExports = true,
                  includeCompletionsWithSnippetText = true,
                  includeAutomaticOptionalChainCompletions = true,
                  providePrefixAndSuffixTextForRename = true,
                },
                completion = {
                  completeFunctionCalls = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                },
                suggest = {
                  autoImports = true,
                  includeCompletionsForModuleExports = true,
                  includeCompletionsWithSnippetText = true,
                  includeAutomaticOptionalChainCompletions = true,
                  providePrefixAndSuffixTextForRename = true,
                },
                completion = {
                  completeFunctionCalls = true,
                },
              },
            },
          },
          
          -- Rust LSP
          rust_analyzer = {
            cmd = { get_windows_tool_path("rust-analyzer", "rust-analyzer") },
            settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                inlayHints = {
                  chainingHints = { enable = true },
                  parameterHints = { enable = true },
                  typeHints = { enable = true },
                },
                completion = {
                  addCallParenthesis = true,
                  addCallArgumentSnippets = true,
                  postfix = { enable = true },
                  autoimport = { enable = true },
                },
                assist = {
                  importGranularity = "module",
                  importPrefix = "by_self",
                },
              },
            },
          },
          
          -- Java LSP
          jdtls = {
            cmd = { get_windows_tool_path("jdtls", "jdtls") },
          },
          
          -- Web 相关 LSP
          html = {
            cmd = { get_windows_tool_path("vscode-html-language-server", "vscode-html-language-server"), "--stdio" },
          },
          cssls = {
            cmd = { get_windows_tool_path("vscode-css-language-server", "vscode-css-language-server"), "--stdio" },
          },
          
          -- Shell LSP
          bashls = {
            cmd = { get_windows_tool_path("bash-language-server", "bash-language-server"), "start" },
          },
          
          -- JSON LSP (整合 SchemaStore)
          jsonls = {
            cmd = { get_windows_tool_path("vscode-json-language-server", "vscode-json-language-server"), "--stdio" },
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              local ss = require("lib.safe_require").safe_require("schemastore")
              if ss then
                vim.list_extend(new_config.settings.json.schemas, ss.json.schemas())
              end
            end,
            settings = {
              json = {
                format = { enable = true },
                validate = { enable = true },
              },
            },
          },
          
          -- YAML LSP (整合 SchemaStore)
          yamlls = {
            cmd = { get_windows_tool_path("yaml-language-server", "yaml-language-server"), "--stdio" },
            on_new_config = function(new_config)
              new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                "force",
                new_config.settings.yaml.schemas or {},
                (function()
                  local ss = require("lib.safe_require").safe_require("schemastore")
                  return ss and ss.yaml.schemas() or {}
                end)()
              )
            end,
            settings = {
              yaml = {
                keyOrdering = false,
                format = { enable = true },
                validate = true,
                schemaStore = { enable = false, url = "" },
              },
            },
          },
          
          -- Docker LSP
          dockerls = {
            cmd = { get_windows_tool_path("docker-langserver", "docker-langserver"), "--stdio" },
          },
          
          -- Markdown LSP (整合 LSP/marksman.lua)
          marksman = {
            cmd = { get_windows_tool_path("marksman", "marksman"), "server" },
          },
          
          -- SQL LSP
          sqlls = {
            cmd = { get_windows_tool_path("sql-language-server", "sql-language-server"), "up", "--method", "stdio" },
          },
          
          -- ESLint LSP
          eslint = {
            cmd = { get_windows_tool_path("vscode-eslint-language-server", "vscode-eslint-language-server"), "--stdio" },
            settings = {
              workingDirectories = { mode = "auto" },
            },
          },
          
          -- LaTeX LSP (整合 LSP/texlab.lua)
          texlab = {
            cmd = { get_windows_tool_path("texlab", "texlab") },
            settings = {
              texlab = {
                diagnostics = {
                  ignoredPatterns = {
                    'Overfull',
                    'Underfull',
                    'Package hyperref Warning',
                    'Float too large for page',
                    'contains only floats',
                  },
                },
              },
            },
          },
          
          -- Typst LSP (整合 LSP/tinymist.lua 功能)
          tinymist = {
            cmd = { get_windows_tool_path("tinymist", "tinymist") },
            root_dir = function(fname)
              local util = require('lspconfig.util')
              return util.root_pattern('*.typ', '.git')(fname)
            end,
            single_file_support = true,
          },
        },
        
        -- 服务器设置函数
        setup = {},
      }
    end,
    config = function(_, opts)
      -- 设置诊断符号
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- 配置诊断
      vim.diagnostic.config(opts.diagnostics or {
        virtual_text = {
          prefix = "●",
        },
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- LSP 处理器配置
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- 设置 LSP 快捷键 (Windows 优化版本)
      local function on_attach(client, bufnr)
        local keymap_opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- 核心导航快捷键
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Goto Declaration" }))
        vim.keymap.set("n", "gd", function()
          -- 优先使用 snacks.picker，回退到内置
          if pcall(require, "snacks") then
            require('snacks').picker.lsp_definitions()
          else
            vim.lsp.buf.definition()
          end
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Goto Definition" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Hover Documentation" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Goto Implementation" }))
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Signature Help" }))
        
        -- 工作区管理
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Add Workspace Folder" }))
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Remove Workspace Folder" }))
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: List Workspace Folders" }))
        
        -- 编辑操作
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Type Definition" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Rename" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Code Action" }))
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Code Action (Alt)" }))
        
        -- 引用和格式化
        vim.keymap.set("n", "gr", function()
          -- 优先使用 snacks.picker，回退到内置
          if pcall(require, "snacks") then
            require('snacks').picker.lsp_references()
          else
            vim.lsp.buf.references()
          end
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: References" }))
        -- 格式化已统一至 conform.nvim 管理，移除重复快捷键
        -- vim.keymap.set("n", "<leader>F", function()
        --   vim.lsp.buf.format({ async = true })
        -- end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Format" }))
        
        -- 诊断快捷键
        vim.keymap.set("n", "<leader>ld", function()
          vim.diagnostic.open_float({ source = true })
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Open Diagnostic" }))
        vim.keymap.set("n", "<leader>td", function()
          local current_config = vim.diagnostic.config()
          if current_config.virtual_text then
            vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
            vim.notify("Diagnostics disabled", vim.log.levels.INFO)
          else
            vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
            vim.notify("Diagnostics enabled", vim.log.levels.INFO)
          end
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Toggle Diagnostics" }))
        
        -- 启用文档高亮和内联提示 (如果支持的话)
        if opts.document_highlight and opts.document_highlight.enabled then
          if client.supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end
        
        -- 内联提示切换
        if opts.inlay_hints and opts.inlay_hints.enabled and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          vim.keymap.set("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Toggle Inlay Hints" }))
        end
      end

      -- 获取默认 capabilities (Windows 优化版本)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- 如果使用 blink.cmp，添加其 capabilities
      if pcall(require, "blink.cmp") then
        capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
      end
      
      -- 增强 capabilities 以支持更多LSP功能
      capabilities.textDocument.completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
          documentationFormat = { "markdown", "plaintext" },
          deprecatedSupport = true,
          preselectSupport = true,
          tagSupport = { valueSet = { 1 } },
          insertReplaceSupport = true,
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
          insertTextModeSupport = { valueSet = { 1, 2 } },
          labelDetailsSupport = true,
        },
      }
      
      -- 添加折叠支持
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- 使用新的 vim.lsp.config API 配置所有 LSP 服务器 (Neovim 0.11+)
      for server, config in pairs(opts.servers) do
        local server_config = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, config)
        
        -- 定义 LSP 配置
        vim.lsp.config(server, server_config)
        
        -- 启用 LSP 配置 (Neovim 0.11+ 必须显式启用)
        vim.lsp.enable(server)
      end
    end,
  },
}