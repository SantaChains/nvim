# Conform.nvim 路径空格问题修复

## 问题描述
在使用conform.nvim插件时，当Windows用户路径中包含空格（如 `C:\Users\Jliu Pureey`），会出现以下错误：
```
Formatter 'black' error: 'C:\Users\Jliu' 不是内部或外部命令，也不是可运行的程序或批处理文件。
```

## 修复方案

### 1. 主要配置文件修改
- **conform.lua**: 添加了 `get_formatter_path()` 函数来检测Windows系统，并使用 `python -m` 方式调用格式化工具，避免路径中的空格问题
- **coc-settings.json**: 将Python格式化器从 `black` 改为 `ruff`
- **LSP/python.lua**: 更新了格式化逻辑，优先使用LSP格式化，然后回退到conform.nvim，最后才使用外部工具

### 2. 关键修改点

#### conform.lua 中的智能路径处理
```lua
-- 辅助函数：处理Windows路径中的空格
local function get_formatter_path()
  local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
  if is_windows then
    -- Windows系统下使用python -m方式调用，避免路径问题
    return "python"
  else
    return nil  -- Unix系统下使用默认命令
  end
end
```

#### 格式化器配置
```lua
ruff_format = {
  command = get_formatter_path() or "ruff",
  args = get_formatter_path() and { "-m", "ruff", "format", "--stdin-filename", "$FILENAME", "-" } or { "format", "--stdin-filename", "$FILENAME", "-" },
  stdin = true,
},
```

### 3. 使用建议

1. **推荐安装ruff**（性能更好）：
   ```bash
   pip install ruff
   ```

2. **备选方案**：如果ruff不可用，配置会自动回退到LSP格式化或其他可用工具

3. **验证安装**：
   - 打开Python文件
   - 使用 `<leader>F` 进行格式化
   - 或运行 `:ConformInfo` 查看可用格式化器

### 4. 错误处理
配置包含了完善的错误处理机制：
- 当格式化器不可用时提供有用的错误信息
- 自动检测Windows系统并应用相应的路径处理
- 多级回退机制确保格式化功能始终可用

这个修复方案确保了在Windows系统中，即使用户路径包含空格，格式化功能也能正常工作。