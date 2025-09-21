-- C++ 文件类型特定配置
-- 标准化配置：编辑器设置 + LSP增强 + 开发工具集成
-- 职责：提供C/C++开发环境的文件类型特定优化
-- 依赖：主LSP配置已在 lsp-config.lua 中统一管理

-- ==========================================
-- 编辑器核心设置
-- ==========================================

-- 缩进和对齐设置（遵循现代C++标准）
vim.opt_local.tabstop = 2      -- 制表符宽度
vim.opt_local.shiftwidth = 2   -- 自动缩进宽度
vim.opt_local.expandtab = true -- 使用空格代替制表符
vim.opt_local.softtabstop = 2  -- 退格键删除的宽度

-- 智能缩进配置
vim.opt_local.autoindent = true  -- 自动继承上一行缩进
vim.opt_local.smartindent = true -- 智能缩进（识别代码结构）
vim.opt_local.cindent = true     -- C语言风格缩进
vim.opt_local.indentexpr = ''    -- 禁用表达式缩进，使用cindent

-- 代码格式化设置
vim.opt_local.textwidth = 100    -- 自动换行宽度（现代C++标准）
vim.opt_local.formatoptions:append('cro') -- 自动换行和注释格式

-- ==========================================
-- 语法和显示增强
-- ==========================================

-- 注释格式配置
vim.opt_local.commentstring = '// %s'

-- 代码折叠设置
vim.opt_local.foldmethod = 'syntax' -- 基于语法折叠
vim.opt_local.foldlevel = 99        -- 默认展开所有折叠
vim.opt_local.foldnestmax = 10      -- 最大折叠层数

-- 括号匹配增强
vim.opt_local.matchpairs:append('<:>') -- 添加模板括号匹配
vim.opt_local.showmatch = true        -- 显示匹配括号

-- 语法高亮增强（需要vim-cpp-modern插件支持）
vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_member_variable_highlight = 1
vim.g.cpp_class_decl_highlight = 1
vim.g.cpp_concepts_highlight = 1      -- C++20概念高亮
vim.g.cpp_template_highlight = 1      -- 模板高亮

-- ==========================================
-- 编译和构建集成
-- ==========================================

-- 自动检测编译数据库
local function find_compile_commands()
  local cwd = vim.fn.getcwd()
  local patterns = {
    'compile_commands.json',
    'build/compile_commands.json',
    'out/compile_commands.json',
    '.cache/compile_commands.json'
  }
  
  for _, pattern in ipairs(patterns) do
    local path = cwd .. '/' .. pattern
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
  return nil
end

