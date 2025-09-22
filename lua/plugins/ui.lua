return{
  {
    "hardhackerlabs/theme-vim",
    name = "hardhacker",
    lazy = false, -- 默认主题不延迟加载
    priority = 1001, -- 最高优先级
    config = function()
      -- 安全设置全局变量
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      
      -- 安全设置配色方案
      local colorscheme_status_ok, _ = pcall(vim.cmd.colorscheme, "hardhacker")
      if not colorscheme_status_ok then
        vim.cmd.colorscheme("default")
      end
    end,
  },

}