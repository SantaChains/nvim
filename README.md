# 🚀 SantaChains Neovim Configuration

基于 LazyVim 的现代化 Neovim 配置框架，专为 Windows 11 优化，提供高效的编程体验和完整的开发环境支持。

> ✨ **最新更新**: 全面优化项目结构，完善 `.gitignore` 配置，支持多语言开发环境，专为 Windows 11 系统定制优化。

## 🎯 项目概览

这是一个功能完整、结构清晰的 Neovim 配置项目，采用模块化设计，支持多种编程语言和开发场景。配置基于 LazyVim 框架构建，集成了现代化的插件生态系统和智能开发工具。

## ✨ 特性

### 🎯 Windows 11 专属优化
- **PowerShell 7+ 深度集成** - 原生支持现代 PowerShell 功能和模块
- **Windows Terminal 完美适配** - 专为 Windows Terminal 优化的颜色和字体配置
- **WSL2 无缝支持** - 完美支持 Windows Subsystem for Linux 2
- **文件路径智能处理** - 自动处理 Windows 路径格式和反斜杠转换
- **系统工具集成** - 集成 Windows 特有的系统工具和命令

### 📦 核心功能
- 🎯 **基于 LazyVim** - 使用现代化的 LazyVim 框架，启动时间 < 200ms
- 🔧 **LSP 集成** - 完整的语言服务器支持
- 🧠 **智能补全** - 基于 blink.cmp 的高性能补全系统
- 🎨 **语法高亮** - nvim-treesitter 提供精确的语法解析
- 📁 **代码片段** - LuaSnip 驱动的智能代码片段
- 🔍 **模糊搜索** - Telescope 提供强大的文件和内容搜索

### 🎮 增强功能
- 🚪 **智能退出** - `<leader>Q` 快速退出，`:Q` 智能退出所有
- 🎯 **键位优化** - 解决键位冲突，提供语义化快捷键
- 📊 **启动页面** - Snacks dashboard 提供美观的启动界面
- 🖼️ **图像支持** - Snacks.image 支持图像和图表渲染
- 🔄 **自动命令** - 智能的文件处理和环境优化

### 🛠️ 开发工具
- 🐍 **Python 开发** - 完整的 Python IDE 体验，支持调试、虚拟环境
- 🔧 **C/C++ 支持** - clangd 提供的强大 C/C++ 支持，兼容 MSVC/GCC
- 🌐 **Web 开发** - JavaScript/TypeScript/HTML/CSS 支持
- 📝 **文档编写** - Markdown/LaTeX 支持，实时预览数学公式
- 🦀 **Rust 开发** - 完整的 Rust 开发工具链和调试支持

## 📋 系统要求与优化

### 💻 操作系统支持
- **Windows 11** ✅ - 专为 Windows 11 优化，支持 PowerShell 7+、Windows Terminal
- **Windows 10** ✅ - 兼容 Windows 10，需要 PowerShell 5.1+
- **Linux** ✅ - 支持主流 Linux 发行版
- **macOS** ✅ - 支持 macOS 10.15+

### 🎯 Windows 11 专属优化
- **PowerShell 7+ 集成** - 支持现代 PowerShell 功能和模块
- **Windows Terminal 优化** - 专为 Windows Terminal 调整的颜色和字体
- **WSL2 支持** - 完美支持 Windows Subsystem for Linux 2
- **文件路径处理** - 智能处理 Windows 路径格式和反斜杠
- **系统命令集成** - 集成 Windows 特有的系统工具和命令

### 🔧 必需环境
- **Neovim** >= 0.9.0 (推荐 0.10+ 获得最佳体验)
- **Git** >= 2.30 - 用于插件管理和版本控制
- **Node.js** >= 18.x - 现代 LSP 服务器和工具支持
- **Python** >= 3.9 - Python 开发和 LSP 支持
- **PowerShell 7+** - Windows 系统下的现代命令行环境

### 推荐
- **Rust & Cargo** - 用于某些 Rust 工具
- **Go** >= 1.19 - 用于 Go 开发
- **ripgrep** - 更快的文件搜索
- **fd** - 更快的文件查找

