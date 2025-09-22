return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  -- config = function()
  --   local Snacks = require("snacks")
    
  --   -- 设置 picker 相关的快捷键
  --   local map = function(key, func, desc)
  --     vim.keymap.set('n', key, func, {desc = desc})
  --   end
    
  --   -- picker 快捷键配置
  --   map('<leader>fp', function() Snacks.picker.files() end, 'Find Files')
  --   map('<leader>fc', function() Snacks.picker.live_grep() end, 'Find Text')
  --   map('<leader>fr', function() Snacks.picker.recent_files() end, 'Find recent files')
  --   map('<leader>fb', function() Snacks.picker.buffers() end, 'Find Buffers')
  --   map('<leader>fg', function() Snacks.picker.grep() end, 'Find Grep')
  --   map('<leader>fh', function() Snacks.picker.help({layout = 'dropdown'}) end, 'Find nvim help')
  --   map('<leader>fk', function() Snacks.picker.keymaps({layout = 'float'}) end, 'Find config Keymaps')

  --   -- word
  --   -- 单词跳转快捷键配置
  --   map(']]', function() Snacks.words.jump(vim.v.count1) end, 'Next Reference')
  --   map('[[', function() Snacks.words.jump(-vim.v.count1) end, 'Prev Reference')
  -- end,


   keys={
    { "<leader>e", function() require("snacks").explorer() end, desc = "File Explorer" },
    { "<leader>nh", function() require("snacks").notifier.show_history({ timeout = false }) end, desc = "Show notification history" },
    -- { "<leader>gs", Snacks.picker.git_status, desc = "Git Status" },
    -- { "<leader>gb", Snacks.picker.git_branches, desc = "Git Branches" },
    -- { "<leader>gl", Snacks.picker.git_log, desc = "Git Log" },
    -- { "<leader>gd", Snacks.picker.git_diff, desc = "Git Diff" },
    -- { "<leader>gg", Snacks.lazygit, desc = "Lazygit" },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = [[
 ▄▀▀▀▀▄  ▄▀▀█▄   ▄▀▀▄ ▀▄  ▄▀▀█▀▄    ▄▀▀▄ ▀▄  ▄▀▀▀▀▄ 
█ █   ▐ ▐ ▄▀ ▀▄ █  █ █ █ █   █  █  █  █ █ █ █ █   ▐ 
   ▀▄     █▄▄▄█ ▐  █  ▀█ ▐   █  ▐  ▐  █  ▀█    ▀▄   
▀▄   █   ▄▀   █   █   █      █       █   █  ▀▄   █  
 █▀▀▀   █   ▄▀  ▄▀   █    ▄▀▀▀▀▀▄  ▄▀   █    █▀▀▀   
 ▐      ▐   ▐   █    ▐   █       █ █    ▐    ▐      
                ▐        ▐       ▐ ▐                
        ]],
        keys = {
          -- 紧凑布局：图标 + 快捷键 + 描述
          { icon = "󰈞 ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = "󰈔 ", key = "n", desc = "Neon File", action = ":ene | startinsert" },
          --  { icon = "󰊄 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰊄 ", key = "g", desc = "Find Text", action = function() require("snacks").dashboard.pick("live_grep") end },
          { icon = "󱛒", key = "o", desc = "Restore Session", section = "session" },
          { icon = "󰏖 ", key = "l", desc = "Sanins Manager", action = ":Lazy" },
          { icon = "󰒕 ", key = "h", desc = "Health Check", action = ":checkhealth" },
          { icon = "", key = "t", desc = "TreeSitter Info", action = function() vim.cmd.TSInstallInfo() end  },
          { icon = " ", key = "n", desc = "Conform Info", action = function() vim.cmd.ConformInfo() end  },
          { icon = "󱌢 ", key = "m", desc = "Mason", action = ":Mason" },
          { icon = "󰒓 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰃃 ", key = "x", desc = "Extras", action = ":LazyExtras" },
          { icon = "󰈆 ", key = "q", desc = "Quit", action = ":qa" },
        }
      },

      sections = {
        { section = "header", gap = 0 },
        { icon = "󰌌 ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { section = "startup" },
        {
        pane = 2,
        icon = "󰢵 ",                  
        title = "Pokemon",           
        section = "terminal",
        cmd = "krabby random  --no-title",  --sleep 100ms
        height = 10,        
        padding = 1,                    
         },
        
        { pane = 2, icon = "󰋚 ", key = "r", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, action = function() require("snacks").picker.recent() end },
        --  { pane =2,icon = "󰋚 ", key = "r",title = "Recent Files", section = "recent_files", indent = 2, padding = 1,action = function()
        -- Snacks.picker.recent()
        -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', false) end},
        { pane = 2, icon = "󰉋 ", key = "p", title = "Projects", section = "projects", indent = 2, padding = 1, action = "vim.fn.chdir(project.path)" },
        
        {
          pane = 2,
          icon = "󰊤 ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            require("snacks").gitbrowse()
          end,
        },
      },
    },

    bigfile = { 
      enabled = true,
      size = 2 * 1024 * 1024,  -- 2MB触发阈值
      setup = function(ctx)
        -- 自定义大文件处理逻辑
        vim.bo[ctx.buf].syntax = ctx.ft  -- 仅保留基础语法高亮
        vim.b.minianimate_disable = true  -- 禁用动画
      end,
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    
    notifier = { enabled = true, 
      timeout = 3000,
      style = "compact",  -- 紧凑样式
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      history = {
      timeout = false,  -- 持久化显示，不自动关闭
      -- 可以额外配置历史窗口的样式、大小等
      -- size = 0.8,  -- 占屏幕80%大小
      -- border = "rounded"  -- 圆角边框
    }
      },
    quickfile = { enabled = true,exclude = { "latex" },},
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    image = { enabled = true },
    terminal = {
      enabled = true,
      shell = "pwsh.exe",  -- 使用PowerShell Core替代cmd.exe
      winopts = {
        -- Windows特定配置
      },
    }, 
    picker = { 
      enabled = true,
      limit = 500,
    --   layout = {
    --     preset = function()
    --       -- 根据窗口宽度自动切换布局
    --       return vim.o.columns >= 120 and "default" or "vertical"
    --     end,
    --  },
      -- matcher = {
      --   fuzzy = true,
      --   smartcase = true,
      --   frecency = true, -- 启用频率加权排序
      -- }, -- 大文件优化可以禁用

      win={
        input={
          keys={
            ['Esc'] = {'close',mode={'n','i'}},
            ["<C-s>"] = false,
            -- ["<C-n>"] = "edit_split",  -- Ctrl+s 在水平分屏中打开选中项
            -- ["<C-b>"] = "edit_vsplit", -- Ctrl+v 在垂直分屏中打开选中项
            -- ["<C-t>"] = "tab",         -- Ctrl+t 在新标签页中打开选中项
          },
        },
      },
  },
  },
}