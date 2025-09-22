-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- 你可以在这里添加任何额外的自动命令
-- 使用 `vim.api.nvim_create_autocmd`
-- 或者通过组名移除已有的自动命令（默认的组名以 `lazyvim_` 为前缀）
-- 例如：vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

local api = vim.api
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

-- 创建主自动命令组（确保每次加载都清空旧组）
local my_group = augroup("MyAutoCmds", {
    clear = true
})

--------------------------------------------------
-- 1. 终端设置优化
--------------------------------------------------
-- autocmd("TermOpen", {
--   group = my_group,
--   desc = "终端自动进入插入模式并优化显示",
--   callback = function()
--     -- 自动进入插入模式
--     vim.cmd.startinsert()
--     -- 终端中禁用行号（原配置显示行号可能影响体验）
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--     -- 额外添加：终端中禁用折行
--     vim.opt_local.wrap = false
--   end,
-- })

--------------------------------------------------
-- 2. 自动格式化配置 (由 LazyVim + conform.nvim 统一管理，避免重复配置)
--------------------------------------------------
-- 注释掉手动的格式化自动命令，LazyVim 会自动处理
-- autocmd("BufWritePre", {
--     group = my_group,
--     desc = "保存前自动使用LSP格式化代码",
--     pattern = {"*.lua", "*.py", "*.js", "*.ts", "*.jsx", "*.tsx", "*.go", "*.rs", "*.c", "*.cpp", "*.java", "*.json", "*.yaml", "*.yml"},
--     callback = function()
--         -- 获取文件大小，大文件使用异步格式化
--         local file_size = vim.fn.getfsize(vim.fn.expand('%'))
--         local use_async = file_size > 100000  -- 100KB以上使用异步格式化
--         
--         -- 仅在有可用LSP客户端时执行格式化
--         if #vim.lsp.get_active_clients({
--             bufnr = 0
--         }) > 0 then
--             -- 添加错误处理
--             local ok, err = pcall(function()
--                 vim.lsp.buf.format({
--                     async = use_async
--                 })
--             end)
--             
--             -- 格式化失败时通知用户
--             if not ok then
--                 vim.notify("格式化失败: " .. tostring(err), vim.log.levels.WARN)
--             end
--         end
--     end
-- })

--------------------------------------------------
-- 3. 折叠状态记忆与恢复
--------------------------------------------------
-- 保存折叠状态
autocmd({"BufLeave", "BufWritePost"}, {
    group = my_group,
    desc = "离开或保存文件时记录折叠状态",
    pattern = "?*", -- 匹配非空文件名
    command = "silent! mkview"
})

-- 恢复折叠状态
autocmd("BufReadPost", {
    group = my_group,
    desc = "打开文件时恢复之前的折叠状态",
    pattern = "?*",
    callback = function()
        -- 使用 pcall 避免错误中断
        pcall(function()
            if vim.fn.expand("%:p") ~= "" and vim.fn.filereadable(vim.fn.expand("%:p")) == 1 then
                vim.cmd("silent! loadview")
            end
        end)
    end
})

--------------------------------------------------
-- 4. 自动创建缺失的父目录
--------------------------------------------------
-- autocmd("BufWritePre", {
--     group = my_group,
--     desc = "保存文件时自动创建缺失的父目录",
--     pattern = "*",
--     callback = function(args)
--         local dir = vim.fn.fnamemodify(args.file, ":p:h")
--         -- 检查目录是否存在，不存在则创建
--         if vim.fn.isdirectory(dir) == 0 then
--             vim.fn.mkdir(dir, "p") -- "p"表示创建多级目录
--         end
--     end
-- })

--------------------------------------------------
-- 5. 文件类型特定配置
--------------------------------------------------
-- 自动加载LSP文件夹中的文件类型配置（替代after/ftplugin）
autocmd("FileType", {
    group = my_group,
    desc = "自动加载LSP文件夹中的文件类型配置",
    pattern = "*",
    callback = function(args)
        local filetype = args.match
        local lsp_config_path = vim.fn.stdpath('config') .. '/LSP/' .. filetype .. '.lua'
        
        -- 检查LSP配置文件是否存在
        if vim.fn.filereadable(lsp_config_path) == 1 then
            -- 使用pcall安全加载，避免错误中断
            local ok, err = pcall(function()
                dofile(lsp_config_path)
            end)
            
            if not ok then
                vim.notify(
                    string.format("加载 %s 文件类型配置失败: %s", filetype, err),
                    vim.log.levels.WARN
                )
            end
        end
    end
})

-- Lua文件配置
autocmd("FileType", {
    group = my_group,
    desc = "Lua文件类型配置",
    pattern = "lua",
    callback = function()
        vim.opt_local.expandtab = true -- 使用空格代替制表符
        vim.opt_local.tabstop = 2 -- 制表符宽度
        vim.opt_local.shiftwidth = 2 -- 自动缩进宽度
        vim.opt_local.smartindent = true -- 智能缩进
    end
})

-- 文本类文件配置
autocmd("FileType", {
    group = my_group,
    desc = "Markdown和文本文件配置",
    pattern = {"markdown", "text"},
    callback = function()
        vim.opt_local.spell = false -- 禁用拼写检查
        vim.opt_local.wrap = true -- 启用自动折行
        vim.opt_local.linebreak = true -- 按单词折行，避免截断单词
        vim.opt_local.scrolloff = 5 -- 上下滚动时保留5行边距
    end
})