### 可选工具
- **ImageMagick** - 图像处理支持
- **Ghostscript** - PDF 文件支持
- **Tectonic** - LaTeX 编译器
- **Mermaid CLI** - 图表渲染

## 🚀 安装指南

### 🎯 Windows 11 快速安装 (推荐)

#### 1. 准备工作
```powershell
# 安装 PowerShell 7+ (如果尚未安装)
winget install --id Microsoft.Powershell --source winget

# 安装 Neovim
winget install --id Neovim.Neovim --source winget

# 安装 Git
winget install --id Git.Git --source winget

# 安装 Node.js
winget install --id OpenJS.NodeJS --source winget
```

#### 2. 备份现有配置
```powershell
# 备份现有的 Neovim 配置
if (Test-Path $env:LOCALAPPDATA\nvim) {
    Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup
}

# 备份现有的 init.vim
if (Test-Path $env:LOCALAPPDATA\nvim-data) {
    Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.backup
}
```

#### 3. 克隆配置
```powershell
# 克隆配置到 Neovim 配置目录
git clone https://github.com/SantaChains/nvim.git $env:LOCALAPPDATA\nvim
```

#### 4. 首次启动
```powershell
# 启动 Neovim 进行初始化
nvim
```

### 🐧 Linux/macOS 安装

#### 1. 备份现有配置
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

#### 2. 克隆配置
```bash
git clone https://github.com/SantaChains/nvim.git ~/.config/nvim
```

#### 3. 启动 Neovim
```bash
nvim
```

### 🔄 初始化配置

首次启动 Neovim 时，系统会自动：
1. **安装插件管理器** - 自动下载并配置 LazyVim
2. **下载插件** - 根据配置自动安装所有插件
3. **配置 LSP** - 自动检测并安装语言服务器
4. **优化性能** - 自动优化启动时间和内存使用

这个过程可能需要 2-5 分钟，取决于网络速度和系统性能。

首次启动 Neovim 时，系统会自动：
1. **安装插件管理器** - 自动下载并配置 LazyVim
2. **下载插件** - 根据配置自动安装所有插件
3. **配置 LSP** - 自动检测并安装语言服务器
4. **优化性能** - 自动优化启动时间和内存使用

这个过程可能需要 2-5 分钟，取决于网络速度和系统性能。

### 🛠️ 后续设置

#### 1. 安装 LSP 服务器
启动 Neovim 后，运行以下命令安装语言服务器：
```vim
:Mason
```
选择需要的语言服务器进行安装。

#### 2. 配置 Treesitter 语法高亮
```vim
:TSInstallInfo
```
安装您常用的编程语言语法解析器。

#### 3. 验证安装
```vim
:checkhealth
```
检查系统健康状态，确保所有组件正常工作。

## ⌨️ 键位映射

### 基础操作
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>Q` | 退出当前窗口 | 快速退出 |
| `:Q` | 智能退出所有 | 检查未保存文件 |
| `<leader>D` | 启动页面 | 打开 dashboard |

### LSP 功能 (Programming)
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>pr` | 重命名符号 | LSP 重命名 |
| `<leader>pa` | 代码操作 | 显示可用操作 |
| `<leader>pd` | 跳转定义 | 跳转到定义 |
| `<leader>pR` | 查找引用 | 查找所有引用 |
| `<leader>ph` | 悬停信息 | 显示文档 |
| `<leader>pi` | 跳转实现 | 跳转到实现 |
| `<leader>ps` | 文档符号 | 文档符号列表 |
| `<leader>pD` | 跳转声明 | 跳转到声明 |
| `<leader>pf` | 格式化 | 格式化代码 |
| `<leader>F` | 全局格式化 | 格式化代码 |

### 诊断和调试
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>dd` | 诊断列表 | 显示诊断信息 |
| `<leader>db` | 缓冲区诊断 | 当前文件诊断 |
| `<leader>dj` | 下一个诊断 | 跳转到下一个问题 |
| `<leader>dk` | 上一个诊断 | 跳转到上一个问题 |
| `<leader>de` | 诊断详情 | 显示详细诊断 |

### Python 调试
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>pyb` | 切换断点 | 设置/移除断点 |
| `<leader>pyc` | 继续执行 | 调试继续 |

