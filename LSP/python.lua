-- Python 文件类型特定配置
-- 标准化配置：编辑器设置 + Python开发环境优化
-- 职责：提供Python开发环境的文件类型特定优化
-- 依赖：主LSP配置已在 lsp-config.lua 中统一管理

-- ==========================================
-- 编辑器核心设置
-- ==========================================

-- 缩进和对齐设置（遵循PEP 8标准）
vim.opt_local.tabstop = 4      -- 制表符宽度
vim.opt_local.shiftwidth = 4   -- 自动缩进宽度
vim.opt_local.expandtab = true -- 使用空格代替制表符
vim.opt_local.softtabstop = 4  -- 退格键删除的宽度

-- 智能缩进配置
vim.opt_local.autoindent = true  -- 自动继承上一行缩进
vim.opt_local.smartindent = true -- 智能缩进
vim.opt_local.indentexpr = ''    -- 禁用表达式缩进

-- 代码格式化设置
vim.opt_local.textwidth = 88     -- PEP 8推荐的行长度限制
vim.opt_local.formatoptions:append('cro') -- 自动换行和注释格式

-- ==========================================
-- 语法和显示增强
-- ==========================================

-- 注释格式配置
vim.opt_local.commentstring = '# %s'

-- 代码折叠设置
vim.opt_local.foldmethod = 'indent' -- 基于缩进折叠（适合Python）
vim.opt_local.foldlevel = 99        -- 默认展开所有折叠
vim.opt_local.foldnestmax = 10      -- 最大折叠层数

-- Python语法高亮增强
vim.g.python_highlight_all = 1
vim.g.python_highlight_builtins = 1
vim.g.python_highlight_exceptions = 1
vim.g.python_highlight_string_formatting = 1
vim.g.python_highlight_string_format = 1
vim.g.python_highlight_string_templates = 1
vim.g.python_highlight_indent_errors = 1
vim.g.python_highlight_space_errors = 1
vim.g.python_highlight_doctests = 1
vim.g.python_highlight_func_calls = 1
vim.g.python_highlight_class_vars = 1
vim.g.python_highlight_operators = 1

-- ==========================================
-- Python环境检测
-- ==========================================

-- 检测Python虚拟环境
local function detect_python_env()
  local cwd = vim.fn.getcwd()
  local env_paths = {
    'venv/bin/python',
    'venv/Scripts/python.exe',
    '.venv/bin/python',
    '.venv/Scripts/python.exe',
    'env/bin/python',
    'env/Scripts/python.exe'
  }
  
  for _, path in ipairs(env_paths) do
    local full_path = cwd .. '/' .. path
    if vim.fn.executable(full_path) == 1 then
      return full_path
    end
  end
  
  -- 检测conda环境
  local conda_env = vim.fn.getenv('CONDA_DEFAULT_ENV')
  if conda_env and conda_env ~= '' then
    local conda_python = vim.fn.getenv('CONDA_PREFIX') .. '/bin/python'
    if vim.fn.executable(conda_python) == 1 then
      return conda_python
    end
  end
  
  return 'python'
end

-- 检测项目配置文件
local function detect_project_type()
  local configs = {
    { file = 'pyproject.toml', type = 'Modern Python (PEP 518)' },
    { file = 'setup.py', type = 'Traditional Setup' },
    { file = 'setup.cfg', type = 'Setup Configuration' },
    { file = 'requirements.txt', type = 'Requirements-based' },
    { file = 'Pipfile', type = 'Pipenv' },
    { file = 'poetry.lock', type = 'Poetry' },
    { file = 'environment.yml', type = 'Conda' },
    { file = '.python-version', type = 'pyenv' }
  }
  
  for _, config in ipairs(configs) do
    if vim.fn.filereadable(config.file) == 1 then
      return config.type
    end
  end
  
  return 'Standard Python'
end

-- ==========================================
-- 实用工具函数
-- ==========================================

-- 运行当前Python文件（支持虚拟环境）
local function run_python_file()
  local python_cmd = detect_python_env()
  local current_file = vim.fn.expand('%:p')
  
  -- 检测是否为测试文件
  local is_test = current_file:match('test_.*%.py$') or current_file:match('.*_test%.py$')
  local cmd = python_cmd .. ' "' .. current_file .. '"'
  
  if is_test then
    -- 如果是测试文件，使用pytest运行
    local pytest_cmd = python_cmd:gsub('python$', 'pytest')
    if vim.fn.executable(pytest_cmd) == 1 then
      cmd = pytest_cmd .. ' "' .. current_file .. '" -v'
    end
  end
  
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, '\n'), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Python execution completed successfully', vim.log.levels.INFO)
      else
        vim.notify('Python execution failed with code: ' .. code, vim.log.levels.ERROR)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

-- 运行Python交互式解释器
local function run_python_repl()
  local python_cmd = detect_python_env()
  vim.cmd('terminal ' .. python_cmd)
end

