-- 编辑器UI相关插件配置文件
-- 该文件作为统一的UI插件入口，具体配置请参考独立的插件配置文件

return {
  -- 缩进线插件 - 详细配置见 indent-blankline.lua
  { import = "plugins.indent-blankline" },
  
  -- 代码高亮插件 - 详细配置见 vim-illuminate.lua
  { import = "plugins.vim-illuminate" },
}