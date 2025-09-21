-- JavaScript/TypeScript 文件类型特定配置
-- 标准化配置：编辑器设置 + JS/TS开发环境优化
-- 职责：提供JavaScript和TypeScript开发环境的文件类型特定优化
-- 依赖：主LSP配置已在 lsp-config.lua 中统一管理

-- ==========================================
-- 编辑器核心设置
-- ==========================================

-- 缩进和对齐设置（遵循现代JS/TS标准）
vim.opt_local.tabstop = 2      -- 制表符宽度
vim.opt_local.shiftwidth = 2   -- 自动缩进宽度
vim.opt_local.expandtab = true -- 使用空格代替制表符
vim.opt_local.softtabstop = 2  -- 退格键删除的宽度

-- 智能缩进配置
vim.opt_local.autoindent = true  -- 自动继承上一行缩进
vim.opt_local.smartindent = true -- 智能缩进
vim.opt_local.indentexpr = ''    -- 禁用表达式缩进

-- 代码格式化设置
vim.opt_local.textwidth = 120    -- 现代JS/TS项目的行长度限制
vim.opt_local.formatoptions:append('cro') -- 自动换行和注释格式

-- ==========================================
-- 语法和显示增强
-- ==========================================

-- 注释格式配置
vim.opt_local.commentstring = '// %s'

-- 代码折叠设置
vim.opt_local.foldmethod = 'indent' -- 基于缩进折叠（适合JS/TS）
vim.opt_local.foldlevel = 99        -- 默认展开所有折叠
vim.opt_local.foldnestmax = 10      -- 最大折叠层数

-- 括号匹配增强（JSX/TSX支持）
vim.opt_local.matchpairs:append('<:>') -- 添加JSX标签匹配
vim.opt_local.showmatch = true        -- 显示匹配括号

-- ==========================================
-- 项目类型检测
-- ==========================================

-- 检测JavaScript项目类型
local function detect_js_project_type()
  local configs = {
    { file = 'package.json', type = 'Node.js' },
    { file = 'tsconfig.json', type = 'TypeScript' },
    { file = 'jsconfig.json', type = 'JavaScript with Config' },
    { file = 'webpack.config.js', type = 'Webpack' },
    { file = 'vite.config.js', type = 'Vite' },
    { file = 'rollup.config.js', type = 'Rollup' },
    { file = 'next.config.js', type = 'Next.js' },
    { file = 'nuxt.config.js', type = 'Nuxt.js' },
    { file = 'angular.json', type = 'Angular' },
    { file = 'react-app-env.d.ts', type = 'React TypeScript' },
    { file = '.eslintrc.js', type = 'ESLint Config' },
    { file = '.prettierrc', type = 'Prettier Config' }
  }
  
  for _, config in ipairs(configs) do
    if vim.fn.filereadable(config.file) == 1 then
      return config.type
    end
  end
  
  return 'Standard JavaScript'
end

-- 检测包管理器
local function detect_package_manager()
  local managers = {
    { file = 'yarn.lock', cmd = 'yarn', name = 'Yarn' },
    { file = 'package-lock.json', cmd = 'npm', name = 'NPM' },
    { file = 'pnpm-lock.yaml', cmd = 'pnpm', name = 'PNPM' },
    { file = 'bun.lockb', cmd = 'bun', name = 'Bun' }
  }
  
  for _, manager in ipairs(managers) do
    if vim.fn.filereadable(manager.file) == 1 then
      return manager
    end
  end
  
  return { cmd = 'npm', name = 'NPM' } -- 默认使用NPM
end

-- 检测Node.js版本
local function detect_node_version()
  local node_version = vim.fn.system('node --version'):gsub('\n', '')
  if vim.v.shell_error == 0 then
    return node_version
  end
  return 'Not installed'
end

-- ==========================================
-- 实用工具函数
-- ==========================================

-- 运行当前JavaScript/TypeScript文件
local function run_js_file()
  local current_file = vim.fn.expand('%:p')
  local file_ext = vim.fn.expand('%:e')
  local pm = detect_package_manager()
  
  -- 检测是否为TypeScript文件
  local is_typescript = file_ext == 'ts' or file_ext == 'tsx'
  
  -- 检测运行环境
  if vim.fn.filereadable('package.json') == 1 then
    -- 有package.json的项目
    local scripts = vim.fn.system(pm.cmd .. ' run --silent 2>/dev/null')
    
    if scripts:match('dev') then
      -- 如果有dev脚本，使用它
      vim.cmd('terminal ' .. pm.cmd .. ' run dev')
    elseif scripts:match('start') then
      -- 如果有start脚本，使用它
      vim.cmd('terminal ' .. pm.cmd .. ' run start')
    elseif is_typescript then
      -- TypeScript文件需要先编译
      if vim.fn.executable('ts-node') == 1 then
        vim.cmd('terminal ts-node "' .. current_file .. '"')
      else
        vim.notify('ts-node not found. Install it with: ' .. pm.cmd .. ' install -g ts-node', vim.log.levels.WARN)
      end
    else
      -- 直接运行Node.js
      vim.cmd('terminal node "' .. current_file .. '"')
    end
  else
    -- 单文件运行
    if is_typescript then
      if vim.fn.executable('ts-node') == 1 then
        vim.cmd('terminal ts-node "' .. current_file .. '"')
      else
        vim.notify('ts-node not found for TypeScript execution', vim.log.levels.ERROR)
      end
    else
      vim.cmd('terminal node "' .. current_file .. '"')
    end
  end
