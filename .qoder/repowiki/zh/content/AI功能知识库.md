<docs>
# AI功能知识库

<cite>
**本文档引用的文件**  
- [ai.md](file://lua/backup/design/ai.md)
- [glm4-config.lua](file://lua/backup/design/glm4-config.lua)
- [blink-cmp.lua](file://lua/backup/plugins/blink-cmp.lua)
- [essential.lua](file://lua/backup/plugins/essential.lua)
- [editor-enhance.lua](file://lua/backup/plugins/editor-enhance.lua)
- [snacks.lua](file://lua/backup/plugins/snacks.lua)
- [snack.lua](file://lua/plugins/snack.lua)
</cite>

## 目录
1. [简介](#简介)
2. [AI补全增强](#ai补全增强)
3. [智能替换与重构](#智能替换与重构)
4. [代码片段辅助](#代码片段辅助)
5. [AI提交信息生成](#ai提交信息生成)
6. [配置方法](#配置方法)
7. [集成方式](#集成方式)
8. [使用案例](#使用案例)
9. [故障排除指南](#故障排除指南)
10. [附录](#附录)

## 简介
本文档详细介绍了Neovim配置中的AI辅助开发功能，涵盖AI补全、智能替换、代码片段辅助和AI提交信息生成等核心子功能。文档提供了各功能的配置方法、使用场景、API接口及与其他模块的集成方式，并包含实际使用案例和故障排除指南。

## AI补全增强

AI补全功能基于`blink.cmp`插件实现，集成了GLM-4等AI模型提供智能代码补全建议。该功能通过配置AI提供程序和参数，实现高质量的代码补全体验。

**AI补全配置**
```lua
avante = {
    module = "blink-cmp-avante",
    name = "Avante",
    score_offset = 1,
    opts = {
        glm4 = {
            enabled = true,
            provider = "glm4",
            api_key = os.getenv("GLM4_API_KEY") or "",
            api_url = "https://open.bigmodel.cn/api/paas/v4",
            model = "glm-4-flash",
            temperature = 0.3,
            max_tokens = 2048,
            timeout = 10000,
            retry_count = 3,
        },
    },
},
```

**AI补全源配置**
```lua
sources = {
    default = {
        "buffer",
        "lsp",
        "path",
        "snippets",
        "avante",
        "glm4",
    },
    providers = {
        buffer = { score_offset = 4 },
        path = { score_offset = 3 },
        snippets = { score_offset = 1 },
        lsp = { score_offset = 10 },
    },
}
```

**AI补全行为配置**
```lua
behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
}
```

**AI补全窗口配置**
```lua
windows = {
    position = "right",
    wrap = true,
    width = 50,
    sidebar_header = {
        enabled = true,
        align = "center",
        rounded = true,
    },
    input = {
        prefix = "> ",
        height = 8,
    },
    edit = {
        border = "rounded",
    },
    ask = {
        floating = false,
        border = "rounded",
    },
}
```

**AI补全快捷键映射**
```lua
mappings = {
    ask = "<leader>ga",
    edit = "<leader>ge",
    refresh = "<leader>gr",
    diff = {
        ours = "co",
        theirs = "ct",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
    },
    jump = {
        next = "]]",
        prev = "[[",
    },
    submit = {
        normal = "<CR>",
        insert = "<C-s>",
    },
    toggle = {
        debug = "<leader>gd",
        hint = "<leader>gh",
    },
}
```

**AI补全模型信息**
```lua
model_info = {
    ["glm-4-flash"] = {
        description = "GLM-4 快速版，适合日常编程任务",
        max_tokens = 8192,
        context_length = 128000,
    },
    ["glm-4"] = {
        description = "GLM-4 标准版，综合能力最强",
        max_tokens = 8192,
        context_length = 128000,
    },
    ["glm-4-air"] = {
        description = "GLM-4 轻量版，平衡性能和成本",
        max_tokens = 8192,
        context_length = 128000,
    },
}
```

**AI补全API配置**
```lua
api_config = {
    endpoint = "https://open.bigmodel.cn/api/paas/v4",
    model = "glm-4-flash",
    api_key = "033e984ae7294bac8a9cd62f93c3830d.GAXKvN5oWflJ5GR6",
    timeout = 30000,
    max_tokens = 4096,
    temperature = 0.3,
    top_p = 0.7,
}
```

**AI补全请求参数解析**
```lua
parse_curl_args = function(opts, code_opts)
    local api_key = os.getenv(opts.api_key_name) or M.api_config.api_key
    
    return {
        url = opts.endpoint .. "/chat/completions",
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. api_key,
            ["Accept"] = "application/json",
        },
        body = {
            model = opts.model,
            messages = {
                {
                    role = "system",
                    content = "你是一个专业的编程助手，擅长代码分析、优化和解释。"
                },
                {
                    role = "user",
                    content = code_opts.question or "请分析这段代码"
                }
            },
            temperature = opts.temperature,
            top_p = opts.top_p,
            max_tokens = opts.max_tokens,
            stream = false,
        },
        timeout = opts.timeout,
    }
end,
```

**AI补全响应解析**
```lua
parse_response = function(data_stream, event_state, opts)
    if event_state == "done" then
        opts.on_complete()
        return
    end
    
    if data_stream == nil or data_stream == "" then
        return
    end
    
    local ok, json = pcall(vim.json.decode, data_stream)
    if not ok then
        opts.on_complete("JSON解析错误: " .. tostring(json))
        return
    end
    
    if json.choices and json.choices[1] and json.choices[1].message then
        local content = json.choices[1].message.content
        if content then
            opts.on_chunk(content)
        end
    elseif json.error then
        opts.on_complete("API错误: " .. tostring(json.error.message))
    end
end,
```

**AI补全环境变量设置**
```lua
function M.setup_environment()
    vim.env.GLM4_API_KEY = M.api_config.api_key
end
```

**AI补全验证功能**
```lua
function M.validate_api_key()
    local key = M.api_config.api_key
    if not key or key == "" then
        return false, "API 密钥未设置"
    end
    
    if not key:match("^%w+%.%w+") or #key < 30 then
        return false, "API 密钥格式不正确"
    end
    
    return true, "API 密钥有效"
end
```

**AI补全缓存配置**
```lua
cache = {
    enabled = true,
    max_size = 100,
    ttl = 3600,
}
```

**AI补全调试配置**
```lua
debug = false,
```

**AI补全高亮配置**
```lua
highlights = {
    diff = {
        current = "DiffText",
        incoming = "DiffAdd",
    },
}
```

**AI补全系统提示**
```lua
prompts = {
    system = {
        role = "system",
        content = "你是一个专业的编程助手，擅长代码分析、优化和解释。",
    },
}
```

**AI补全提供程序模板**
```lua
provider_template = {
    endpoint = M.api_config.endpoint,
    model = M.api_config.model,
    api_key_name = "GLM4_API_KEY",
    timeout = M.api_config.timeout,
    max_tokens = M.api_config.max_tokens,
    temperature = M.api_config.temperature,
    top_p = M.api_config.top_p,
}
```

**AI补全可用模型**
```lua
available_models = {
    "glm-4-flash",
    "glm-4",
    "glm-4-air",
    "glm-4-airx",
    "glm-4v",
    "glm-3-turbo",
}
```

**AI补全更新配置**
```lua
function M.update_config(new_config)
    for k, v in pairs(new_config) do
        if M.api_config[k] ~= nil then
            M.api_config[k] = v
        end
    end
    
    M.provider_template.endpoint = M.api_config.endpoint
    M.provider_template.model = M.api_config.model
    M.provider_template.timeout = M.api_config.timeout
    M.provider_template.max_tokens = M.api_config.max_tokens
    M.provider_template.temperature = M.api_config.temperature
    M.provider_template.top_p = M.api_config.top_p
    
    M.setup_environment()
end
```

**AI补全获取配置**
```lua
function M.get_config()
    return vim.deepcopy(M.api_config)
end
```

**AI补全获取模型信息**
```lua
function M.get_model_info(model)
    return M.model_info[model] or {
        description = "未知模型",
        max_tokens = 4096,
        context_length = 32000,
    }
end
```

**AI补全获取avante配置**
```lua
function M.get_avante_config()
    return {
        provider = "glm4",
        providers = {
            glm4 = M.provider_template,
        },
        behaviour = {
            auto_suggestions = false,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
        },
        mappings = {
            ask = "<leader>ga",
            edit = "<leader>ge",
            refresh = "<leader>gr",
            diff = {
                ours = "co",
                theirs = "ct",
                both = "cb",
                cursor = "cc",
                next = "]x",
                prev = "[x",
            },
            jump = {
                next = "]]",
                prev = "[[",
            },
            submit = {
                normal = "<CR>",
                insert = "<C-s>",
            },
            toggle = {
                debug = "<leader>gd",
                hint = "<leader>gh",
            },
        },
        prompts = {
            system = {
                role = "system",
                content = "你是一个专业的编程助手，擅长代码分析、优化和解释。",
            },
        },
        windows = {
            position = "right",
            wrap = true,
            width = 50,
            sidebar_header = {
                enabled = true,
                align = "center",
                rounded = true,
            },
            input = {
                prefix = "> ",
                height = 8,
            },
            edit = {
                border = "rounded",
            },
            ask = {
                floating = false,
                border = "rounded",
            },
        },
        highlights = {
            diff = {
                current = "DiffText",
                incoming = "DiffAdd",
            },
        },
        debug = false,
        cache = {
            enabled = true,
            max_size = 100,
            ttl = 3600,
        },
    }
end
```

**AI补全快捷键配置**
```lua
keymap = {
    preset = "none",
    ["<S-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<CR>"] = { "accept", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-e>"] = { "snippet_forward", "select_next", "fallback" },
    ["<C-u>"] = { "snippet_backward", "select_prev", "fallback" },
}
```

**AI补全签名配置**
```lua
signature = {
    enabled = true,
}
```

**AI补全完成配置**
```lua
completion = {
    keyword = { range = "full" },
    documentation = { auto_show = true, auto_show_delay_ms = 0 },
    list = { selection = { preselect = false, auto_insert = false } },
    menu = {
        draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
                label = {
                    text = function(ctx)
                        local m = require("lib.safe_require").safe_require("colorful-menu")
                        return m and m.blink_components_text(ctx) or ctx.label
                    end,
                    highlight = function(ctx)
                        local m = require("lib.safe_require").safe_require("colorful-menu")
                        return m and m.blink_components_highlight(ctx) or "BlinkCmpLabel"
                    end,
                },
            },
        },
    },
}
```

**AI补全启用条件**
```lua
enabled = function()
    return not vim.tbl_contains({
    }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
end,
```

**AI补全外观配置**
```lua
appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
}
```

**AI补全依赖配置**
```lua
dependencies = {
    "xzbdmw/colorful-menu.nvim",
    "rafamadriz/friendly-snippets",
    "Kaiser-Yang/blink-cmp-avante",
},
event = "BufReadPost,BufNewFile",
```

**AI补全命令行配置**
```lua
cmdline = {
    keymap = {
        ["<CR>"] = { "select_and_accept", "fallback" },
    },
    completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
            auto_show = function(ctx)
                return vim.fn.getcmdtype() == ":"
            end,
        },
        ghost_text = { enabled = false },
        min_keyword_length = function(ctx)
            if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
            end
            return 0
        end,
    },
}
```

**AI补全优先级配置**
```lua
score_offset = 1,
```

**AI补全提供程序配置**
```lua
opts = {
    enabled = true,
    provider = "glm4",
    api_key = os.getenv("ZHIPUAI_API_KEY") or "",
    api_url = "https://open.bigmodel.cn/api/paas/v4", 
    model = "glm-4-flash",
    temperature = 0.3,
    max_tokens = 2048,
    timeout = 10000,
    retry_count = 3,
    glm4_params = {
        top_p = 0.7,
        frequency_penalty = 0.1,
        presence_penalty = 0.1,
        safe_mode = true,
    },
}
```

**AI补全模块配置**
```lua
module = "blink-cmp-avante",
```

**AI补全名称配置**
```lua
name = "GLM-4",
```

**AI补全扩展配置**
```lua
opts_extend = { "sources.default" },
```

**AI补全事件配置**
```lua
event = { 'InsertEnter', 'CmdlineEnter' }, 
```

**AI补全版本配置**
```lua
version = "*",
```

**AI补全类型配置**
```lua
---@module 'blink.cmp'
---@type blink.cmp.Config
```

**AI补全延迟加载配置**
```lua
lazy = false,
```

**AI补全优先级配置**
```lua
priority = 1000,
```

**AI补全命令配置**
```lua
cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
```

**AI补全构建配置**
```lua
build = ":MasonUpdate", 
```

**AI补全键位配置**
```lua
keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason 包管理器" },
},
```

**AI补全确保安装配置**
```lua
ensure_installed = {
    "stylua",           
    "shfmt",            
    "prettier",         
    "black",            
    "ruff",             
    "isort",            
    "beautysh",         
    "clang-format",     
    "lua-language-server",          
    "pyright",                      
    "typescript-language-server",   
    "rust-analyzer",                
    "clangd",                       
    "jdtls",                        
    "html-lsp",                     
    "css-lsp",                      
    "bash-language-server",         
    "json-lsp",                     
    "yaml-language-server",         
    "dockerfile-language-server",   
    "marksman",                     
    "sqlls",                        
    "debugpy",          
    "codelldb",         
    "cpptools",         
    "js-debug-adapter", 
    "eslint-lsp",                   
    "shellcheck",                   
    "flake8",                       
    "hadolint",                     
    "vale",                         
    "markdownlint",                 
    "jsonlint",                     
    "yamllint",                     
},
```

**AI补全最大并发安装配置**
```lua
max_concurrent_installers = 8, 
```

**AI补全UI配置**
```lua
ui = {
    check_outdated_packages_on_open = true,  
    border = "rounded",
    width = 0.8,
    height = 0.8,
    icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
    },
    keymaps = {
        toggle_package_expand = "<CR>",  
        install_package = "i",           
        update_package = "u",            
        check_package_version = "c",     
        update_all_packages = "U",       
        check_outdated_packages = "C",   
        uninstall_package = "X",         
        cancel_installation = "<C-c>",   
        apply_language_filter = "<C-f>", 
        toggle_package_install_log = "<C-l>", 
    },
},
```

**AI补全安装根目录配置**
```lua
install_root_dir = vim.fn.stdpath("data") .. "/mason",
```

**AI补全注册表配置**
```lua
registries = {
    "github:mason-org/mason-registry",  
},
```

**AI补全日志级别配置**
```lua
log_level = vim.log.levels.INFO,
```

**AI补全LSP配置**
```lua
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",           
        "pyright",          
        "ts_ls",            
        "rust_analyzer",    
        "clangd",           
        "jdtls",            
        "html",             
        "cssls",            
        "bashls",           
        "jsonls",           
        "yamlls",           
        "dockerls",         
        "marksman",         
        "sqlls",            
        "eslint",           
    },
    automatic_installation = false,
    automatic_enable = false,  
})
```

**AI补全DAP配置**
```lua
require("mason-nvim-dap").setup({
    automatic_installation = false,  
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end,
    },
})
```

**AI补全安全确保安装配置**
```lua
local mr = require("mason-registry")
local function safe_ensure_installed()
    for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() and not p:is_installing() then
            vim.schedule(function()
                p:install()
            end)
        end
    end
end
```

**AI补全延迟执行安装配置**
```lua
vim.defer_fn(function()
    if mr.refresh then
        mr.refresh(safe_ensure_installed)
    else
        safe_ensure_installed()
    end
end, 1000)  
```

**AI补全状态栏配置**
```lua
status = {
    enabled = true,
    signs = true,
    virtual_text = true
},
```

**AI补全输出配置**
```lua
output = {
    enabled = true,
    open_on_run = true
},
```

**AI补全摘要配置**
```lua
summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
        attach = 'a',
        expand = 'e',
        expand_all = 'E',
        jumpto = 'i',
        output = 'o',
        run = 'r',
        short = 's',
        stop = 'x'
    }
},
```

**AI补全诊断配置**
```lua
diagnostic = {
    enabled = true,
    severity = 1
},
```

**AI补全运行配置**
```lua
run = {
    enabled = true,
    concurrent = true,
    parallel = 4
},
```

**AI补全发现配置**
```lua
discovery = {
    enabled = true,
    concurrent = true,
    parallel = 4
},
```

**AI补全自动命令配置**
```lua
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*test*", "test_*"},
    callback = function()
        if vim.bo.filetype == "python" or vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
            neotest.run.run()
        end
    end,
    group = vim.api.nvim_create_augroup("NeotestAutoRun", { clear = true })
})
```

**AI补全Python适配器配置**
```lua
local python_adapter_ok, python_adapter = pcall(require, 'neotest-python')
if python_adapter_ok then
    table.insert(adapters, python_adapter({
        dap = { justMyCode = false },
        runner = "pytest",
        python = ".venv/bin/python", 
        is_test_file = function(file_path)
            return file_path:match("test_.*%.py$") or file_path:match(".*_test%.py$")
        end
    }))
end
```

**AI补全JavaScript适配器配置**
```lua
local jest_adapter_ok, jest_adapter = pcall(require, 'neotest-jest')
if jest_adapter_ok then
    table.insert(adapters, jest_adapter({
        jestCommand = "npm test --",
        jestConfigFile = "custom.jest.config.ts",
        env = { CI = true },
        cwd = function(path)
            return vim.fn.getcwd()
        end
    }))
end
```

**AI补全Go适配器配置**
```lua
local go_adapter_ok, go_adapter = pcall(require, 'neotest-go')
if go_adapter_ok then
    table.insert(adapters, go_adapter({
        experimental = {
            test_table = true,
        },
        args = { '-count=1', '-timeout=60s' }
    }))
end
```

**AI补全RSpec适配器配置**
```lua
local rspec_adapter_ok, rspec_adapter = pcall(require, 'neotest-rspec')
if rspec_adapter_ok then
    table.insert(adapters, rspec_adapter({
        rspec_cmd = function()
            return vim.tbl_flatten({
                'bundle',
                'exec',
                'rspec',
            })
        end
    }))
end
```

**AI补全测试运行配置**
```lua
running = {
    concurrent = true,
},
```

**AI补全虚拟文本格式配置**
```lua
virtual_text = {
    enabled = true,
    format = function(test_status)
        local status_map = {
            passed = '✓',
            failed = '✗', 
            skipped = '⊘',
            running