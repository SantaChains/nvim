return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',  -- 自动主题
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},  -- 不隐藏任何文件类型的状态行
          winbar = {},      -- 不隐藏任何文件类型的窗口栏
        },
        ignore_focus = {},  -- 不忽略任何文件类型
        always_divide_middle = true,  -- 总是分隔中间部分
        globalstatus = false,  -- 不使用全局状态行
        refresh = {
          statusline = 1000,  -- 状态行刷新间隔
          tabline = 1000,     -- 标签行刷新间隔
          winbar = 1000,      -- 窗口栏刷新间隔
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    })
  end
}