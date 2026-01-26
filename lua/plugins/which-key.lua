return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 400
    end,
    filter = function(mapping)
      -- 过滤掉可能导致冲突的映射
      local key = mapping.lhs
      
      -- 不为单个字母创建 which-key 组（除了 leader 键）
      if #key == 1 and key ~= " " then
        return false
      end
      
      -- 过滤冲突的组定义
      local conflicting_patterns = {
        "^g$",      -- vim 原生 g 命令
        "^s$",      -- substitute 命令
        "^gr$",     -- references
        "^gc$",     -- comment
      }
      
      for _, pattern in ipairs(conflicting_patterns) do
        if key:match(pattern) then
          return false
        end
      end
      
      return true
    end,
    -- 防止重复定义组，只在这里定义基础结构，具体组由 keybindings.lua 管理
    spec = {},
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      spacing = 3,
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
  },
  -- 防止重复定义 which-key 组的配置
  config = function(_, opts)
    local safe_require = require('utils.safe_require')
    local wk = safe_require.safe_require('which-key')
    if wk then
      wk.setup(opts)
    end
    
    -- 这里不再定义任何组，全部由 keybindings.lua 统一管理，避免重复
  end,
  keys = {
    {
      "<leader>?",
      function()
        local safe_require = require('utils.safe_require')
        local wk = safe_require.safe_require('which-key')
        if wk then
          wk.show({ global = false })
        end
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}