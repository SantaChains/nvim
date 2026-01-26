-- TreeSitter 配置
-- 提供语法高亮、代码折叠、增量选择等功能

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TSInstall",
    "TSInstallInfo", 
    "TSUpdate",
    "TSBufEnable",
    "TSBufDisable",
    "TSModuleInfo"
  },
  dependencies = {
    -- 额外的 TreeSitter 模块
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  
  ---@type TSConfig
  opts = {
    -- 确保安装的语言解析器
    ensure_installed = {
      "lua",
      "vim", 
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "bash",
      "python",
      "javascript",
      "typescript",
      "json",
      "yaml",
      "toml",
      "html",
      "css",
      "c",
      "cpp",
      "rust",
      "go",
      "latex",  -- 添加 LaTeX 支持
    },
    
    -- 自动安装缺失的解析器
    auto_install = false,
    
    -- 启用语法高亮
    highlight = {
      enable = true,
      -- 对于大文件禁用以提升性能
      disable = function(lang, buf)
        -- 大文件性能优化
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
          -- 其他语言的特定处理可以在这里添加
      end,
      -- 使用 Vim 的正则表达式引擎作为后备
      additional_vim_regex_highlighting = false,
    },
    
    -- 启用增量选择
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    
    -- 启用基于 TreeSitter 的缩进
    indent = {
      enable = true,
      -- 某些语言的缩进可能有问题，可以在这里禁用
      disable = { "python", "yaml" },
    },
    
    -- 文本对象配置 - 按键配置已注释，避免重复定义
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- 自动跳转到下一个文本对象
        keymaps = {
          -- 函数相关 - 已注释避免按键冲突
          -- ["af"] = "@function.outer",
          -- ["if"] = "@function.inner",
          -- 类相关 - 已注释避免按键冲突  
          -- ["ac"] = "@class.outer",
          -- ["ic"] = "@class.inner",
          -- 参数相关 - 已注释避免按键冲突
          -- ["aa"] = "@parameter.outer",
          -- ["ia"] = "@parameter.inner",
          -- 条件语句 - 已注释避免按键冲突
          -- ["a?"] = "@conditional.outer",
          -- ["i?"] = "@conditional.inner",
          -- 循环 - 已注释避免按键冲突
          -- ["al"] = "@loop.outer",
          -- ["il"] = "@loop.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- 是否在跳转列表中设置跳转
        goto_next_start = {
          -- 已注释避免按键冲突
          -- ["]f"] = "@function.outer",
          -- ["]c"] = "@class.outer",
        },
        goto_next_end = {
          -- 已注释避免按键冲突
          -- ["]F"] = "@function.outer", 
          -- ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          -- 已注释避免按键冲突
          -- ["[f"] = "@function.outer",
          -- ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          -- 已注释避免按键冲突
          -- ["[F"] = "@function.outer",
          -- ["[C"] = "@class.outer",
        },
      },
    },
  },
  
  config = function(_, opts)
    local safe_require = require('utils.safe_require')
    -- 加载 treesitter 配置 - 官方推荐简洁方式
    local treesitter = safe_require.safe_require('nvim-treesitter')
    if treesitter then
      treesitter.setup(opts)
    end
    
    -- 移除自定义的TSInstallInfo命令，使用内置的
    

  end,
}