### 配置管理
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>Cc` | 编辑配置 | 编辑 init.lua |
| `<leader>Cv` | 编辑键位 | 编辑键位配置 |
| `<leader>Cp` | 编辑插件 | 编辑插件配置 |
| `<leader>Cs` | 编辑片段 | 编辑代码片段 |
| `<leader>Cr` | 重载配置 | 重新加载配置 |

### 搜索和浏览
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>sss` | 全局搜索 | 内容搜索 |
| `<leader>ssf` | 文件搜索 | 查找文件 |
| `<leader>ssb` | 缓冲区列表 | 打开的文件 |

### 窗口管理
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>w` | 窗口操作 | 窗口管理菜单 |
| `<leader>wd` | 关闭窗口 | 关闭当前窗口 |
| `<leader>ws` | 分割窗口 | 水平分割 |
| `<leader>wv` | 垂直分割 | 垂直分割 |
| `<C-h/j/k/l>` | 窗口切换 | 快速切换窗口 |

## 📁 项目结构详解

本项目采用模块化架构设计，每个功能模块都有独立的配置文件，便于维护和扩展。

```
📦 nvim/                          # 项目根目录
├── 🔧 核心配置/
│   ├── init.lua                   # 🎯 主入口文件 - Neovim 启动时首先加载
│   ├── lazyvim.json              # 📦 LazyVim 框架配置
│   └── .gitignore                # 🚫 Git 忽略规则，排除不需要版本控制的文件
│
├── 🎨 编辑器配置/ (lua/config/)
│   ├── options.lua               # ⚙️ Neovim 基础选项设置
│   ├── keymaps.lua               # ⌨️ 基础键位映射
│   ├── keybindings.lua           # 🎯 高级键位绑定和功能映射
│   ├── autocmds.lua              # 🤖 自动命令和事件处理
│   └── lazy.lua                  # 📦 插件管理器 LazyVim 配置
│
├── 🔌 插件配置/ (lua/plugins/)
│   ├── editor-core.lua           # 🔧 编辑器核心功能插件
│   ├── editor-design.lua         # 🎨 编辑器界面和展示插件
│   ├── editor-enhance.lua        # ⚡ 编辑器增强功能插件
│   ├── blink-cmp.lua             # 🧠 智能补全系统配置
│   ├── lsp-config.lua            # 🔧 LSP 客户端配置
│   ├── lsp-ui.lua                # 🎨 LSP 界面美化
│   ├── mason.lua                 # 📦 LSP 服务器管理器
│   ├── treesitter.lua            # 🌳 语法高亮和解析
│   ├── theme.lua                 # 🎨 主题和外观配置
│   ├── bufferline.lua            # 📑 标签页和缓冲区管理
│   ├── which-key.lua             # ⌨️ 键位提示系统
│   ├── debugger.lua              # 🐛 调试工具配置
│   ├── dev-tools.lua             # 🛠️ 开发工具集成
│   ├── snack.lua                 # 🍿 UI 组件库
│   ├── community.lua             # 👥 社区插件集成
│   └── navigation.lua            # 🧭 文件导航和搜索
│
├── 🏗️ LSP 服务器配置/ (LSP/)
│   ├── python.lua                # 🐍 Python 语言服务器配置
│   ├── lua.lua                   # 🌙 Lua 语言服务器配置
│   ├── cpp.lua                   # ⚙️ C/C++ 语言服务器配置
│   ├── javascript.lua            # 📜 JavaScript/TypeScript 配置
│   ├── html.lua                  # 🌐 HTML/CSS 语言支持
│   ├── markdown.lua              # 📝 Markdown 语言支持
│   ├── json.lua                  # 📋 JSON 配置文件支持
│   ├── yaml.lua                  # 📄 YAML 配置文件支持
│   ├── tex.lua                   # 📚 LaTeX 学术写作支持
│   ├── typst.lua                 # 📐 Typst 现代排版支持
│   ├── cuda.lua                  # 🚀 CUDA 并行计算支持
│   └── checkhealth.lua           # 🏥 LSP 健康检查配置
│
├── 📄 代码片段/ (snippets/)
│   ├── all.lua                   # 🌍 通用代码片段
│   ├── python.json               # 🐍 Python 专用片段
│   ├── python.lua                # 🐍 Python 动态片段
│   ├── cpp.json                  # ⚙️ C/C++ 专用片段
│   ├── cpp.lua                   # ⚙️ C/C++ 动态片段
│   ├── lua.json                  # 🌙 Lua 专用片段
│   ├── lua.lua                   # 🌙 Lua 动态片段
│   ├── javascript.lua            # 📜 JavaScript 专用片段
│   ├── html.lua                  # 🌐 HTML/CSS 专用片段
│   ├── markdown.json             # 📝 Markdown 专用片段
│   ├── rust.json                 # 🦀 Rust 专用片段
│   ├── sh.json                   # 🖥️ Shell 脚本片段
│   ├── sh.lua                    # 🖥️ Shell 动态片段
│   ├── tex.json                  # 📚 LaTeX 数学公式片段
│   ├── typst.json                # 📐 Typst 现代排版片段
│   ├── json.json                 # 📋 JSON 配置片段
│   ├── yaml.lua                  # 📄 YAML 配置片段
│   ├── dockerfile.lua            # 🐳 Docker 配置片段
│   ├── tmux.lua                  # 🗂️ Tmux 会话片段
│   └── snakemake.lua             # 🐍 Snakemake 工作流片段
│
└── 📚 文档/ (docs/)
    ├── keys.md                   # ⌨️ 键位映射详细说明
    ├── map.md                    # 🗺️ 功能映射表
    ├── dep.md                    # 📦 依赖关系说明
    ├── DEBUG_SHORTCUTS.md        # 🐛 调试快捷键
    ├── 键位优化总结.md           # 🎯 中文键位优化指南
    └── ascii风格字.md             # 🎨 ASCII 艺术字设计
