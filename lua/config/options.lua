-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt
-- 字体配置（nvim支持多个备选字体，自动选择可用字体,neovide不支持）
vim.opt.guifont = "Monaco Nerd Font Mono:h14"
-- opt.guifont = {
--   "Sarasa Term SC Nerd:h14",
--   "JetBrainsMono Nerd Font Mono:h14",
--   "MapleMono NF:h14",
--   "Hack Nerd Font Mono:h14"
-- }

-- vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

if vim.g.neovide then
  -- 外观和透明度
  vim.g.neovide_opacity = 0.9
  vim.g.neovide_background_color = "#1a1b26"
  
  -- 模糊效果
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  
  -- 光标动画
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_cursor_antialiasing = true
  
  -- 窗口行为
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_hide_mouse_when_typing = true
  
  -- 禁用系统提示音
  vim.opt.belloff = "all"
  
  -- 无边框窗口配置（这些需要通过命令行参数或环境变量设置）
  -- 在 Windows 上启动 Neovide 时使用：neovide --frame none
  -- 或者设置环境变量：NEOVIDE_FRAME=none
end


-- 缩进
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 系统剪贴板（LazyVim已默认开启，此处可省略或保留作为显式声明）
opt.clipboard:append("unnamedplus")

-- 外观（补充LazyVim默认未设置的外观选项）
opt.signcolumn = "yes" -- 确保签名列始终显示
-- vim.cmd[[colorscheme tokyonight-moon]]  -- 如需启用主题，取消注释

opt.termguicolors = true
opt.signcolumn = "yes"

--------------------------------------------

-- 禁用未使用的插件提供程序（保留Python3以支持依赖插件）
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
-- 移除Python3，可能影响依赖插件
vim.g.loaded_python3_provider = 0

--------------------------------------------

-- 体验 & 性能（优化部分参数）
opt.updatetime = 100
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.shortmess:append({
    c = true
}) 

-- 编码 & 换行
opt.fileencoding = "utf-8"
opt.fileformat = "unix"
opt.fixeol = false

-- 补全 & 弹窗（适配nvim-cmp的推荐配置）
opt.completeopt = {"menu", "menuone", "noselect"}
opt.pumblend = 10

-- 状态栏标题
opt.title = true
opt.titlestring = "%t - NVIM"

-- 平滑滚动（直接启用，低版本会自动忽略）
opt.smoothscroll = true

-- ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️废弃
-------------------------------------------
-- 搜索（LazyVim已默认配置，此处仅保留需要自定义的部分）
-- opt.ignorecase = true  -- 已默认开启
-- opt.smartcase = true   -- 已默认开启
-- 启用鼠标
-- vim.opt.mouse = "a"
-- set guifont=Sarasa\ Term\ SC\ Nerd:h14	-- vim转义后使用
-- 行号（LazyVim已默认启用混合行号，此处仅保留需要自定义的部分）
-- 如需关闭相对行号，可设置 opt.relativenumber = false
-- ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️禁用
-- 命令行高度（使用noice插件优化而非直接隐藏）
-- 如需隐藏命令行，建议通过noice配置实现：https://github.com/folke/noice.nvim
-- opt.cmdheight = 0  -- 注释掉此配置，避免冲突
-- 持久化撤销（LazyVim已默认配置，此处仅保留需要自定义的部分）
-- 如需修改撤销目录，可取消下面一行注释并修改路径
-- opt.undodir = vim.fn.stdpath("data") .. "/undo"
-- 折叠配置（使用LazyVim内置的ufo折叠，移除手动配置）
-- 如需自定义折叠，建议通过插件配置文件修改ufo设置
-------------------------------------------
-- ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️引用
-------------------------------------------
-- 新文件模板系统
-- 引用独立的模板配置文件
-- local templates = require('config.templates')

-- -- 配置模板系统（可根据需要自定义）
-- templates.setup({
--     -- 作者信息
--     author = {
--         name = "CN",
--         email = "chains0521@163.com",
--         github = "https://github.com/SantaChains",
--     },
    
--     -- 启用/禁用特定文件类型
--     filetypes = {
--         html = { 
--             enabled = true, 
--             lang = "zh-CN", 
--             include_css = true, 
--             include_js = true 
--         },
--         css = { 
--             enabled = true, 
--             include_variables = true, 
--             include_reset = true 
--         },
--         javascript = { 
--             enabled = true, 
--             use_strict = true, 
--             include_main = true 
--         },
--         java = { 
--             enabled = true, 
--             include_main = true 
--         },
--         python = { 
--             enabled = true 
--         },
--         lua = { 
--             enabled = true, 
--             module_style = true 
--         },
--         markdown = { 
--             enabled = true, 
--             include_toc = true, 
--             include_metadata = true 
--         },
--     },
    
--     -- 其他配置
--     prevent_overwrite = true,
--     auto_cursor_position = true,
-- })