-- 安装项目依赖
local function install_dependencies()
  local cwd = vim.fn.getcwd()
  local python_cmd = detect_python_env()
  
  if vim.fn.filereadable('requirements.txt') == 1 then
    vim.cmd('!' .. python_cmd .. ' -m pip install -r requirements.txt')
  elseif vim.fn.filereadable('pyproject.toml') == 1 then
    -- 检测是否使用poetry
    if vim.fn.executable('poetry') == 1 then
      vim.cmd('!poetry install')
    else
      vim.cmd('!' .. python_cmd .. ' -m pip install -e .')
    end
  elseif vim.fn.filereadable('Pipfile') == 1 then
    if vim.fn.executable('pipenv') == 1 then
      vim.cmd('!pipenv install')
    end
  else
    vim.notify('No dependency file found', vim.log.levels.WARN)
  end
end

-- 格式化Python代码
local function format_python()
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        return client.name == 'ruff' or client.name == 'blackd'
      end
    })
  else
    -- 尝试使用外部格式化工具
    local python_cmd = detect_python_env()
    local formatters = {
      'black',
      'autopep8',
      'yapf'
    }
    
    for _, formatter in ipairs(formatters) do
      local formatter_cmd = python_cmd:gsub('python$', formatter)
      if vim.fn.executable(formatter_cmd) == 1 then
        local current_file = vim.fn.expand('%:p')
        vim.cmd('!' .. formatter_cmd .. ' "' .. current_file .. '"')
        return
      end
    end
    
    vim.notify('No Python formatter available', vim.log.levels.WARN)
  end
end

-- 运行Python测试
local function run_tests()
  local python_cmd = detect_python_env()
  local test_commands = {
    'pytest -v',
    'python -m pytest -v',
    'python -m unittest discover -v'
  }
  
  for _, cmd in ipairs(test_commands) do
    local full_cmd = python_cmd:gsub('python$', cmd:gsub(' ', '.'))
    if vim.fn.executable(full_cmd:gsub(' .*$', '')) == 1 then
      vim.cmd('terminal ' .. cmd)
      return
    end
  end
  
  vim.notify('No test runner found', vim.log.levels.WARN)
end

-- ==========================================
-- 键盘映射配置
-- ==========================================

local opts = { buffer = true, silent = true }

-- 核心开发快捷键
vim.keymap.set('n', '<leader>pr', run_python_file,
  vim.tbl_extend('force', opts, { desc = 'Python: Run File' }))

vim.keymap.set('n', '<leader>pR', run_python_repl,
  vim.tbl_extend('force', opts, { desc = 'Python: Open REPL' }))

vim.keymap.set('n', '<leader>pf', format_python,
  vim.tbl_extend('force', opts, { desc = 'Python: Format' }))

vim.keymap.set('n', '<leader>pi', install_dependencies,
  vim.tbl_extend('force', opts, { desc = 'Python: Install Dependencies' }))

vim.keymap.set('n', '<leader>pt', run_tests,
  vim.tbl_extend('force', opts, { desc = 'Python: Run Tests' }))

-- 虚拟环境管理
vim.keymap.set('n', '<leader>pv', function()
  local env = detect_python_env()
  vim.notify('Python environment: ' .. env, vim.log.levels.INFO)
end, vim.tbl_extend('force', opts, { desc = 'Python: Show Environment' }))

-- ==========================================
-- 自动命令配置
-- ==========================================

local python_group = vim.api.nvim_create_augroup('PythonSettings', { clear = true })

-- 保存时自动格式化（如果启用）
vim.api.nvim_create_autocmd('BufWritePre', {
  group = python_group,
  pattern = '*.py',
  callback = function()
    if vim.lsp.buf.server_ready() then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.name == 'ruff' or client.name == 'pyright' then
          vim.lsp.buf.format({ async = false })
          break
        end
      end
    end
  end,
})

-- 检测项目类型并通知
vim.api.nvim_create_autocmd('BufEnter', {
  group = python_group,
  pattern = '*.py',
  callback = function()
    local project_type = detect_project_type()
    local python_env = detect_python_env()
    vim.notify(string.format('Python project: %s, Environment: %s', project_type, python_env), vim.log.levels.INFO)
  end,
})

-- 自动创建必要的Python目录
vim.api.nvim_create_autocmd('BufEnter', {
  group = python_group,
  pattern = '*.py',
  callback = function()
    local test_dir = 'tests'
    if vim.fn.isdirectory(test_dir) == 0 then
      -- 检查是否需要创建测试目录
      local file_path = vim.fn.expand('%:p')
      if file_path:match('test_.*%.py$') or file_path:match('.*_test%.py$') then
        vim.fn.mkdir(test_dir, 'p')
        vim.notify('Created tests directory', vim.log.levels.INFO)
      end
    end
  end,
})

-- ==========================================
-- 初始化通知
-- ==========================================

local project_type = detect_project_type()
local python_env = detect_python_env()
vim.notify(string.format('Python LSP配置已加载 - 项目类型: %s', project_type), vim.log.levels.INFO)
