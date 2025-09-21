-- HTML 文件类型特定配置
-- 标准化配置：编辑器设置 + Web开发环境优化
-- 职责：提供HTML开发环境的文件类型特定优化
-- 依赖：主LSP配置已在 lsp-config.lua 中统一管理

-- ==========================================
-- 编辑器核心设置
-- ==========================================

-- 缩进和对齐设置（遵循Web开发标准）
vim.opt_local.tabstop = 2      -- 制表符宽度（HTML标准）
vim.opt_local.shiftwidth = 2   -- 自动缩进宽度
vim.opt_local.expandtab = true -- 使用空格代替制表符
vim.opt_local.softtabstop = 2  -- 退格键删除的宽度

-- 智能缩进配置
vim.opt_local.autoindent = true  -- 自动继承上一行缩进
vim.opt_local.smartindent = true -- 智能缩进
vim.opt_local.indentexpr = ''    -- 禁用表达式缩进

-- 代码格式化设置
vim.opt_local.textwidth = 120    -- HTML行长度限制
vim.opt_local.formatoptions:append('cro') -- 自动换行和注释格式

-- ==========================================
-- 语法和显示增强
-- ==========================================

-- 注释格式配置
vim.opt_local.commentstring = '<!-- %s -->'

-- 代码折叠设置
vim.opt_local.foldmethod = 'indent' -- 基于缩进折叠（适合HTML）
vim.opt_local.foldlevel = 99        -- 默认展开所有折叠
vim.opt_local.foldnestmax = 10      -- 最大折叠层数

-- 括号匹配增强（HTML标签支持）
vim.opt_local.matchpairs:append('<:>') -- 添加HTML标签匹配
vim.opt_local.showmatch = true        -- 显示匹配标签

-- 自动换行和显示设置（HTML特有）
vim.opt_local.wrap = true             -- 启用自动换行
vim.opt_local.linebreak = true        -- 在单词边界换行
vim.opt_local.breakindent = true      -- 换行时保持缩进
vim.opt_local.showbreak = '↪ '        -- 换行指示符

-- ==========================================
-- Web项目类型检测
-- ==========================================

-- 检测Web项目类型
local function detect_web_project_type()
  local configs = {
    { file = 'package.json', type = 'Modern Web Project' },
    { file = 'index.html', type = 'Static HTML' },
    { file = 'style.css', type = 'CSS Project' },
    { file = 'script.js', type = 'JavaScript Project' },
    { file = 'main.js', type = 'JavaScript Project' },
    { file = 'app.js', type = 'JavaScript Project' },
    { file = 'webpack.config.js', type = 'Webpack Project' },
    { file = 'vite.config.js', type = 'Vite Project' },
    { file = 'next.config.js', type = 'Next.js Project' },
    { file = 'nuxt.config.js', type = 'Nuxt.js Project' },
    { file = 'angular.json', type = 'Angular Project' },
    { file = 'react-app-env.d.ts', type = 'React Project' },
    { file = '.htaccess', type = 'Apache Server' },
    { file = 'nginx.conf', type = 'Nginx Server' },
    { file = 'robots.txt', type = 'SEO Optimized' }
  }
  
  for _, config in ipairs(configs) do
    if vim.fn.filereadable(config.file) == 1 then
      return config.type
    end
  end
  
  return 'Standard HTML'
end

-- 检测Web框架
local function detect_web_framework()
  local frameworks = {
    { file = 'bootstrap.min.css', name = 'Bootstrap' },
    { file = 'tailwind.css', name = 'Tailwind CSS' },
    { file = 'jquery.min.js', name = 'jQuery' },
    { file = 'react.production.min.js', name = 'React' },
    { file = 'vue.global.js', name = 'Vue.js' },
    { file = 'angular.min.js', name = 'Angular' },
    { file = 'svelte.min.js', name = 'Svelte' },
    { file = 'foundation.min.js', name = 'Foundation' },
    { file = 'bulma.min.css', name = 'Bulma' },
    { file = 'semantic.min.css', name = 'Semantic UI' }
  }
  
  local detected = {}
  for _, framework in ipairs(frameworks) do
    if vim.fn.filereadable(framework.file) == 1 or vim.fn.filereadable('node_modules/' .. framework.file) == 1 then
      table.insert(detected, framework.name)
    end
  end
  
  return #detected > 0 and table.concat(detected, ', ') or 'None detected'
end