-- 获取项目构建目录
local function get_build_dir()
  local build_dirs = { 'build', 'out', 'cmake-build-*' }
  for _, dir in ipairs(build_dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      return dir
    end
  end
  return 'build'
end

-- ==========================================
-- 实用工具函数
-- ==========================================

-- 切换头文件和源文件（增强版）
local function switch_header_source()
  local file_ext = vim.fn.expand('%:e')
  local base_name = vim.fn.expand('%:r')
  
  -- 定义可能的文件扩展名映射
  local header_exts = { 'h', 'hpp', 'hh', 'hxx', 'h++' }
  local source_exts = { 'cpp', 'cc', 'cxx', 'c++', 'c' }
  
  local target_file = nil
  
  if vim.tbl_contains(source_exts, file_ext) then
    -- 从源文件到头文件
    for _, h_ext in ipairs(header_exts) do
      local header_file = base_name .. '.' .. h_ext
      if vim.fn.filereadable(header_file) == 1 then
        target_file = header_file
        break
      end
    end
    
    -- 如果没有找到同名头文件，尝试常见的头文件名
    if not target_file then
      for _, h_ext in ipairs(header_exts) do
        local header_file = base_name .. '.' .. h_ext
        -- 创建头文件
        vim.ui.input({
          prompt = 'Create header file: ',
          default = header_file,
          completion = 'file'
        }, function(input)
          if input and input ~= '' then
            vim.cmd('edit ' .. input)
          end
        end)
        return
      end
    end
  elseif vim.tbl_contains(header_exts, file_ext) then
    -- 从头文件到源文件
    for _, s_ext in ipairs(source_exts) do
      local source_file = base_name .. '.' .. s_ext
      if vim.fn.filereadable(source_file) == 1 then
        target_file = source_file
        break
      end
    end
  end
  
  if target_file then
    vim.cmd('edit ' .. target_file)
  else
    vim.notify('No corresponding file found', vim.log.levels.WARN)
  end
end

-- 智能编译当前文件或项目
local function compile_cpp()
  local file = vim.fn.expand('%:p')
  local file_dir = vim.fn.expand('%:p:h')
  local file_name = vim.fn.expand('%:t:r')
  
  -- 检测是否有CMake项目
  if vim.fn.filereadable('CMakeLists.txt') == 1 then
    local build_dir = get_build_dir()
    vim.cmd('!cmake --build ' .. build_dir)
  else
    -- 单文件编译（支持C++20标准）
    local output = file_dir .. '/' .. file_name .. '.exe'
    local cmd = string.format('g++ -std=c++20 -Wall -Wextra -O2 -o "%s" "%s"', output, file)
    
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
          vim.notify('Compilation successful: ' .. output, vim.log.levels.INFO)
        else
          vim.notify('Compilation failed with code: ' .. code, vim.log.levels.ERROR)
        end
      end,
      stdout_buffered = true,
      stderr_buffered = true,
    })
  end
end

-- 运行编译后的程序
local function run_executable()
  local file_dir = vim.fn.expand('%:p:h')
  local file_name = vim.fn.expand('%:t:r')
  local exe_path = file_dir .. '/' .. file_name .. '.exe'
  
  if vim.fn.filereadable(exe_path) == 1 then
    vim.cmd('terminal "' .. exe_path .. '"')
  else
    vim.notify('Executable not found: ' .. exe_path, vim.log.levels.ERROR)
  end
end

-- ==========================================
-- 键盘映射配置
-- ==========================================

local opts = { buffer = true, silent = true }

-- 核心开发快捷键
vim.keymap.set('n', '<leader>ch', switch_header_source, 
  vim.tbl_extend('force', opts, { desc = 'C++: Switch Header/Source' }))

vim.keymap.set('n', '<leader>cb', compile_cpp,
  vim.tbl_extend('force', opts, { desc = 'C++: Compile' }))

vim.keymap.set('n', '<leader>cr', run_executable,
  vim.tbl_extend('force', opts, { desc = 'C++: Run Executable' }))

-- 调试相关快捷键
vim.keymap.set('n', '<leader>cd', function()
  require('dap').continue()
end, vim.tbl_extend('force', opts, { desc = 'C++: Debug' }))

vim.keymap.set('n', '<leader>cb', function()
  require('dap').toggle_breakpoint()
end, vim.tbl_extend('force', opts, { desc = 'C++: Toggle Breakpoint' }))

-- ==========================================
-- 自动命令配置
-- ==========================================

local cpp_group = vim.api.nvim_create_augroup('CppSettings', { clear = true })

-- 保存时自动格式化（如果启用）
vim.api.nvim_create_autocmd('BufWritePre', {
  group = cpp_group,
  pattern = { '*.cpp', '*.hpp', '*.cc', '*.hh', '*.cxx', '*.hxx' },
  callback = function()
    if vim.lsp.buf.server_ready() then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- 自动检测编译数据库并通知LSP
vim.api.nvim_create_autocmd('BufEnter', {
  group = cpp_group,
  pattern = { '*.cpp', '*.hpp', '*.cc', '*.hh', '*.cxx', '*.hxx' },
  callback = function()
    local compile_commands = find_compile_commands()
    if compile_commands then
      vim.notify('Found compile_commands.json: ' .. compile_commands, vim.log.levels.INFO)
    end
  end,
})

-- ==========================================
-- 初始化通知
-- ==========================================

vim.notify('C++ LSP配置已加载', vim.log.levels.INFO)