end

-- 安装项目依赖
local function install_dependencies()
  local pm = detect_package_manager()
  vim.cmd('terminal ' .. pm.cmd .. ' install')
end

-- 运行项目构建
local function build_project()
  local pm = detect_package_manager()
  local build_scripts = { 'build', 'compile', 'webpack', 'vite-build' }
  
  for _, script in ipairs(build_scripts) do
    local scripts = vim.fn.system(pm.cmd .. ' run --silent 2>/dev/null')
    if scripts:match(script) then
      vim.cmd('terminal ' .. pm.cmd .. ' run ' .. script)
      return
    end
  end
  
  vim.notify('No build script found in package.json', vim.log.levels.WARN)
end

-- 运行代码检查（ESLint）
local function lint_code()
  local pm = detect_package_manager()
  
  if vim.fn.filereadable('.eslintrc.js') == 1 or vim.fn.filereadable('.eslintrc.json') == 1 then
    vim.cmd('terminal ' .. pm.cmd .. ' run lint 2>/dev/null || ' .. pm.cmd .. ' run eslint')
  else
    vim.notify('ESLint configuration not found', vim.log.levels.WARN)
  end
end

-- 格式化代码（Prettier）
local function format_code()
  local pm = detect_package_manager()
  
  if vim.fn.filereadable('.prettierrc') == 1 or vim.fn.filereadable('.prettierrc.json') == 1 then
    vim.cmd('terminal ' .. pm.cmd .. ' run format 2>/dev/null || ' .. pm.cmd .. ' run prettier')
  else
    -- 尝试使用Prettier直接格式化
    if vim.fn.executable('prettier') == 1 then
      local current_file = vim.fn.expand('%:p')
      vim.cmd('!prettier --write "' .. current_file .. '"')
    else
      vim.notify('Prettier not found', vim.log.levels.WARN)
    end
  end
end

-- ==========================================
-- 键盘映射配置
-- ==========================================

local opts = { buffer = true, silent = true }

-- 核心开发快捷键
vim.keymap.set('n', '<leader>jr', run_js_file,
  vim.tbl_extend('force', opts, { desc = 'JS/TS: Run File/Project' }))

vim.keymap.set('n', '<leader>ji', install_dependencies,
  vim.tbl_extend('force', opts, { desc = 'JS/TS: Install Dependencies' }))

vim.keymap.set('n', '<leader>jb', build_project,
  vim.tbl_extend('force', opts, { desc = 'JS/TS: Build Project' }))

vim.keymap.set('n', '<leader>jl', lint_code,
  vim.tbl_extend('force', opts, { desc = 'JS/TS: Lint Code' }))

vim.keymap.set('n', '<leader>jf', format_code,
  vim.tbl_extend('force', opts, { desc = 'JS/TS: Format Code' }))

-- 包管理器操作
vim.keymap.set('n', '<leader>jp', function()
  local pm = detect_package_manager()
  vim.notify('Package Manager: ' .. pm.name .. ' (' .. pm.cmd .. ')', vim.log.levels.INFO)
end, vim.tbl_extend('force', opts, { desc = 'JS/TS: Show Package Manager' }))

-- ==========================================
-- 自动命令配置
-- ==========================================

local js_group = vim.api.nvim_create_augroup('JavaScriptSettings', { clear = true })

-- 保存时自动格式化（如果启用）
vim.api.nvim_create_autocmd('BufWritePre', {
  group = js_group,
  pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.mjs', '*.cjs' },
  callback = function()
    if vim.lsp.buf.server_ready() then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.name == 'eslint' or client.name == 'ts_ls' then
          vim.lsp.buf.format({ async = false })
          break
        end
      end
    end
  end,
})

-- 检测项目类型并通知
vim.api.nvim_create_autocmd('BufEnter', {
  group = js_group,
  pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.mjs', '*.cjs' },
  callback = function()
    local project_type = detect_js_project_type()
    local pm = detect_package_manager()
    local node_version = detect_node_version()
    vim.notify(string.format('JS/TS Project: %s, Package Manager: %s, Node: %s', 
      project_type, pm.name, node_version), vim.log.levels.INFO)
  end,
})

-- 自动创建package.json（如果不存在）
vim.api.nvim_create_autocmd('BufEnter', {
  group = js_group,
  pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.mjs', '*.cjs' },
  callback = function()
    if vim.fn.filereadable('package.json') == 0 then
      -- 检查是否是Node.js项目目录
      local cwd = vim.fn.getcwd()
      if cwd:match('nodejs') or cwd:match('node') or cwd:match('js') then
        vim.notify('No package.json found. Consider running: npm init', vim.log.levels.WARN)
      end
    end
  end,
})

-- ==========================================
-- 初始化通知
-- ==========================================

local project_type = detect_js_project_type()
local pm = detect_package_manager()
local node_version = detect_node_version()
vim.notify(string.format('JavaScript/TypeScript LSP配置已加载 - 项目类型: %s, 包管理器: %s, Node版本: %s', 
  project_type, pm.name, node_version), vim.log.levels.INFO)