-- CSS 文件类型特定配置
-- 标准化配置：编辑器设置 + CSS开发环境优化
-- 职责：提供CSS开发环境的文件类型特定优化
-- 依赖：主LSP配置已在 lsp-config.lua 中统一管理

-- ==========================================
-- 编辑器核心设置
-- ==========================================

-- 缩进和对齐设置（遵循CSS开发标准）
vim.opt_local.tabstop = 2      -- 制表符宽度（CSS标准）
vim.opt_local.shiftwidth = 2   -- 自动缩进宽度
vim.opt_local.expandtab = true -- 使用空格代替制表符
vim.opt_local.softtabstop = 2  -- 退格键删除的宽度

-- 智能缩进配置
vim.opt_local.autoindent = true  -- 自动继承上一行缩进
vim.opt_local.smartindent = true -- 智能缩进
vim.opt_local.indentexpr = ''    -- 禁用表达式缩进

-- 代码格式化设置
vim.opt_local.textwidth = 120    -- CSS行长度限制
vim.opt_local.formatoptions:append('cro') -- 自动换行和注释格式

-- ==========================================
-- 语法和显示增强
-- ==========================================

-- 注释格式配置
vim.opt_local.commentstring = '/* %s */'

-- 代码折叠设置
vim.opt_local.foldmethod = 'indent' -- 基于缩进折叠（适合CSS）
vim.opt_local.foldlevel = 99        -- 默认展开所有折叠
vim.opt_local.foldnestmax = 10      -- 最大折叠层数

-- 括号匹配增强（CSS选择器支持）
vim.opt_local.showmatch = true        -- 显示匹配括号

-- 自动换行和显示设置（CSS特有）
vim.opt_local.wrap = true             -- 启用自动换行
vim.opt_local.linebreak = true        -- 在单词边界换行
vim.opt_local.breakindent = true      -- 换行时保持缩进
vim.opt_local.showbreak = '↪ '        -- 换行指示符

-- ==========================================
-- CSS预处理器检测
-- ==========================================

-- 检测CSS预处理器类型
local function detect_css_preprocessor()
  local preprocessors = {
    { file = 'style.scss', type = 'SCSS' },
    { file = 'style.sass', type = 'Sass' },
    { file = 'style.less', type = 'Less' },
    { file = 'style.styl', type = 'Stylus' },
    { file = 'variables.scss', type = 'SCSS' },
    { file = 'variables.sass', type = 'Sass' },
    { file = 'variables.less', type = 'Less' },
    { file = 'variables.styl', type = 'Stylus' },
    { file = 'main.scss', type = 'SCSS' },
    { file = 'main.sass', type = 'Sass' },
    { file = 'main.less', type = 'Less' },
    { file = 'main.styl', type = 'Stylus' }
  }
  
  for _, config in ipairs(preprocessors) do
    if vim.fn.filereadable(config.file) == 1 then
      return config.type
    end
  end
  
  return 'Standard CSS'
end

-- 检测CSS框架
local function detect_css_framework()
  local frameworks = {
    { file = 'bootstrap.min.css', name = 'Bootstrap' },
    { file = 'bootstrap.css', name = 'Bootstrap' },
    { file = 'tailwind.css', name = 'Tailwind CSS' },
    { file = 'tailwind.min.css', name = 'Tailwind CSS' },
    { file = 'bulma.min.css', name = 'Bulma' },
    { file = 'bulma.css', name = 'Bulma' },
    { file = 'foundation.min.css', name = 'Foundation' },
    { file = 'foundation.css', name = 'Foundation' },
    { file = 'semantic.min.css', name = 'Semantic UI' },
    { file = 'semantic.css', name = 'Semantic UI' },
    { file = 'materialize.min.css', name = 'Materialize' },
    { file = 'materialize.css', name = 'Materialize' },
    { file = 'uikit.min.css', name = 'UIkit' },
    { file = 'uikit.css', name = 'UIkit' }
  }
  
  local detected = {}
  for _, framework in ipairs(frameworks) do
    if vim.fn.filereadable(framework.file) == 1 or vim.fn.filereadable('node_modules/' .. framework.file) == 1 then
      table.insert(detected, framework.name)
    end
  end
  
  return #detected > 0 and table.concat(detected, ', ') or 'None detected'
end

