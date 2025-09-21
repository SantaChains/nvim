return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    -- 缩进线配置
    indent = {
      char = "│",  -- 缩进线字符
      tab_char = "│",  -- tab缩进线字符
    },
    scope = {
      enabled = true,  -- 启用作用域高亮
      show_start = false,  -- 不显示开始标记
      show_end = false,  -- 不显示结束标记
    },
    exclude = {
      filetypes = {
        "help",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}