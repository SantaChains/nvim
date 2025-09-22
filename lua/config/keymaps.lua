-- 优化后的键位映射配置 - 中文描述版
-- 统一中文描述，解决冲突，符合普通用户使用习惯

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ========== 基础设置 ==========
-- hjkl 可以跨行
vim.opt.whichwrap:append("h,l,<,>,[,]")

-- ========== 插入模式 ==========
-- 快速退出插入模式
keymap.set("i", "jk", "<ESC>", { desc = "退出插入模式" })

-- Windows 风格的常用快捷键
keymap.set("i", "<C-s>", "<Cmd>w<CR>", { desc = "保存文件" })
keymap.set("i", "<C-z>", "<Esc>u<CR>i", { desc = "撤销" })

-- 插入模式下的移动（更符合习惯）
keymap.set("i", "<C-h>", "<Left>", { desc = "左移" })
keymap.set("i", "<C-l>", "<Right>", { desc = "右移" })
keymap.set("i", "<C-j>", "<Down>", { desc = "下移" })
keymap.set("i", "<C-k>", "<Up>", { desc = "上移" })

-- 行首行尾移动
keymap.set("i", "<C-a>", "<Home>", { desc = "行首" })
keymap.set("i", "<C-e>", "<End>", { desc = "行尾" })

-- 删除操作
keymap.set("i", "<C-d>", "<Del>", { desc = "删除右侧字符" })
keymap.set("i", "<C-w>", "<C-G>u<C-W>", { desc = "删除前一个词" })
keymap.set("i", "<C-BS>", "<C-G>u<C-W>", { desc = "删除前一个词 (Ctrl+Backspace)" })
keymap.set("i", "<C-u>", "<C-G>u<C-U>", { desc = "删除到行首" })
keymap.set("i", "<C-Del>", "<C-G>u<C-K>", { desc = "删除到行尾" })

-- ========== 视觉模式 ==========
-- 快速退出视觉模式
keymap.set("v", "jk", "<ESC>", { desc = "退出视觉模式" })

-- 移动选中的行
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动选中行" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动选中行" })

-- Windows 风格复制粘贴
keymap.set("v", "<C-c>", '"+y', { desc = "复制到系统剪贴板" })
keymap.set("v", "<C-x>", '"+d', { desc = "剪切到系统剪贴板" })
keymap.set("v", "<C-v>", '"+p', { desc = "从系统剪贴板粘贴" })

-- ========== 正常模式 ==========
-- Windows 风格操作
keymap.set("n", "<C-a>", "ggVG", { desc = "全选" })
keymap.set("n", "<C-s>", "<Cmd>w<CR>", { desc = "保存文件" })
keymap.set("n", "<C-z>", "u", { desc = "撤销" })
keymap.set("n", "<C-i>", "<C-r>", { desc = "重做" })

-- 复制粘贴
keymap.set("n", "<C-c>", '"+y', { desc = "复制到系统剪贴板" })
keymap.set("n", "<C-v>", '"+p', { desc = "从系统剪贴板粘贴" })

-- 缓冲区切换（使用 Alt 避免冲突）
keymap.set("n", "<A-l>", ":bnext<CR>", { desc = "下一个缓冲区" })
keymap.set("n", "<A-h>", ":bprevious<CR>", { desc = "上一个缓冲区" })
keymap.set("n", "<A-w>", ":bdelete<CR>", { desc = "关闭当前缓冲区" })

-- 窗口管理（保留与 keybindings.lua 不冲突的键位）
keymap.set("n", "<leader>sj", "<C-w>v", { desc = "垂直分割窗口" })
keymap.set("n", "<leader>sk", "<C-w>s", { desc = "水平分割窗口" })
keymap.set("n", "<leader>sm", "<C-w>c", { desc = "关闭当前窗口" })
keymap.set("n", "<leader>si", "<C-w>o", { desc = "关闭其他窗口" })

-- 窗口间移动（使用 Ctrl + 方向键，更直观）
keymap.set("n", "<C-Left>", "<C-w>h", { desc = "移动到左窗口" })
keymap.set("n", "<C-Down>", "<C-w>j", { desc = "移动到下窗口" })
keymap.set("n", "<C-Up>", "<C-w>k", { desc = "移动到上窗口" })
keymap.set("n", "<C-Right>", "<C-w>l", { desc = "移动到右窗口" })

-- 窗口大小调整
keymap.set("n", "<A-Left>", "<C-w><", { desc = "减小窗口宽度" })
keymap.set("n", "<A-Right>", "<C-w>>", { desc = "增加窗口宽度" })
keymap.set("n", "<A-Up>", "<C-w>+", { desc = "增加窗口高度" })
keymap.set("n", "<A-Down>", "<C-w>-", { desc = "减小窗口高度" })

