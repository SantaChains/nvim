return {
  'RRethy/vim-illuminate',
  config = function()
    -- 高亮当前光标下的单词
    require('illuminate').configure({
      -- 提供者配置
      providers = {
        "lsp",     -- LSP提供者
        "treesitter", -- Treesitter提供者
        "regex",   -- 正则表达式提供者
      },
      -- 延迟配置
      delay = 100,  -- 高亮延迟时间（毫秒）
      -- 文件类型黑名单
      filetype_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "neogitstatus",
        "Trouble",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "xplr",
        "telescope",
        "help",
        "dashboard",
        "neo-tree",
        "trouble",
        "mason",
        "notify",
        "lazyterm",
      },
      -- 文件类型白名单（如果设置，则只在这些文件类型中启用）
      filetype_allowlist = {},
      -- 模式黑名单
      modes_denylist = {},
      -- 模式白名单
      modes_allowlist = {},
      -- 正则表达式模式
      providers_regex_syntax_denylist = {},
      providers_regex_syntax_allowlist = {},
      -- 局部配置
      local_providers = {},
      -- 是否区分大小写
      case_insensitive_regex = false,
      -- 高亮配置
      large_file_cutoff = nil,  -- 大文件截断（nil表示不限制）
      large_file_overrides = nil,  -- 大文件覆盖配置
      min_count_to_highlight = 1,  -- 最小匹配数量才高亮
      -- 自定义高亮组
      under_cursor = true,  -- 高亮光标下的单词
      max_line_len = 400,  -- 最大行长度
      max_file_lines = nil,  -- 最大文件行数
    })
    
    -- 设置高亮组
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
  end,
  -- 快捷键配置
  keys = {
    -- 跳转到下一个引用
    { "n", "<a-n>", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference" },
    -- 跳转到上一个引用
    { "n", "<a-p>", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
    -- 在引用之间循环跳转
    { "n", "<a-i>", function() require("illuminate").textobj_select() end, desc = "Select reference" },
  },
}