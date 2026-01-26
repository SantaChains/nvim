return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  -- Optional: for snippet support (if you have LuaSnip)
  config = function()
    local safe_require = require('utils.safe_require')
    local neogen = safe_require.safe_require('neogen')
    if not neogen then return end
    
    neogen.setup({
      -- 启用插件
      enabled = true,
      -- 注释后自动进入插入模式
      input_after_comment = true,
      -- 使用 LuaSnip 作为代码片段引擎
      snippet_engine = "luasnip",
      -- 语言特定配置
      languages = {
        -- Lua 配置
        lua = {
          template = {
            annotation_convention = "ldoc", -- 使用 LDoc 风格
          },
        },
        -- Python 配置
        python = {
          template = {
            annotation_convention = "google_docstrings", -- Google 风格 docstring
          },
        },
        -- JavaScript/TypeScript 配置
        javascript = {
          template = {
            annotation_convention = "jsdoc", -- JSDoc 风格
          },
        },
        typescript = {
          template = {
            annotation_convention = "tsdoc", -- TSDoc 风格
          },
        },
        -- C/C++ 配置
        cpp = {
          template = {
            annotation_convention = "doxygen", -- Doxygen 风格
          },
        },
        c = {
          template = {
            annotation_convention = "doxygen", -- Doxygen 风格
          },
        },
        -- Rust 配置
        rust = {
          template = {
            annotation_convention = "rustdoc", -- Rustdoc 风格
          },
        },
        -- Go 配置
        go = {
          template = {
            annotation_convention = "godoc", -- GoDoc 风格
          },
        },
      },
    })
  end,
  -- 按键映射
  keys = {
    -- 生成当前函数的注释
    { "<leader>nf", function()
      local safe_require = require('utils.safe_require')
      local neogen = safe_require.safe_require('neogen')
      if neogen then neogen.generate({ type = 'func' }) end
    end, desc = "生成函数注释" },
    -- 生成当前类的注释
    { "<leader>nc", function()
      local safe_require = require('utils.safe_require')
      local neogen = safe_require.safe_require('neogen')
      if neogen then neogen.generate({ type = 'class' }) end
    end, desc = "生成类注释" },
    -- 生成当前类型的注释
    { "<leader>nt", function()
      local safe_require = require('utils.safe_require')
      local neogen = safe_require.safe_require('neogen')
      if neogen then neogen.generate({ type = 'type' }) end
    end, desc = "生成类型注释" },
    -- 生成文件注释
    { "<leader>nd", function()
      local safe_require = require('utils.safe_require')
      local neogen = safe_require.safe_require('neogen')
      if neogen then neogen.generate({ type = 'file' }) end
    end, desc = "生成文件注释" },
    -- 智能生成（根据上下文自动选择类型）
    { "<leader>na", function()
      local safe_require = require('utils.safe_require')
      local neogen = safe_require.safe_require('neogen')
      if neogen then neogen.generate() end
    end, desc = "智能生成注释" },
  },
}