-- 检测浏览器兼容性
local function detect_browser_compatibility()
  local modern_features = {
    { file = 'service-worker.js', feature = 'PWA' },
    { file = 'manifest.json', feature = 'Web App Manifest' },
    { file = 'web.config', feature = 'IIS Configuration' },
    { file = '.htaccess', feature = 'Apache Rewrite' },
    { file = 'sw.js', feature = 'Service Worker' },
    { file = 'workbox-sw.js', feature = 'Workbox' }
  }
  
  local features = {}
  for _, feature in ipairs(modern_features) do
    if vim.fn.filereadable(feature.file) == 1 then
      table.insert(features, feature.feature)
    end
  end
  
  return #features > 0 and table.concat(features, ', ') or 'Standard HTML5'
end

-- ==========================================
-- 实用工具函数
-- ==========================================

-- 在浏览器中打开当前HTML文件
local function open_in_browser()
  local current_file = vim.fn.expand('%:p')
  local browsers = { 'chrome', 'firefox', 'edge', 'opera', 'brave' }
  
  for _, browser in ipairs(browsers) do
    if vim.fn.executable(browser) == 1 then
      if vim.fn.has('win32') == 1 then
        vim.fn.system('start ' .. browser .. ' "file:///' .. current_file .. '"')
      elseif vim.fn.has('mac') == 1 then
        vim.fn.system('open -a "' .. browser .. '" "file://' .. current_file .. '"')
      else
        vim.fn.system(browser .. ' "file://' .. current_file .. '" &')
      end
      vim.notify('Opening in ' .. browser .. ': ' .. current_file, vim.log.levels.INFO)
      return
    end
  end
  
  -- 如果找不到浏览器，使用默认方式
  if vim.fn.has('win32') == 1 then
    vim.fn.system('start "" "file:///' .. current_file .. '"')
  elseif vim.fn.has('mac') == 1 then
    vim.fn.system('open "file://' .. current_file .. '"')
  else
    vim.fn.system('xdg-open "file://' .. current_file .. '"')
  end
  vim.notify('Opening in default browser: ' .. current_file, vim.log.levels.INFO)
end

-- 验证HTML语法
local function validate_html()
  local current_file = vim.fn.expand('%:p')
  
  -- 尝试使用w3c验证器（如果可用）
  if vim.fn.executable('tidy') == 1 then
    local result = vim.fn.system('tidy -errors -quiet "' .. current_file .. '" 2>&1')
    if vim.v.shell_error == 0 then
      vim.notify('HTML validation passed!', vim.log.levels.INFO)
    else
      vim.notify('HTML validation errors found:\n' .. result, vim.log.levels.WARN)
    end
  else
    vim.notify('tidy not found. Install it for HTML validation.', vim.log.levels.WARN)
  end
end

-- 格式化HTML代码
local function format_html()
  local current_file = vim.fn.expand('%:p')
  
  -- 尝试使用prettier（如果可用）
  if vim.fn.executable('prettier') == 1 then
    local result = vim.fn.system('prettier --write "' .. current_file .. '"')
    if vim.v.shell_error == 0 then
      vim.notify('HTML formatted with Prettier', vim.log.levels.INFO)
      vim.cmd('edit!') -- 重新加载文件
    else
      vim.notify('HTML formatting failed: ' .. result, vim.log.levels.ERROR)
    end
  elseif vim.fn.executable('tidy') == 1 then
    -- 使用tidy作为备选
    local result = vim.fn.system('tidy -indent -quiet -utf8 "' .. current_file .. '" > "' .. current_file .. '.tmp" 2>&1')
    if vim.v.shell_error == 0 then
      vim.fn.system('mv "' .. current_file .. '.tmp" "' .. current_file .. '"')
      vim.notify('HTML formatted with tidy', vim.log.levels.INFO)
      vim.cmd('edit!') -- 重新加载文件
    else
      vim.notify('HTML formatting failed: ' .. result, vim.log.levels.ERROR)
    end
  else
    vim.notify('No HTML formatter found (prettier or tidy)', vim.log.levels.WARN)
  end
end