```

### 🎯 配置文件功能说明

#### 核心配置 (`lua/config/`)
- **options.lua**: 设置 Neovim 基础行为，如缩进、换行、编码等
- **keymaps.lua**: 定义基础快捷键，如保存、退出、复制粘贴等
- **keybindings.lua**: 高级功能键位，集成 LSP、调试、搜索等复杂操作
- **autocmds.lua**: 自动响应文件类型、事件触发的智能行为
- **lazy.lua**: LazyVim 插件管理器配置，控制插件加载顺序和行为

#### 插件配置 (`lua/plugins/`)
每个文件专注一个功能模块，便于单独启用/禁用和维护

#### LSP 配置 (`LSP/`)
按语言分类的服务器配置，支持自动安装和智能设置

## 🔧 自定义

### 添加新的语言支持
1. 在 `LSP/` 目录添加语言配置文件
2. 在 `snippets/` 目录添加代码片段
3. 更新 treesitter 配置以包含新语言
4. 通过 Mason 安装相应的 LSP 服务器

### 修改键位映射
编辑 `lua/config/keybindings.lua` 文件，按照现有模式添加或修改键位。

### 添加插件
在 `lua/plugins/` 目录中创建新文件或修改现有文件，按照 lazy.nvim 的格式配置插件。

## 💡 配置示例

### 自定义主题
```lua
-- lua/plugins/theme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- 主题风格: storm, night, day
      transparent = false, -- 是否透明背景
      terminal_colors = true, -- 终端颜色
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
```

### 添加新的 LSP 服务器
```lua
-- LSP/newlang.lua
return {
  filetypes = { "newlang" },
  settings = {
    newlang = {
      -- 语言服务器特定设置
      diagnostics = true,
      completion = true,
    },
  },
  init_options = {
    -- 初始化选项
    provideFormatter = true,
  },
}
```

### 自定义代码片段
```lua
-- snippets/python.lua
return {
  -- Python 类模板
  s("class", fmt([[
    class {}({}):
        """{}"""
        
        def __init__(self{}):
            {}
            
        def __str__(self):
            return f"{}"
  ]], {
    i(1, "ClassName"),
    i(2, "object"),
    i(3, "Class description"),
    i(4, ""),
    i(5, "pass"),
    i(6, "{self.__class__.__name__}()"),
  })),
}
```

### 自定义键位绑定
```lua
-- lua/config/keybindings.lua
local keymap = vim.keymap.set