--------------------------------------------------
-- 6. 可选：删除LazyVim默认自动命令
-- 取消下面一行的注释即可生效
--------------------------------------------------
-- api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

--------------------------------------------------
-- 诊断和LSP样式配置
--------------------------------------------------
-- 诊断显示样式
vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- 诊断前缀符号
        spacing = 2 -- 诊断文本间距
    },
    signs = true, -- 显示诊断图标
    underline = true, -- 下划线标记错误行
    update_in_insert = false, -- 插入模式不更新诊断
    severity_sort = true -- 按严重程度排序诊断
})

-- LSP浮动窗口样式（圆角边框）
local function set_lsp_border(handler_name)
    vim.lsp.handlers[handler_name] = vim.lsp.with(vim.lsp.handlers[handler_name], {
        border = "rounded"
    })
end

set_lsp_border("textDocument/hover") -- 悬停提示
set_lsp_border("textDocument/signatureHelp") -- 签名帮助

-- 大文件优化自动命令（2025年社区最新方案）
local augroup = api.nvim_create_augroup("LargeFileOptimizations", {
    clear = true
})

-- 大文件处理（分档优化，更精细）
api.nvim_create_autocmd("BufReadPre", {
    group = augroup,
    pattern = "*",
    callback = function(args)
        -- 获取文件大小（KB）
        local fsize = vim.fn.getfsize(args.file) / 1024
        if not fsize or fsize <= 0 then
            return
        end

        -- 1. 大型文件（10MB+）：激进优化
        if fsize > 10240 then
            vim.opt_local.bufhidden = "unload" -- 不常用时卸载缓冲区
            vim.opt_local.undofile = false -- 禁用撤销历史
            vim.opt_local.swapfile = false -- 禁用交换文件
            vim.opt_local.syntax = "off" -- 禁用语法高亮
            vim.opt_local.eventignore:append({"FileType", "Syntax", "BufWritePre"})
            vim.cmd("LspStop") -- 关闭LSP
            -- 禁用 treesitter 高亮
            pcall(function() vim.cmd("TSBufDisable highlight") end)
            vim.notify(string.format("大型文件优化已启用（%.2fMB）", fsize / 1024), vim.log.levels.WARN)

            -- 2. 中型文件（1MB-10MB）：适度优化
        elseif fsize > 1024 then
            vim.opt_local.syntax = "on" -- 保留基础语法高亮
            vim.opt_local.foldmethod = "manual" -- 禁用自动折叠
            vim.opt_local.indentexpr = "" -- 禁用自动缩进计算
            vim.opt_local.eventignore:append("Syntax")
            -- 减少 treesitter 解析范围
            pcall(function() vim.cmd("TSBufConfigSet parser_max_buffer_size 1048576") end)
            vim.notify(string.format("中型文件优化已启用（%.2fMB）", fsize / 1024), vim.log.levels.INFO)
        end
    end
})

-- 补充：大文件打开后自动调整窗口
api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
        if vim.fn.getfsize(vim.fn.bufname()) / 1024 > 10240 then
            vim.opt_local.wrap = true -- 大文件启用折行便于阅读
            vim.opt_local.cursorline = false -- 禁用光标行高亮减少计算
        end
    end
})

-- -- 不可替换窗口保护设置
-- vim.api.nvim_create_augroup('IrreplaceableWindows',{clear = true})
-- vim.api.nvim_create_autocmd({'BufWinEnter','FileType'},{
--     group = 'IrreplaceableWindows',
--     pattern = '*',
--     desc = '保护特殊窗口不被意外关闭或替换',
--     callback = function()
--         -- 定义需要保护的文件类型和缓冲区类型
--         local protected_filetypes = {"OverseerList", "neo-tree", "NvimTree", "aerial", "undotree", "oil"}
--         local protected_buftypes = {"nofile", "terminal", "quickfix", "loclist"}
        
--         -- 检查当前缓冲区是否需要保护
--         local current_filetype = vim.bo.filetype
--         local current_buftype = vim.bo.buftype
        
--         local should_protect = false
--         if vim.tbl_contains(protected_filetypes, current_filetype) then
--             should_protect = true
--         elseif vim.tbl_contains(protected_buftypes, current_buftype) then
--             should_protect = true
--         end
        
--         -- 如果当前窗口需要保护，设置相关属性
--         if should_protect then
--             -- 设置窗口为固定大小，防止被调整
--             vim.wo.winfixwidth = true
--             vim.wo.winfixheight = true
            
--             -- 设置缓冲区为不可修改（如果适用）
--             if current_buftype == "nofile" then
--                 vim.bo.modifiable = false
--             end
            
--             -- 禁用光标行高亮，减少视觉干扰
--             vim.wo.cursorline = false
            
--             -- 可选：设置特殊缓冲区选项
--             vim.opt_local.swapfile = false
--             vim.opt_local.backup = false
--             vim.opt_local.writebackup = false
            
--             -- 对于Oil文件管理器，添加额外保护
--             if current_filetype == "oil" then
--                 vim.wo.number = false
--                 vim.wo.relativenumber = false
--                 vim.wo.signcolumn = "no"
--                 vim.bo.bufhidden = "hide"
--             end
--         end
--     end
-- })