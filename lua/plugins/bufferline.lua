return {
  -- 标签栏增强
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
      }
    },
    keys = {
      { "<leader>,p", "<cmd>BufferLineTogglePin<cr>", desc = "切换固定标签" },
      { "<leader>,P", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "关闭未固定的标签" },
      { "<leader>,o", "<cmd>BufferLineCloseOthers<cr>", desc = "关闭其他标签" },
      { "<leader>,r", "<cmd>BufferLineCloseRight<cr>", desc = "关闭右侧标签" },
      { "<leader>,l", "<cmd>BufferLineCloseLeft<cr>", desc = "关闭左侧标签" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个标签" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "下一个标签" },
      -- 新增快捷键：按数字跳转
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "跳转到标签 1" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "跳转到标签 2" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "跳转到标签 3" },
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "跳转到标签 4" },
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "跳转到标签 5" },
      { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "跳转到标签 6" },
      { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "跳转到标签 7" },
      { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "跳转到标签 8" },
      { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "跳转到标签 9" },
      -- 新增快捷键：移动标签位置
      { "<leader><", "<cmd>BufferLineMovePrev<cr>", desc = "左移标签" },
      { "<leader>>", "<cmd>BufferLineMoveNext<cr>", desc = "右移标签" },
      -- 新增快捷键：拾取标签
      { "<leader>,b", "<cmd>BufferLinePick<cr>", desc = "拾取标签" },
      { "<leader>,B", "<cmd>BufferLinePickClose<cr>", desc = "拾取关闭标签" },
    },
    opts = {
      options = {
        mode = "buffers",
        -- 增强设置开始
        numbers = "ordinal", -- 显示序号
        close_command = "bdelete! %d", -- 关闭命令
        right_mouse_command = "bdelete! %d", -- 右键关闭
        left_mouse_command = "buffer %d", -- 左键切换
        middle_mouse_command = nil, -- 中键无操作
        indicator = {
          style = 'icon', -- 指示器样式
          icon = '▎', -- 指示器图标
        },
        buffer_close_icon = '󰅖', -- 关闭图标
        modified_icon = '●', -- 修改图标
        close_icon = '', -- 关闭按钮图标
        left_trunc_marker = '', -- 左截断标记
        right_trunc_marker = '', -- 右截断标记
        max_name_length = 18, -- 最大名称长度
        max_prefix_length = 15, -- 最大前缀长度
        tab_size = 18, -- 标签大小
        diagnostics = "nvim_lsp", -- 显示诊断信息
        diagnostics_update_in_insert = false, -- 插入模式不更新诊断
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        color_icons = true, -- 彩色图标
        show_buffer_icons = true, -- 显示文件图标
        show_buffer_close_icons = true, -- 显示关闭图标
        show_buffer_default_icon = false, -- 不显示默认图标
        show_close_icon = true, -- 显示关闭图标
        show_tab_indicators = true, -- 显示标签指示器
        persist_buffer_sort = true, -- 保持排序
        separator_style = "thin", -- 分隔符样式
        enforce_regular_tabs = false, -- 不强制规则标签
        always_show_bufferline = false, -- 不总是显示
        hover = {
          enabled = true, -- 启用悬停
          delay = 200, -- 悬停延迟
          reveal = {'close'} -- 悬停显示关闭按钮
        },
        sort_by = 'insert_after_current', -- 排序方式
        offsets = {
          { 
            filetype = "NvimTree", 
            text = "文件浏览器", 
            highlight = "Directory", 
            text_align = "left",
            separator = true -- 添加分隔符
          },
          {
            filetype = "neo-tree",
            text = "文件浏览器",
            highlight = "Directory",
            text_align = "left",
            separator = true
          }
        },
        -- 增强设置结束
      },
    },
  },
  
  -- 智能文本移动增强
  {
    'chrisgrieser/nvim-spider',
    keys = {
      -- -- 保持原生 w/e/b/ge 键，符合vim传统习惯
      -- -- 'w': 向前移动到单词开头，智能识别代码结构和标识符
      -- { 'w', '<cmd>lua require("spider").motion("w")<CR>', mode = { 'n', 'o', 'x' }, desc = '下一个单词(开头)' },
      
      -- -- 'e': 向前移动到单词结尾，处理驼峰、下划线等复合词
      -- { 'e', '<cmd>lua require("spider").motion("e")<CR>', mode = { 'n', 'o', 'x' }, desc = '下一个单词(结尾)' },
      
      -- -- 'b': 向后移动到单词开头，适应各种编程语言的标识符规则
      -- { 'b', '<cmd>lua require("spider").motion("b")<CR>', mode = { 'n', 'o', 'x' }, desc = '上一个单词(开头)' },
      
      -- 'ge': 向后移动到单词结尾，提供完整的移动体验
      -- { 'ge', '<cmd>lua require("spider").motion("ge")<CR>', mode = { 'n', 'o', 'x' }, desc = '上一个单词(结尾)' },
      
      -- Readline风格的Ctrl+左右箭头，符合终端编辑习惯
      -- Ctrl+Left: 向后移动一个单词(开头)
      { '<C-Left>', '<cmd>lua require("spider").motion("b")<CR>', mode = { 'i', 'n', 'c' }, desc = '上一个单词(Ctrl+←)' },
      
      -- Ctrl+Right: 向前移动一个单词(开头)
      { '<C-Right>', '<cmd>lua require("spider").motion("w")<CR>', mode = { 'i', 'n', 'c' }, desc = '下一个单词(Ctrl+→)' },
      
      -- Alt+Left/Right: 在插入模式下也支持单词跳转
      { '<M-Left>', '<cmd>lua require("spider").motion("b")<CR>', mode = 'i', desc = '上一个单词(Alt+←)' },
      { '<M-Right>', '<cmd>lua require("spider").motion("w")<CR>', mode = 'i', desc = '下一个单词(Alt+→)' },
    },
    opts = {
      -- 跳过不重要的标点符号，更符合编程习惯
      skipInsignificantPunctuation = true,
      
      -- 为特定文件类型定制移动模式
      customPatterns = {
        markdown = {
          -- Markdown文档中的句子移动模式，便于文档编辑
          sentence = [[([.!?]|\n\n)+\s*]],
        },
        -- 可以在此添加其他文件类型的自定义模式
      },
    },
  }
}