-- 创建HTML模板
local function create_html_template()
  local template = [[
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        /* 基础样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #fff;
        }
    </style>
</head>
<body>
    <header>
        <h1>页面标题</h1>
    </header>
    
    <main>
        <section>
            <h2>主要内容</h2>
            <p>这里是页面的主要内容。</p>
        </section>
    </main>
    
    <footer>
        <p>&copy; 2024 版权所有</p>
    </footer>
    
    <script>
        // 页面脚本
        document.addEventListener('DOMContentLoaded', function() {
            console.log('页面加载完成');
        });
    </script>
</body>
</html>
]]
  
  -- 检查当前文件是否为空
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local is_empty = #lines == 0 or (#lines == 1 and lines[1] == '')
  
  if is_empty then
    -- 插入模板到当前文件
    local template_lines = vim.split(template, '\n')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template_lines)
    vim.notify('HTML template inserted', vim.log.levels.INFO)
  else
    vim.notify('File is not empty. Template not inserted.', vim.log.levels.WARN)
  end
end

-- 检测CSS文件
local function detect_css_files()
  local css_files = {}
  local patterns = { '*.css', '*.scss', '*.sass', '*.less', '*.styl' }
  
  for _, pattern in ipairs(patterns) do
    local files = vim.fn.glob(pattern, false, true)
    for _, file in ipairs(files) do
      table.insert(css_files, file)
    end
  end
  
  return css_files
end

-- ==========================================
-- 键盘映射配置
-- ==========================================

local opts = { buffer = true, silent = true }

-- 核心Web开发快捷键
vim.keymap.set('n', '<leader>wb', open_in_browser,
  vim.tbl_extend('force', opts, { desc = 'HTML: Open in Browser' }))

vim.keymap.set('n', '<leader>wv', validate_html,
  vim.tbl_extend('force', opts, { desc = 'HTML: Validate Syntax' }))

vim.keymap.set('n', '<leader>wf', format_html,
  vim.tbl_extend('force', opts, { desc = 'HTML: Format Code' }))

vim.keymap.set('n', '<leader>wt', create_html_template,
  vim.tbl_extend('force', opts, { desc = 'HTML: Insert Template' }))

vim.keymap.set('n', '<leader>wc', function()
  local css_files = detect_css_files()
  if #css_files > 0 then
    vim.notify('CSS files found: ' .. table.concat(css_files, ', '), vim.log.levels.INFO)
  else
    vim.notify('No CSS files found', vim.log.levels.WARN)
  end
end, vim.tbl_extend('force', opts, { desc = 'HTML: Check CSS Files' }))

-- 项目信息
vim.keymap.set('n', '<leader>wp', function()
  local project_type = detect_web_project_type()
  local frameworks = detect_web_framework()
  local browser_compat = detect_browser_compatibility()
  vim.notify(string.format('Project: %s, Frameworks: %s, Compatibility: %s', 
    project_type, frameworks, browser_compat), vim.log.levels.INFO)
end, vim.tbl_extend('force', opts, { desc = 'HTML: Show Project Info' }))

-- ==========================================
-- 自动命令配置
-- ==========================================

local html_group = vim.api.nvim_create_augroup('HTMLSettings', { clear = true })

-- 保存时自动格式化（如果启用）
vim.api.nvim_create_autocmd('BufWritePre', {
  group = html_group,
  pattern = { '*.html', '*.htm' },
  callback = function()
    if vim.lsp.buf.server_ready() then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.name == 'html' or client.name == 'emmet_language_server' then
          vim.lsp.buf.format({ async = false })
          break
        end
      end
    end
  end,
})

-- 检测项目类型并通知
vim.api.nvim_create_autocmd('BufEnter', {
  group = html_group,
  pattern = { '*.html', '*.htm' },
  callback = function()
    local project_type = detect_web_project_type()
    local frameworks = detect_web_framework()
    local browser_compat = detect_browser_compatibility()
    vim.notify(string.format('Web Project: %s, Frameworks: %s, Features: %s', 
      project_type, frameworks, browser_compat), vim.log.levels.INFO)
  end,
})

-- 自动检测CSS文件关联
vim.api.nvim_create_autocmd('BufEnter', {
  group = html_group,
  pattern = { '*.html', '*.htm' },
  callback = function()
    local css_files = detect_css_files()
    if #css_files > 0 then
      vim.notify('Associated CSS files: ' .. #css_files, vim.log.levels.INFO)
    end
  end,
})

-- ==========================================
-- 初始化通知
-- ==========================================

local project_type = detect_web_project_type()
local frameworks = detect_web_framework()
local browser_compat = detect_browser_compatibility()
vim.notify(string.format('HTML LSP配置已加载 - 项目类型: %s, 框架: %s, 特性: %s', 
  project_type, frameworks, browser_compat), vim.log.levels.INFO)