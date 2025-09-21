return {
  -- plenary.nvim: Neovim 的 Lua 基础库，提供异步、文件系统、路径处理等核心功能
  -- 许多插件都依赖此插件作为基础库
  'nvim-lua/plenary.nvim',
  
  -- 设置为 lazy = false 确保立即加载，因为其他插件可能依赖它
  lazy = false,
  
  -- 优先级设置为 1000，确保最先加载
  priority = 1000,
  
  -- 配置函数：初始化 plenary 并设置全局访问
  config = function()
    -- 确保 plenary 模块可用
    local ok, plenary = pcall(require, 'plenary')
    if not ok then
      vim.notify("plenary.nvim 加载失败", vim.log.levels.ERROR)
      return
    end
    
    -- 可选：设置一些常用的 plenary 模块为全局变量，方便使用
    -- 注意：这可能会污染全局命名空间，谨慎使用
    _G.async = require('plenary.async')
    _G.Path = require('plenary.path')
    _G.Job = require('plenary.job')
    _G.scandir = require('plenary.scandir')
    
    -- 打印调试信息
    if vim.g.debug_mode then
      print("plenary.nvim 已加载")
    end
  end,
  
  -- 可选：添加一些实用的用户命令
  init = function()
    -- 创建用户命令来测试 plenary 功能
    vim.api.nvim_create_user_command('PlenaryTest', function()
      -- 测试路径模块
      local Path = require('plenary.path')
      local current_file = Path:new(vim.fn.expand('%:p'))
      print("当前文件路径: " .. current_file.filename)
      print("文件名: " .. current_file.filename)
      print("扩展名: " .. current_file.extension)
      print("是否为绝对路径: " .. tostring(current_file:is_absolute()))
      
      -- 测试异步功能
      local async = require('plenary.async')
      async.run(function()
        print("plenary 异步测试成功")
      end)
    end, { desc = '测试 plenary 功能' })
    
    -- 文件扫描测试命令
    vim.api.nvim_create_user_command('PlenaryScan', function()
      local scandir = require('plenary.scandir')
      local files = scandir.scan_dir('.', { 
        hidden = true, 
        depth = 2,
        add_dirs = false 
      })
      print("扫描到 " .. #files .. " 个文件")
      for i, file in ipairs(files) do
        if i <= 10 then  -- 只显示前10个
          print("  " .. file)
        end
      end
    end, { desc = '扫描当前目录文件' })
  end,
}