-- 检测构建工具
local function detect_build_tool()
  local tools = {
    { file = 'webpack.config.js', name = 'Webpack' },
    { file = 'vite.config.js', name = 'Vite' },
    { file = 'rollup.config.js', name = 'Rollup' },
    { file = 'parcel.config.js', name = 'Parcel' },
    { file = 'gulpfile.js', name = 'Gulp' },
    { file = 'Gruntfile.js', name = 'Grunt' },
    { file = 'postcss.config.js', name = 'PostCSS' },
    { file = '.postcssrc', name = 'PostCSS' },
    { file = 'tailwind.config.js', name = 'Tailwind Config' }
  }
  
  for _, tool in ipairs(tools) do
    if vim.fn.filereadable(tool.file) == 1 then
      return tool.name
    end
  end
  
  return 'None detected'
end

-- 检测CSS模块化方案
local function detect_css_module()
  local modules = {
    { file = 'styles.module.css', type = 'CSS Modules' },
    { file = 'component.module.css', type = 'CSS Modules' },
    { file = 'styles.module.scss', type = 'CSS Modules (SCSS)' },
    { file = 'styled-components', type = 'Styled Components' },
    { file = 'emotion', type = 'Emotion' },
    { file = 'jss', type = 'JSS' },
    { file = 'aphrodite', type = 'Aphrodite' }
  }
  
  for _, module in ipairs(modules) do
    if vim.fn.filereadable(module.file) == 1 or vim.fn.filereadable('node_modules/' .. module.file) == 1 then
      return module.type
    end
  end
  
  return 'Standard CSS'
end

-- ==========================================
-- 实用工具函数
-- ==========================================