-- -- 注册自动命令
-- vim.api.nvim_create_autocmd("BufNewFile", {
--     pattern = {"*.cpp", "*.[ch]", "*.sh", "*.rb", "*.java", "*.py", "*.html", "*.css", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.go", "*.lua", "*.md"},
--     callback = function()
--         local filetype = vim.bo.filetype
--         templates.generate_template(filetype)
--     end
-- })

-- -- 提供用户命令来管理模板
-- vim.api.nvim_create_user_command('TemplateList', function()
--     local supported = templates.get_supported_filetypes()
--     print("支持的文件类型: " .. table.concat(supported, ", "))
-- end, { desc = "列出支持的模板文件类型" })

-- vim.api.nvim_create_user_command('TemplateToggle', function(opts)
--     local filetype = opts.args
--     if filetype == "" then
--         print("请指定文件类型，例如: :TemplateToggle html")
--         return
--     end
    
--     local current_state = templates.config.filetypes[filetype] and templates.config.filetypes[filetype].enabled
--     templates.toggle_filetype(filetype, not current_state)
--     print("模板 " .. filetype .. " " .. (current_state and "已禁用" or "已启用"))
-- end, { 
--     nargs = 1, 
--     desc = "切换指定文件类型的模板启用状态",
--     complete = function()
--         return vim.tbl_keys(templates.config.filetypes)
--     end
-- })

-- local M = {}
--
-- function M.get_package_name()
--     -- 获取当前文件的完整路径和文件名
--     local file_path = vim.fn.expand('%:p')
--     local file_name = vim.fn.expand('%:t')
--     -- 获取不包含文件名的路径
--     local dir_path = string.sub(file_path, 1, -(#file_name + 1))
--     -- 查找关键目录位置
--     local java_pos = string.find(dir_path, "/src/main/java")
--     local src_pos = string.find(dir_path, "src")
--     if not src_pos then
--         return nil
--     end
--     local package_path
--     if java_pos then
--         -- Maven结构: src/main/java/ 或 src/test/java/
--         package_path = string.sub(dir_path, java_pos + 12, -1)
--     else
--         -- 标准结构: src/
--         package_path = string.sub(dir_path, src_pos + 4, -1)
--     end
--     -- 将路径分隔符替换为点号
--     local package_name = string.gsub(package_path, "[\\/]", ".")
--     -- 移除开头和结尾的点号
--     package_name = string.gsub(package_name, "^%.", "")
--     package_name = string.gsub(package_name, "%.$", "")
--     return package_name
-- end
--
-- function M.insert_package()
--     local package_name = M.get_package_name()
--     if package_name and package_name ~= "" then
--         -- 在第一行插入包声明
--         vim.api.nvim_buf_set_lines(0, 5, 6, false, {"package " .. package_name .. ";"})
--         -- 插入空行
--         vim.api.nvim_buf_set_lines(0, 6, 7, false, {""})
--     end
-- end

--vim.api.nvim_create_autocmd("BufNewFile", {
   -- pattern = "*",
   -- callback = function()
       -- vim.cmd("normal G")
        -- if vim.fn.expand("%:e") == 'java' then
        --     M.insert_package()
        -- end
    --end
    -- callback = function()
    --     vim.cmd("normal G")
    --     if vim.fn.expand("%:e") == 'java' then
            -- vim.cmd("normal 2k")
            -- vim.api.nvim_win_set_cursor(0, {9, 8})
            -- 获取当前缓冲区
            -- local buffer = vim.api.nvim_get_current_buf()

            -- -- 获取第8行的内容
            -- local line_content = vim.api.nvim_buf_get_lines(buffer, 8, 9, false)[1] or ""
            --
            -- -- 如果第8行是空行，插入两个 Tab 键
            -- if line_content == "" then
            --     local tabs = "\t\t"
            --     vim.api.nvim_buf_set_lines(buffer, 8, 9, false, {tabs})
            -- end
            --
            -- -- 移动光标到第8行，两个 Tab 键处（假设一个 Tab 是 4 个空格）
            -- vim.api.nvim_win_set_cursor(0, {9, 8})
            --
        -- end
    -- end
--})

-------------------------------------------