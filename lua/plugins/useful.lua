return {
  "abecodes/tabout.nvim",
  event = "InsertEnter", -- 延迟加载，进入插入模式时才加载
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- 依赖 treesitter 进行语法分析
    "L3MON4D3/LuaSnip", -- 可选：与 LuaSnip 集成
  },
  config = function()
    require("tabout").setup({
      -- 按键配置
      tabkey = "<Tab>", -- 触发 tabout 的按键，设为空字符串禁用
      backwards_tabkey = "<S-Tab>", -- 反向 tabout 按键
      
      -- 行为配置
      act_as_tab = true, -- 当无法 tabout 时，当作普通 Tab 键使用
      act_as_shift_tab = false, -- 反向操作时是否当作 Shift+Tab
      
      -- 默认行为配置
      default_tab = "<C-t>", -- 在行首时的默认 Tab 行为
      default_shift_tab = "<C-d>", -- 在行首时的默认 Shift+Tab 行为
      
      -- 启用反向操作
      enable_backwards = true,
      
      -- 与补全插件的集成
      completion = false, -- 禁用与补全菜单的冲突（我们使用 blink-cmp）
      
      -- 支持的括号对配置
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        -- 添加更多支持的括号对
        { open = "<", close = ">" }, -- HTML/XML 标签
      },
      
      -- 智能行为配置
      ignore_beginning = true, -- 如果在填充元素的开头，优先 tabout 而不是移动内容
      
      -- 排除特定文件类型
      exclude = {
        "markdown", -- Markdown 中保留 Tab 的原始行为
        "text",     -- 纯文本文件
        "TelescopePrompt", -- Telescope 提示符
        "alpha",    -- Alpha 启动页面
        "dashboard", -- Dashboard 页面
      },
      
      -- 自定义检查函数，动态决定是否启用 tabout
      enabled = function()
        -- 获取当前文件类型
        local ft = vim.bo.filetype
        
        -- 在特定文件类型中禁用
        local disabled_fts = {
          "markdown", "text", "TelescopePrompt", "alpha", "dashboard",
          "NvimTree", "neo-tree", "toggleterm"
        }
        
        for _, disabled_ft in ipairs(disabled_fts) do
          if ft == disabled_ft then
            return false
          end
        end
        
        -- 在注释字符串中禁用（需要 treesitter）
        local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
        if ok then
          local node = ts_utils.get_node_at_cursor()
          if node then
            local node_type = node:type()
            -- 如果在注释中，禁用 tabout
            if node_type:match("comment") then
              return false
            end
          end
        end
        
        return true
      end,
    })
    
    -- 添加自定义键位映射
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    
    -- 手动触发 tabout
    keymap("i", "<C-l>", function()
      require("tabout").tabout()
    end, vim.tbl_extend("force", opts, { desc = "Tabout: Jump out of brackets" }))
    
    -- 反向 tabout
    keymap("i", "<C-h>", function()
      require("tabout").tabout_backwards()
    end, vim.tbl_extend("force", opts, { desc = "Tabout: Jump backwards out of brackets" }))
    
    -- 通知用户插件已加载
    -- vim.notify("Tabout.nvim 已加载 ✨", vim.log.levels.INFO)
  end,
}