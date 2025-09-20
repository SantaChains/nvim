-- 编辑器核心功能插件
-- 提供基础的编辑增强功能：文本操作、导航、结构化编辑

return {
  -- 文本环绕操作 - 核心编辑功能
  {
    'kylechui/nvim-surround',
    version = '^3.0.0',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-surround').setup({
        surrounds = {
          -- 自定义 Markdown 链接环绕
          ['y'] = {
            add = function()
              local ok, input = pcall(vim.fn.input, 'Enter a URL: ')
              if not ok or input == '' then
                return { { '[', ']()', } }
              end
              return { { '[', '](' .. input .. ')' } }
            end,
          },
        },
      })
    end,
  },

  -- 智能窗口分割和导航
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    keys = {
      -- 窗口导航
      { '<C-h>', function() require('smart-splits').move_cursor_left() end, desc = 'Move to left window' },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end, desc = 'Move to down window' },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end, desc = 'Move to up window' },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end, desc = 'Move to right window' },
      -- 窗口大小调整
      { '<A-h>', function() require('smart-splits').resize_left() end, desc = 'Resize left' },
      { '<A-j>', function() require('smart-splits').resize_down() end, desc = 'Resize down' },
      { '<A-k>', function() require('smart-splits').resize_up() end, desc = 'Resize up' },
      { '<A-l>', function() require('smart-splits').resize_right() end, desc = 'Resize right' },
      -- 窗口交换
      { '<leader><C-h>', function() require('smart-splits').swap_buf_left() end, desc = 'Swap buffer left' },
      { '<leader><C-j>', function() require('smart-splits').swap_buf_down() end, desc = 'Swap buffer down' },
      { '<leader><C-k>', function() require('smart-splits').swap_buf_up() end, desc = 'Swap buffer up' },
      { '<leader><C-l>', function() require('smart-splits').swap_buf_right() end, desc = 'Swap buffer right' },
    },
    opts = {
      ignored_filetypes = { 'nofile', 'quickfix', 'prompt' },
      ignored_buftypes = { 'NvimTree', 'neo-tree', 'dashboard' },
      default_amount = 3,
      at_edge = 'wrap',
      cursor_follows_swaps = true,
      resize_mode = {
        quit_key = '<ESC>',
        resize_keys = { 'h', 'j', 'k', 'l' },
        silent = false,
      },
      disable_multiplexer_nav_when_zoomed = true,
    },
  },

  -- 代码结构操作 - 分割/合并代码块
  {
    'Wansmer/treesj',
    keys = {
      { '<leader>j', '<CMD>TSJToggle<CR>', desc = 'Toggle code structure' },
      { '<leader>J', '<CMD>TSJSplit<CR>', desc = 'Split code structure' },
      { '<leader>M', '<CMD>TSJJoin<CR>', desc = 'Join code structure' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
      max_join_length = 120,
      cursor_behavior = 'hold',
      notify = true,
      dot_repeat = true,
      check_syntax_error = true,
      langs = {
        lua = {
          table = { both = true, split = { recursive = true } },
          function_call = { both = true, split = { recursive = true } },
          function_declaration = { both = true, split = { recursive = true } },
          array = { both = true, split = { recursive = true } },
        },
        python = {
          dictionary = { both = true },
          list = { both = true },
          argument_list = { both = true },
          parameters = { both = true },
          function_definition = { both = true, split = { recursive = true } },
          class_definition = { both = true, split = { recursive = true } },
        },
        javascript = {
          object = { both = true },
          array = { both = true },
          argument_list = { both = true },
          statement_block = { both = true },
        },
        typescript = {
          object = { both = true },
          array = { both = true },
          argument_list = { both = true },
          statement_block = { both = true },
        },
        json = {
          object = { both = true },
          array = { both = true },
        },
      },
    },
  },

  -- 文本替换增强
  {
    'gbprod/substitute.nvim',
    keys = {
      { 's', mode = { 'n', 'x' }, desc = 'Substitute' },
      { 'ss', mode = 'n', desc = 'Substitute line' },
      { 'S', mode = 'n', desc = 'Substitute until end of line' },
      { '<leader>sr', '<CMD>lua require("substitute.range").operator()<CR>', desc = 'Substitute range' },
    },
    opts = {
      on_substitute = nil,
      yank_substituted_text = false,
      preserve_cursor_position = false,
      modifiers = nil,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        prefix = 's',
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        subject = nil,
        range = nil,
        suffix = '',
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
        modifiers = nil,
      },
    },
  },
}