-- 搭索相关（保留与 keybindings.lua 不重复的功能）
-- keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "取消高亮" })  -- 已在 keybindings.lua 中定义
keymap.set("n", "n", "nzzzv", { desc = "下一个搜索结果并居中" })
keymap.set("n", "N", "Nzzzv", { desc = "上一个搜索结果并居中" })

-- 页面滚动并居中
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "向下半页并居中" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "向上半页并居中" })

-- 行移动
keymap.set("n", "j", "gj", { desc = "向下移动（包括换行）" })
keymap.set("n", "k", "gk", { desc = "向上移动（包括换行）" })

-- 快速跳转
keymap.set("n", "H", "^", { desc = "跳转到行首" })
keymap.set("n", "L", "$", { desc = "跳转到行尾" })
keymap.set("n", "<leader>gh", "G$", { desc = "跳转末行末" })


-- 终端配置：使用正确的Neovim终端命令
-- 根据Neovim官方文档，:terminal命令应该在split之后执行
keymap.set("n", "<leader>t", function()
    -- 先分割窗口，然后在新窗口中打开终端
    vim.cmd("split")
    vim.cmd("terminal pwsh.exe -NoLogo")
    vim.cmd("resize 15")
end, { desc = "💻 横向终端" })

-- 退出终端模式
keymap.set("t", "<C-x>", "<Cmd>quit<CR>", { desc = "退出终端模式" })
keymap.set("t", "<C-b>", "<C-\\><C-n>", { desc = "退出终端模式" })



-- ========== LSP 相关功能 ==========
-- 使用统一的 LSP 功能，避免与 keybindings.lua 重复

-- 快速 LSP 操作（保留为快捷方式）
keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "跳转到声明" })
keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "查看定义" })
keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "跳转到实现" })
keymap.set("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })

-- 诊断相关（与 LazyVim 配合）
keymap.set("n", "<space>D", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "查看类型定义" })
keymap.set("n", "<space>,n", vim.lsp.buf.rename, { desc = "重命名符号" })

-- 格式化和代码操作（格式化已统一至 conform.lua 管理）
-- keymap.set("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, { desc = "格式化代码" }) -- 已移至 conform.lua 统一管理
keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "代码操作" })

-- 缓冲区切换（与 Alt 键位配合使用）
keymap.set("n", "<C-L>", ":bnext<CR>", { desc = "下一个缓冲区" })
keymap.set("n", "<C-H>", ":bprevious<CR>", { desc = "上一个缓冲区" })

-- 编辑配置文件（避免与 keybindings.lua 重复）
-- 使用 LazyVim 默认的 <space>c 配置相关功能即可

-- 终端相关（使用 LazyVim 默认的 <leader>ft 或类似功能）
-- 避免与主题切换冲突，使用不同的键位

-- ========== 数字递增递减和特殊模式 ==========
-- 恢复被覆盖的原生功能
keymap.set("n", "<leader>,", "<nop>", { desc = "🙃 凌乱杂项" })
keymap.set("n", "<leader>,+", "<C-a>", { desc = "➕ 数字递增" })
keymap.set("n", "<leader>,-", "<C-x>", { desc = "➖ 数字递减" })

-- 块选择模式
keymap.set("n", "<A-v>", "<C-v>", { desc = "📎 块选择模式" })

-- ========== 禁用容易误触的按键 ==========
-- 禁用 Ex 模式（Q 键容易误触）
keymap.set("n", "Q", "<nop>", { desc = "⛔ 禁用Ex模式" })

-- 可选：禁用宏录制（q 键容易误触）
keymap.set("n", "q", "<nop>", { desc = "🚫 禁用宏录制" })

keymap.set("n", "<leader>n", "<nop>")
-- ========== 自定义功能映射 ==========
-- leader+space+space 触发文件浏览功能（原leader+space功能）
-- 支持 Telescope 和原生文件浏览器
keymap.set("n", "<leader><space><space>", function()
    -- 检查 Telescope 是否可用
    local has_telescope, telescope = pcall(require, 'telescope.builtin')
    if has_telescope then
        -- 使用 Telescope 查找文件
        telescope.find_files()
    else
        -- 回退到原生文件浏览器
        vim.cmd("Explore")
    end
end, { desc = "📁 文件浏览" })

-- leader+space 禁用（避免误触）
keymap.set("n", "<leader><space>", "<nop>", { desc = "文件" })

-- ========== 自动命令 ==========
-- 插入模式显示绝对行号，普通模式显示相对行号
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
})

-- 自动保存
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" then
            vim.cmd("silent! write")
        end
    end,
})