-- 格式化CSS代码
local function format_css()
  local current_file = vim.fn.expand('%:p')
  local file_ext = vim.fn.expand('%:e')
  
  -- 根据文件类型选择格式化器
  if file_ext == 'scss' or file_ext == 'sass' then
    -- SCSS/Sass格式化
    if vim.fn.executable('sass-convert') == 1 then
      local result = vim.fn.system('sass-convert --from sass --to sass "' .. current_file .. '" > "' .. current_file .. '.tmp"')
      if vim.v.shell_error == 0 then
        vim.fn.system('mv "' .. current_file .. '.tmp" "' .. current_file .. '"')
        vim.notify('SCSS formatted with sass-convert', vim.log.levels.INFO)
        vim.cmd('edit!')
      else
        vim.notify('SCSS formatting failed: ' .. result, vim.log.levels.ERROR)
      end
    elseif vim.fn.executable('prettier') == 1 then
      local result = vim.fn.system('prettier --write "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('SCSS formatted with Prettier', vim.log.levels.INFO)
        vim.cmd('edit!')
      else
        vim.notify('SCSS formatting failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('No SCSS formatter found (sass-convert or prettier)', vim.log.levels.WARN)
    end
  elseif file_ext == 'less' then
    -- Less格式化
    if vim.fn.executable('prettier') == 1 then
      local result = vim.fn.system('prettier --write "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('Less formatted with Prettier', vim.log.levels.INFO)
        vim.cmd('edit!')
      else
        vim.notify('Less formatting failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('Prettier not found for Less formatting', vim.log.levels.WARN)
    end
  elseif file_ext == 'styl' then
    -- Stylus格式化
    if vim.fn.executable('stylus') == 1 then
      local result = vim.fn.system('stylus --css "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('Stylus compiled and formatted', vim.log.levels.INFO)
      else
        vim.notify('Stylus formatting failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('Stylus not found', vim.log.levels.WARN)
    end
  else
    -- 标准CSS格式化
    if vim.fn.executable('prettier') == 1 then
      local result = vim.fn.system('prettier --write "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('CSS formatted with Prettier', vim.log.levels.INFO)
        vim.cmd('edit!')
      else
        vim.notify('CSS formatting failed: ' .. result, vim.log.levels.ERROR)
      end
    elseif vim.fn.executable('css-beautify') == 1 then
      local result = vim.fn.system('css-beautify -r "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('CSS formatted with css-beautify', vim.log.levels.INFO)
        vim.cmd('edit!')
      else
        vim.notify('CSS formatting failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('No CSS formatter found (prettier or css-beautify)', vim.log.levels.WARN)
    end
  end
end

-- 验证CSS语法
local function validate_css()
  local current_file = vim.fn.expand('%:p')
  local file_ext = vim.fn.expand('%:e')
  
  -- 根据文件类型选择验证器
  if file_ext == 'scss' or file_ext == 'sass' then
    -- SCSS/Sass验证
    if vim.fn.executable('sass') == 1 then
      local result = vim.fn.system('sass --check "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('SCSS validation passed!', vim.log.levels.INFO)
      else
        vim.notify('SCSS validation errors found:\n' .. result, vim.log.levels.WARN)
      end
    else
      vim.notify('sass not found for SCSS validation', vim.log.levels.WARN)
    end
  elseif file_ext == 'less' then
    -- Less验证
    if vim.fn.executable('lessc') == 1 then
      local result = vim.fn.system('lessc --lint "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('Less validation passed!', vim.log.levels.INFO)
      else
        vim.notify('Less validation errors found:\n' .. result, vim.log.levels.WARN)
      end
    else
      vim.notify('lessc not found for Less validation', vim.log.levels.WARN)
    end
  elseif file_ext == 'styl' then
    -- Stylus验证
    if vim.fn.executable('stylus') == 1 then
      local result = vim.fn.system('stylus --check "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('Stylus validation passed!', vim.log.levels.INFO)
      else
        vim.notify('Stylus validation errors found:\n' .. result, vim.log.levels.WARN)
      end
    else
      vim.notify('stylus not found for Stylus validation', vim.log.levels.WARN)
    end
  else
    -- 标准CSS验证
    if vim.fn.executable('stylelint') == 1 then
      local result = vim.fn.system('stylelint "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('CSS validation passed!', vim.log.levels.INFO)
      else
        vim.notify('CSS validation errors found:\n' .. result, vim.log.levels.WARN)
      end
    else
      vim.notify('stylelint not found. Install it for CSS validation.', vim.log.levels.WARN)
    end
  end
end

-- 编译CSS预处理器
local function compile_preprocessor()
  local current_file = vim.fn.expand('%:p')
  local file_ext = vim.fn.expand('%:e')
  
  if file_ext == 'scss' or file_ext == 'sass' then
    -- 编译SCSS/Sass
    if vim.fn.executable('sass') == 1 then
      local output_file = current_file:gsub('%.%w+$', '.css')
      local result = vim.fn.system('sass "' .. current_file .. '" "' .. output_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('SCSS compiled to: ' .. output_file, vim.log.levels.INFO)
      else
        vim.notify('SCSS compilation failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('sass not found for compilation', vim.log.levels.WARN)
    end
  elseif file_ext == 'less' then
    -- 编译Less
    if vim.fn.executable('lessc') == 1 then
      local output_file = current_file:gsub('%.%w+$', '.css')
      local result = vim.fn.system('lessc "' .. current_file .. '" "' .. output_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('Less compiled to: ' .. output_file, vim.log.levels.INFO)
      else
        vim.notify('Less compilation failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('lessc not found for compilation', vim.log.levels.WARN)
    end
  elseif file_ext == 'styl' then
    -- 编译Stylus
    if vim.fn.executable('stylus') == 1 then
      local output_file = current_file:gsub('%.%w+$', '.css')
      local result = vim.fn.system('stylus --out "' .. output_file .. '" "' .. current_file .. '"')
      if vim.v.shell_error == 0 then
        vim.notify('Stylus compiled to: ' .. output_file, vim.log.levels.INFO)
      else
        vim.notify('Stylus compilation failed: ' .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify('stylus not found for compilation', vim.log.levels.WARN)
    end
  else
    vim.notify('Current file is not a preprocessor file', vim.log.levels.WARN)
  end
end

-- 创建CSS模板
local function create_css_template()
  local current_ext = vim.fn.expand('%:e')
  local template = ''
  
  if current_ext == 'scss' then
    template = [[
// SCSS Variables
$primary-color: #007bff;
$secondary-color: #6c757d;
$font-size-base: 16px;

// Mixins
@mixin flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

// Base styles
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: $font-size-base;
  line-height: 1.6;
  color: #333;
}

.container {
  @include flex-center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}
]]
  elseif current_ext == 'less' then
    template = [[
// Less Variables
@primary-color: #007bff;
@secondary-color: #6c757d;
@font-size-base: 16px;

// Mixins
.flex-center() {
  display: flex;
  justify-content: center;
  align-items: center;
}

// Base styles
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: @font-size-base;
  line-height: 1.6;
  color: #333;
}

.container {
  .flex-center();
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}
]]
  else
    template = [[
/* CSS Variables */
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --font-size-base: 16px;
}

/* Base styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: var(--font-size-base);
  line-height: 1.6;
  color: #333;
}

.container {
  display: flex;
  justify-content: center;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}
]]
  end
  
  -- 检查当前文件是否为空
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local is_empty = #lines == 0 or (#lines == 1 and lines[1] == '')
  
  if is_empty then
    -- 插入模板到当前文件
    local template_lines = vim.split(template, '\n')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template_lines)
    vim.notify('CSS template inserted for ' .. current_ext, vim.log.levels.INFO)
  else
    vim.notify('File is not empty. Template not inserted.', vim.log.levels.WARN)
  end
end

-- ==========================================
-- 键盘映射配置
-- ==========================================

local opts = { buffer = true, silent = true }

-- 核心CSS开发快捷键
vim.keymap.set('n', '<leader>cf', format_css,
  vim.tbl_extend('force', opts, { desc = 'CSS: Format Code' }))

vim.keymap.set('n', '<leader>cv', validate_css,
  vim.tbl_extend('force', opts, { desc = 'CSS: Validate Syntax' }))

vim.keymap.set('n', '<leader>cc', compile_preprocessor,
  vim.tbl_extend('force', opts, { desc = 'CSS: Compile Preprocessor' }))

vim.keymap.set('n', '<leader>ct', create_css_template,
  vim.tbl_extend('force', opts, { desc = 'CSS: Insert Template' }))

-- 项目信息
vim.keymap.set('n', '<leader>cp', function()
  local preprocessor = detect_css_preprocessor()
  local framework = detect_css_framework()
  local build_tool = detect_build_tool()
  local module = detect_css_module()
  vim.notify(string.format('Preprocessor: %s, Framework: %s, Build: %s, Module: %s', 
    preprocessor, framework, build_tool, module), vim.log.levels.INFO)
end, vim.tbl_extend('force', opts, { desc = 'CSS: Show Project Info' }))

-- ==========================================
-- 自动命令配置
-- ==========================================

local css_group = vim.api.nvim_create_augroup('CSSSettings', { clear = true })

-- 保存时自动格式化（如果启用）
vim.api.nvim_create_autocmd('BufWritePre', {
  group = css_group,
  pattern = { '*.css', '*.scss', '*.sass', '*.less', '*.styl' },
  callback = function()
    if vim.lsp.buf.server_ready() then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.name == 'cssls' or client.name == 'tailwindcss' then
          vim.lsp.buf.format({ async = false })
          break
        end
      end
    end
  end,
})

-- 检测CSS预处理器并通知
vim.api.nvim_create_autocmd('BufEnter', {
  group = css_group,
  pattern = { '*.css', '*.scss', '*.sass', '*.less', '*.styl' },
  callback = function()
    local preprocessor = detect_css_preprocessor()
    local framework = detect_css_framework()
    local build_tool = detect_build_tool()
    local module = detect_css_module()
    vim.notify(string.format('CSS: %s, Framework: %s, Build: %s, Module: %s', 
      preprocessor, framework, build_tool, module), vim.log.levels.INFO)
  end,
})

-- 自动检测编译需求（对于预处理器）
vim.api.nvim_create_autocmd('BufWritePost', {
  group = css_group,
  pattern = { '*.scss', '*.sass', '*.less', '*.styl' },
  callback = function()
    -- 检查是否有对应的CSS文件
    local current_file = vim.fn.expand('%:p')
    local css_file = current_file:gsub('%.%w+$', '.css')
    
    if vim.fn.filereadable(css_file) == 1 then
      vim.notify('Preprocessor file saved. Consider recompiling.', vim.log.levels.INFO)
    end
  end,
})

-- ==========================================
-- 初始化通知
-- ==========================================

local preprocessor = detect_css_preprocessor()
local framework = detect_css_framework()
local build_tool = detect_build_tool()
local module = detect_css_module()
vim.notify(string.format('CSS LSP配置已加载 - 预处理器: %s, 框架: %s, 构建工具: %s, 模块化: %s', 
  preprocessor, framework, build_tool, module), vim.log.levels.INFO)