return {
  "L3MON4D3/LuaSnip",
  -- 跟随最新发布版本
  version = "v2.*", -- 替换为最新发布的主版本号（最新发布版本的第一个数字）
  -- 安装 jsregexp（可选！）
  build = "make install_jsregexp",
  
  -- 依赖配置
  dependencies = {
    "rafamadriz/friendly-snippets", -- 预定义的代码片段集合
    -- 注意：移除了 cmp_luasnip 依赖，因为我们使用 blink.cmp
    -- blink.cmp 内置了对 LuaSnip 的支持，无需额外依赖
  },
  
  -- 配置函数
  config = function()
    local luasnip = require("luasnip")
    
    -- 基础配置 - 优化与 blink.cmp 的集成
    luasnip.config.set_config({
      -- 启用自动触发的代码片段
      enable_autosnippets = true,
      
      -- 历史记录配置
      history = true,
      
      -- 更新事件配置 - 优化性能，减少不必要的事件触发
      update_events = { "TextChanged", "TextChangedI" },
      
      -- 删除检测配置
      delete_check_events = "TextChanged",
      
      -- 区域检测配置 - 使用更轻量级的事件
      region_check_events = "CursorHold",
      
      -- 加载 VS Code 风格的代码片段
      load_ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
      
      -- blink.cmp 兼容性配置
      store_selection_keys = "<Tab>", -- 与 blink.cmp 的 Tab 键行为保持一致
      
      -- 性能优化配置
      ft_func = function()
        return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
      end,
    })
    
    -- 加载友好的代码片段
    require("luasnip.loaders.from_vscode").lazy_load()
    
    -- 加载自定义的代码片段
    require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
    
    -- 文件类型特定的代码片段加载
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        local filetype = vim.bo.filetype
        if filetype and filetype ~= "" then
          -- 尝试加载文件类型特定的代码片段
          pcall(function()
            require("luasnip.loaders.from_vscode").load({ include = { filetype } })
          end)
        end
      end,
    })
    
    -- 设置代码片段展开快捷键 - 与 blink.cmp 集成
    -- 注意：这些快捷键会与 blink.cmp 协同工作
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        -- 如果 LuaSnip 无法处理，返回原始按键让 blink.cmp 处理
        return "<Tab>"
      end
    end, { silent = true, expr = true })
    
    -- 设置代码片段回退快捷键
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        -- 如果 LuaSnip 无法处理，返回原始按键让 blink.cmp 处理
        return "<S-Tab>"
      end
    end, { silent = true, expr = true })
    
    -- 选择模式下的快捷键 - 使用 Ctrl+j/k 避免与 blink.cmp 冲突
    vim.keymap.set("i", "<C-j>", function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, { desc = "LuaSnip: Next choice" })
    
    vim.keymap.set("i", "<C-k>", function()
      if luasnip.choice_active() then
        luasnip.change_choice(-1)
      end
    end, { desc = "LuaSnip: Previous choice" })
    
    -- 代码片段列表快捷键 - 使用 <leader>ss 避免冲突
    vim.keymap.set("n", "<leader>ss", function()
      -- 打开代码片段列表
      require("luasnip.extras.snip_list").open()
    end, { desc = "LuaSnip: List snippets" })
    
    -- 重新加载代码片段快捷键 - 使用 <leader>sr
    vim.keymap.set("n", "<leader>sr", function()
      -- 重新加载 Lua 代码片段
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
      vim.notify("Snippets reloaded", vim.log.levels.INFO)
    end, { desc = "LuaSnip: Reload snippets" })
    
    -- 新增：与 blink.cmp 集成的特殊配置
    -- 确保 LuaSnip 和 blink.cmp 的兼容性
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpCompletionMenuOpened",
      callback = function()
        -- 当 blink.cmp 补全菜单打开时，禁用 LuaSnip 的某些功能
        vim.b.luasnip_snippet_expandable = false
      end,
    })
    
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpCompletionMenuClosed", 
      callback = function()
        -- 当 blink.cmp 补全菜单关闭时，重新启用 LuaSnip
        vim.b.luasnip_snippet_expandable = true
      end,
    })
  end,
  
  -- 代码片段相关的命令 - 优化命名避免冲突
  commands = function()
    vim.api.nvim_create_user_command("SnippetsEdit", function()
      -- 打开代码片段编辑文件
      vim.cmd("edit " .. vim.fn.stdpath("config") .. "/snippets/lua.lua")
    end, { desc = "LuaSnip: Edit custom snippets" })
    
    vim.api.nvim_create_user_command("SnippetsReload", function()
      -- 重新加载所有代码片段
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
      vim.notify("All snippets reloaded", vim.log.levels.INFO)
    end, { desc = "LuaSnip: Reload all snippets" })
    
    -- 新增：与 blink.cmp 相关的实用命令
    vim.api.nvim_create_user_command("SnippetsStatus", function()
      -- 显示 LuaSnip 和 blink.cmp 的状态
      local luasnip = require("luasnip")
      local status = {
        luasnip_enabled = luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] ~= nil,
        blink_enabled = require("blink.cmp").config.enabled(),
      }
      print("LuaSnip 状态: " .. (status.luasnip_enabled and "启用" or "未启用"))
      print("Blink.cmp 状态: " .. (status.blink_enabled and "启用" or "禁用"))
    end, { desc = "LuaSnip: Show status" })
    
    -- 新增：与 neogen 的集成配置
    -- 确保 neogen 生成的注释可以使用 LuaSnip 的代码片段功能
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeogenAnnotationGenerated",
      callback = function()
        -- 当 neogen 生成注释后，自动激活 LuaSnip 的代码片段功能
        local luasnip = require("luasnip")
        if luasnip.expandable() then
          luasnip.expand()
        end
      end,
    })
  end,
}