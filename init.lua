-- 备份原配置: mv ~/.config/nvim ~/.config/nvim.bak
-- 克隆配置: git clone https://github.com/LazyVim/starter ~/.config/nvim

    
-- require("core.theme")
-- 自定义 LazyVim 配置
require("config.lazy")

-- 关闭 LazyVim 的导入顺序检查
vim.g.lazyvim_check_order = false
-- require("config.plugin_conflicts").setup()

require("config.keybindings")


-- 加载 Krabby 配置
-- require("config.krabby-config")

-- 修复键位冲突
-- require("core.keymap_fix").setup()

-- 加载 ShaDa 修复配置
-- require("config.shada-fix")

-- 加载核心配置这部分lazyvim自动处理了
-- require("config.options")
-- require("config.keymaps")
-- require("config.autocmds")
-- require("plugins.init")

-- Coc 配置
-- vim.g.coc_config_home = vim.fn.stdpath('config')
-- vim.g.coc_data_home = vim.fn.stdpath('data') .. '/coc'

-------------------------------------------------
-- Neovide 专用 GUI 设置
-------------------------------------------------
-- 1. 外观
-- 不要再写
-- vim.g.neovide_transparency = 0.92      -- ❌ 已弃用
-- 只保留这一行
-- vim.g.neovide_opacity = 0.92           -- ✅ 推荐写法-- 整体透明度

-- vim.g.neovide_opacity = 0.92             -- 同上（新版本推荐）
-- vim.g.neovide_background_color = "#1e1e2e" -- 窗口背景（HEX）
-- vim.opt.guifont = "JetBrainsMono Nerd Font:h14" -- 字体与字号

-- 2. 动画
-- vim.g.neovide_position_animation_length = 0.15  -- 分屏/窗口移动动画（秒）
-- vim.g.neovide_scroll_animation_length = 0.30    -- 滚屏动画
-- vim.g.neovide_cursor_animation_length = 0.13    -- 光标跳跃动画

-- 3. 光标粒子特效（轻度）
-- vim.g.neovide_cursor_vfx_mode = "railgun"
-- vim.g.neovide_cursor_vfx_opacity = 180.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 0.8
-- vim.g.neovide_cursor_vfx_particle_density = 5.0
-- vim.g.neovide_cursor_vfx_particle_speed = 8.0

-- 4. 行为
vim.g.neovide_remember_window_size = true  -- 记住上次退出时的窗口大小
-- vim.g.neovide_confirm_quit = true          -- 退出时确认
-- vim.g.neovide_hide_mouse_when_typing = true -- 打字时自动隐藏鼠标

-------------------------------------------------
-- Neovide 无边框窗口配置说明
-------------------------------------------------
-- 要实现无边框窗口，需要使用以下方式之一：
-- 
-- 方法1：命令行参数启动
-- neovide --frame none
-- 
-- 方法2：设置环境变量
-- set NEOVIDE_FRAME=none
-- 
-- 方法3：创建批处理文件（推荐）
-- 创建 start_neovide.bat 文件，内容：
-- @echo off
-- set NEOVIDE_FRAME=none
-- start neovide
-- 
-- 无边框窗口功能：
-- ✓ 隐藏系统原生边框
-- ✓ 支持拖动（按住Alt键或配置拖动区域）
-- ✓ 支持调整大小（移动到窗口边缘）
-- ✓ 支持最小化、最大化、关闭（需要额外配置）
-- 
-- 注意：无边框后窗口控制需要通过键盘快捷键或自定义标题栏