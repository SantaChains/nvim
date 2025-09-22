return {
{
    "mason-org/mason.nvim",
    version = "v2.0.1", -- 锁定最新稳定版本
    dependencies = {
        "mason-org/mason-lspconfig.nvim",     -- LSP 安装集成
        -- "mfussenegger/nvim-dap",              -- DAP 调试器核心 (已禁用)
        -- "jay-babu/mason-nvim-dap.nvim",       -- DAP 调试器集成 (已禁用)
        -- LazyVim 现在默认使用 conform.nvim 和 nvim-lint
        -- 如需使用 none-ls，请启用 lazyvim.plugins.extras.lsp.none-ls extra
    },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    build = ":MasonUpdate",  -- 确保 Mason 更新到最新版本
    keys = {
        { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason 包管理器" },
    },
    opts = {
        -- 完整的工具安装列表，包含所有 example 中的配置
        -- 注意：已移除 Ruby、PHP、Julia 相关工具，因为这些语言环境不可用
        ensure_installed = {
            -- 格式化工具
            "stylua",           -- Lua 格式化
            "shfmt",            -- Shell 格式化
            "prettier",         -- Web 前端格式化
            "black",            -- Python 格式化
            "ruff",             -- Python 快速格式化和诊断
            "isort",            -- Python 导入排序
            "beautysh",         -- Bash 美化
            "clang-format",     -- C/C++/Java 格式化
            -- "gofumpt",          -- Go 增强格式化 (已禁用，暂不支持 Go 开发)
            -- "rustfmt",          -- Rust 格式化 (已移除)
            
            -- LSP 服务器 (来自 example.lua)
            "lua-language-server",          -- Lua
            "pyright",                      -- Python 类型检查
            -- "ruff-lsp",                     -- Python 快速 LSP (已移除)
            "typescript-language-server",   -- TypeScript/JavaScript
            -- "gopls",                        -- Go LSP 服务器 (已禁用，暂不支持 Go 开发)
            "rust-analyzer",                -- Rust
            "clangd",                       -- C/C++
            "jdtls",                        -- Java
            "html-lsp",                     -- HTML
            "css-lsp",                      -- CSS
            "bash-language-server",         -- Bash
            "json-lsp",                     -- JSON
            "yaml-language-server",         -- YAML
            "dockerfile-language-server",   -- Dockerfile
            "marksman",                     -- Markdown
            "sqlls",                        -- SQL
            
            -- DAP 调试器 (统一管理，配合 mason-nvim-dap) (已禁用)
            -- "debugpy",          -- Python 调试
            -- "codelldb",         -- C/C++/Rust 调试
            -- "cpptools",         -- C/C++ 调试 (Microsoft C/C++ Extension)
            -- "delve",            -- Go 调试器 (已禁用，暂不支持 Go 开发)
            -- "js-debug-adapter", -- JavaScript/TypeScript 调试
            
            -- Linter 和诊断工具
            "eslint-lsp",                   -- JavaScript/TypeScript 代码检查
            -- "golangci-lint-langserver",     -- Go 代码检查 (已禁用，暂不支持 Go 开发)
            "shellcheck",                   -- Shell 脚本检查
            "flake8",                       -- Python 代码检查
            "hadolint",                     -- Dockerfile 检查
            "vale",                         -- 文档和 Markdown 检查
            "markdownlint",                 -- Markdown 检查
            "jsonlint",                     -- JSON 检查
            "yamllint",                     -- YAML 检查
        },
        max_concurrent_installers = 8,  -- 并行安装加速
        ui = {
            check_outdated_packages_on_open = true,  -- 打开时检查过期包
            border = "rounded",
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
            keymaps = {
                toggle_package_expand = "<CR>",  -- 展开包详情
                install_package = "i",           -- 安装包
                update_package = "u",            -- 更新包
                check_package_version = "c",     -- 检查版本
                update_all_packages = "U",       -- 更新所有包
                check_outdated_packages = "C",   -- 检查过期包
                uninstall_package = "X",         -- 卸载包
                cancel_installation = "<C-c>",   -- 取消安装
                apply_language_filter = "<C-f>", -- 语言过滤
                toggle_package_install_log = "<C-l>", -- 显示安装日志
            },
        },
        -- 安装路径配置
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        -- 自定义包安装程序
        registries = {
            "github:mason-org/mason-registry",  -- 默认注册表
        },
        -- 代理设置 (如果需要)
        -- http_proxy = "http://proxy.example.com:8080",
        -- https_proxy = "http://proxy.example.com:8080",
        -- no_proxy = "localhost,127.0.0.1",
        
        -- 日志级别
        log_level = vim.log.levels.INFO,
    },
    config = function(_, opts)
        -- 配置 Mason 跳过不可用语言的检查
        opts.skip_language_servers = opts.skip_language_servers or {}
        table.insert(opts.skip_language_servers, "ruby")
        table.insert(opts.skip_language_servers, "php")
        table.insert(opts.skip_language_servers, "julia")
        
        -- 定义不可用语言的包列表，避免安装和检查
        local unavailable_language_packages = {
            -- Ruby 相关包
            "solargraph", "ruby-lsp", "rubocop", "rufo", "rubyfmt",
            -- PHP 相关包  
            "phpactor", "intelephense", "php-cs-fixer", "phpcbf", "phpcs",
            "phpmd", "phpstan", "psalm", "php-debug-adapter",
            -- Julia 相关包
            "julia-lsp", "julials",
        }
        
        local function is_package_available(package_name)
            -- 检查是否在不可用语言包列表中
            for _, unavailable in ipairs(unavailable_language_packages) do
                if package_name == unavailable then
                    return false
                end
            end
            return true
        end
        
        require("mason").setup(opts)
        
        -- 配置 Mason 注册表跳过不可用语言的包
        local registry = require("mason-registry")
        local original_get_package = registry.get_package
        registry.get_package = function(name)
            -- 跳过不可用语言的包
            if not is_package_available(name) then
                return nil
            end
            return original_get_package(name)
        end
        
        -- 配置 mason-lspconfig (移除重复的 LSP 配置，由 lsp-config.lua 统一管理)
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",           -- Lua (lua-language-server)
                "pyright",          -- Python 类型检查
                "ts_ls",            -- TypeScript/JavaScript (修复：从 tsserver 更名为 ts_ls)
                "rust_analyzer",    -- Rust (rust-analyzer)
                "clangd",           -- C/C++
                "jdtls",            -- Java
                "html",             -- HTML (html-lsp)
                "cssls",            -- CSS (css-lsp)
                "bashls",           -- Bash (bash-language-server)
                "jsonls",           -- JSON (json-lsp)
                "yamlls",           -- YAML (yaml-language-server)
                "dockerls",         -- Dockerfile (dockerfile-language-server)
                "marksman",         -- Markdown
                "sqlls",            -- SQL
                "eslint",           -- JavaScript/TypeScript 代码检查
                -- 注意：已移除 Ruby、PHP、Julia 相关 LSP 服务器，因为这些语言环境不可用
            },
            -- 禁用自动安装和处理器，由 lsp-config.lua 统一管理
            automatic_installation = false,
            automatic_enable = false,  -- 禁用自动启用，由 lsp-config.lua 手动控制
        })
        
        -- 配置 mason-nvim-dap (依赖 Mason 的统一安装，不重复安装) (已禁用)
        -- require("mason-nvim-dap").setup({
            -- 不再使用 ensure_installed，避免与 Mason 冲突
            -- ensure_installed = {},  -- 由 Mason 的 opts.ensure_installed 统一管理
            -- automatic_installation = false,  -- 禁用自动安装，避免冲突
            -- handlers = {
                -- 默认处理器：自动配置所有已安装的调试器
                -- function(config)
                    -- require('mason-nvim-dap').default_setup(config)
                -- end,
            -- },
        -- })
        
        -- 优化的自动安装配置（避免重复安装冲突）
        local mr = require("mason-registry")
        
        local function safe_ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                -- 跳过不可用语言的包
                if not is_package_available(tool) then
                    print("跳过不可用语言的包: " .. tool)
                    goto continue
                end
                
                local p = mr.get_package(tool)
                -- 只在包未安装且未在安装中时才安装
                if not p:is_installed() and not p:is_installing() then
                    vim.schedule(function()
                        p:install()
                    end)
                end
                ::continue::
            end
        end
        
        -- 延迟执行安装，避免初始化冲突
        vim.defer_fn(function()
            if mr.refresh then
                mr.refresh(safe_ensure_installed)
            else
                safe_ensure_installed()
            end
        end, 1000)  -- 1秒延迟
    end,
},
}