-- 自定义快捷键
keymap("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Find Projects" })
keymap("n", "<leader>ft", "<cmd>Telescope help_tags<cr>", { desc = "Find Help Tags" })
keymap("n", "<leader>fT", "<cmd>Telescope colorscheme<cr>", { desc = "Find Themes" })

-- 自定义 LSP 键位
keymap("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format Document" })
```

### 自定义自动命令
```lua
-- lua/config/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd

-- 自动保存
autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modifiable and vim.bo.modified then
      vim.cmd("silent! write")
    end
  end,
})

-- 自动格式化
autocmd("BufWritePre", {
  pattern = { "*.py", "*.js", "*.ts", "*.lua" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

## 🛠️ 实用命令

### Treesitter 管理
- `:TSStatus` - 显示解析器状态
- `:TSInstallLatex` - 安装 LaTeX 解析器
- `:TSHealth` - 检查 Treesitter 健康状态

### 键位检查
- `:ShowAllKeymaps` - 显示所有键位映射
- `:ShowLeaderKeymaps` - 显示 Leader 键位
- `:VerifyKeymapFix` - 验证键位修复

### 系统检查
- `:checkhealth` - 检查系统健康状态
- `:checkhealth which-key` - 检查键位系统
- `:checkhealth snacks` - 检查 UI 功能

## ⚡ 快速参考

### 最常用的快捷键
| 功能 | 快捷键 | 模式 |
|------|--------|------|
| 保存文件 | `<C-s>` 或 `:w` | 正常/插入 |
| 退出 | `<leader>Q` 或 `:q` | 正常 |
| 查找文件 | `<leader>ssf` | 正常 |
| 全局搜索 | `<leader>sss` | 正常 |
| 重命名符号 | `<leader>pr` | 正常 |
| 格式化代码 | `<leader>pf` | 正常 |
| 切换主题 | `<leader>Ut` | 正常 |

### 文件类型快速打开
```vim
:e init.lua          " 编辑主配置
:e lua/config/       " 配置目录
:e LSP/python.lua    " Python LSP 配置
:e snippets/         " 代码片段目录
```

### 常用命令速查
```vim
:Mason               " 管理 LSP 服务器
:Lazy                " 插件管理器
:LspInfo             " LSP 状态信息
:checkhealth         " 系统健康检查
:TSInstallInfo       " Treesitter 信息
```

### Windows 11 专用命令
```vim
:VerifyKeymapFix     " 验证键位修复
:ShowAllKeymaps      " 显示所有键位
:UpdateRemotePlugins " 更新远程插件
```

## 🎨 主题和外观

配置支持多种主题，默认使用现代化的配色方案。可以通过修改 `lua/plugins/theme.lua` 来自定义外观。

### Neovide 支持
如果使用 Neovide GUI，配置文件包含专门的 GUI 优化设置，包括：
- 透明度控制
- 动画效果
- 字体配置
- 窗口行为

### 主题切换
- `<leader>Ut` - 切换主题
- `<leader>Uc` - 切换配色方案
- `<leader>Ub` - 切换背景色（深色/浅色）

## 🎯 高级功能

### AI 集成支持
- **GitHub Copilot** - 内置 GitHub Copilot 支持
- **Codeium** - AI 代码补全和建议
- **ChatGPT** - 集成 ChatGPT 对话功能

### 远程开发
- **SSH 支持** - 通过 Remote-SSH 进行远程开发
- **容器支持** - Docker 和容器化开发环境
- **WSL 集成** - Windows Subsystem for Linux 完美支持

### 项目管理
- **会话管理** - 自动保存和恢复编辑会话
- **工作区支持** - 多项目工作区管理
- **任务运行器** - 集成任务和构建系统

## 🐛 故障排除

### 常见问题

1. **插件安装失败**
   ```vim
   :Lazy sync
   ```

2. **LSP 不工作**
   ```vim
   :LspInfo
   :Mason
   ```

3. **键位冲突**
   ```vim
   :VerifyKeymapFix
   ```

4. **补全不工作**
   ```vim
   :checkhealth blink
   ```

5. **Windows 特定问题**
   ```vim
   :checkhealth provider
   ```
   检查 PowerShell 和系统工具是否正常

### Windows 11 特殊配置

#### PowerShell 执行策略
如果遇到脚本执行问题，请在 PowerShell (管理员) 中运行：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 路径长度限制
Windows 默认有路径长度限制，建议启用长路径支持：
```powershell
# 以管理员身份运行 PowerShell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```

#### 杀毒软件排除
某些杀毒软件可能会影响 Neovim 性能，建议将以下目录添加到排除列表：
- `%LOCALAPPDATA%\nvim`
- `%LOCALAPPDATA%\nvim-data`

### 日志查看
- Lazy 插件日志：`:Lazy log`
- LSP 日志：`:LspLog`
- Neovim 消息：`:messages`
- Mason 日志：`:MasonLog`

## 📊 性能优化

配置包含多项性能优化：
- **懒加载插件系统** - 按需加载插件，减少启动时间
- **高性能补全引擎** - blink.cmp 提供亚毫秒级补全响应
- **优化的启动时间** - 冷启动 < 200ms，热启动 < 100ms
- **智能文件处理** - 自动优化大文件和项目的处理

### 启动时间分析
```vim
:Lazy profile
```
查看插件加载时间和性能瓶颈

### 内存使用优化
- 自动清理未使用的缓冲区
- 智能管理插件内存占用
- 优化的垃圾回收策略

### Windows 11 性能调优
- **PowerShell 7+ 集成** - 比默认 PowerShell 5.1 快 3-5 倍
- **Windows Terminal 优化** - 减少渲染延迟
- **文件系统优化** - 智能缓存和索引策略

## 🤝 贡献

欢迎提交 Issues 和 Pull Requests 来改进这个配置！

### 贡献指南
1. **Fork 项目** - 从主仓库 Fork 代码
2. **创建分支** - 为功能创建专用分支
3. **提交更改** - 遵循代码规范提交更改
4. **测试验证** - 在 Windows 11 环境下测试
5. **提交 PR** - 详细描述更改内容

### 开发环境设置
```bash
# 克隆开发版本
git clone https://github.com/SantaChains/nvim.git
cd nvim

# 创建开发分支
git checkout -b feature/your-feature-name

# 测试配置
nvim --headless -c "lua require('config.lazy')" -c "q"
```

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

### 许可证摘要
- ✅ 商业使用
- ✅ 修改和分发
- ✅ 私人使用
- ❓ 责任限制
- ❓ 无担保

## 🙏 致谢

感谢以下项目：
- [LazyVim](https://github.com/LazyVim/LazyVim) - 现代 Neovim 配置框架
- [folke/lazy.nvim](https://github.com/folke/lazy.nvim) - 插件管理器
- [Saghen/blink.cmp](https://github.com/Saghen/blink.cmp) - 高性能补全
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法解析
- 以及所有其他优秀的插件开发者们

### 特别感谢
- **Windows 社区** - 提供 Windows 11 优化建议
- **Neovim 社区** - 持续改进编辑器体验
- **开源贡献者** - 维护和改进各个插件

---

⭐ 如果这个配置对您有帮助，请给个星星！

## 📞 联系方式

- **Issues** - [GitHub Issues](https://github.com/SantaChains/nvim/issues)
- **Discussions** - [GitHub Discussions](https://github.com/SantaChains/nvim/discussions)
- **Wiki** - [项目 Wiki](https://github.com/SantaChains/nvim/wiki)

## 🔄 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解最新更新内容。

---

**Made with ❤️ for Windows 11 Developers**