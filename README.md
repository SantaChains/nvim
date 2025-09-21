# Neovim 配置 - Full 分支

这是一个功能完整的 Neovim 配置，基于 LazyVim 构建，专为 Windows 11 系统优化。

## 🌟 主要特性

### 核心功能
- **现代化界面** - 美观的主题和状态栏
- **智能代码补全** - 基于 LSP 的自动补全
- **多语言支持** - 支持 15+ 种编程语言
- **文件管理** - 直观的文件树和缓冲区管理
- **终端集成** - 内置终端支持

### AI 增强功能 (Full 分支特有)
- **智能代码补全** - AI 驱动的代码建议
- **代码解释和重构** - 基于 AI 的代码分析
- **智能问答** - 集成 AI 助手
- **自动提交信息生成** - AI 生成的 Git 提交信息

### 高级功能
- **调试支持** - 完整的调试器集成
- **测试运行器** - 自动化测试执行
- **代码格式化** - 多语言代码格式化
- **语法检查** - 实时代码质量检查

## 🚀 快速开始

### 系统要求
- Windows 11
- Neovim 0.9+
- Git
- Node.js (可选，用于某些插件)

### 安装步骤

1. **备份现有配置**
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. **克隆配置**
```bash
git clone <repository-url> ~/.config/nvim
```

3. **启动 Neovim**
```bash
nvim
```

LazyVim 会自动安装所有插件。

## ⌨️ 键位映射

### 基础操作
| 快捷键 | 功能 | 模式 |
|--------|------|------|
| `jk` | 退出插入模式 | 插入 |
| `<C-s>` | 保存文件 | 全部 |
| `<C-z>` | 撤销 | 全部 |
| `<C-c>` | 复制到系统剪贴板 | 全部 |
| `<C-v>` | 从系统剪贴板粘贴 | 全部 |

### 终端模式
| 快捷键 | 功能 |
|--------|------|
| `<Esc>` | 退出终端模式 |
| `<leader>tt` | 打开终端横向分割 |

### 窗口管理
| 快捷键 | 功能 |
|--------|------|
| `<C-方向键>` | 窗口间移动 |
| `<A-方向键>` | 调整窗口大小 |
| `<leader>sv` | 垂直分割窗口 |
| `<leader>sh` | 水平分割窗口 |

### 缓冲区管理
| 快捷键 | 功能 |
|--------|------|
| `<A-l>` | 下一个缓冲区 |
| `<A-h>` | 上一个缓冲区 |
| `<A-w>` | 关闭当前缓冲区 |

### LSP 功能
| 快捷键 | 功能 |
|--------|------|
| `gD` | 跳转到声明 |
| `gd` | 查看定义 |
| `gi` | 跳转到实现 |
| `gr` | 查找引用 |
| `<space>rn` | 重命名符号 |
| `<leader>F` | 格式化代码 |
| `<leader>ca` | 代码操作 |

## 🛠️ 插件配置

### 补全系统
- **blink-cmp** - 高性能补全引擎
- **LSP 支持** - 智能代码分析
- **Snippets** - 代码片段支持

### 文件管理
- **Snacks** - 现代化文件管理器
- **Bufferline** - 缓冲区标签页
- **Telescope** - 模糊查找器

### 编辑增强
- **Which-key** - 快捷键提示
- **Comment** - 智能注释
- **Surround** - 包围字符操作
- **Auto-pairs** - 自动括号匹配

### AI 功能 (Full 分支)
- **Avante** - AI 代码助手
- **CodeCompanion** - AI 编程伙伴
- **Copilot** - GitHub Copilot 集成

### 主题和界面
- **Tokyo Night** - 深色主题
- **Lualine** - 状态栏
- **Bufferline** - 标签页美化
- **Dashboard** - 启动界面

## 📁 目录结构

```
nvim/
├── init.lua                 # 主入口文件
├── lazyvim.json            # LazyVim 配置
├── lua/
│   ├── config/             # 核心配置
│   │   ├── autocmds.lua    # 自动命令
│   │   ├── keymaps.lua     # 键位映射
│   │   ├── keybindings.lua # 额外键位
│   │   ├── lazy.lua        # LazyVim 配置
│   │   └── options.lua     # 编辑器选项
│   ├── core/               # 核心功能
│   │   ├── colorscheme.lua # 主题配置
│   │   ├── plugins-setup.lua # 插件设置
│   │   └── templates.lua   # 模板配置
│   └── plugins/            # 插件配置
│       ├── blink-cmp.lua   # 补全配置
│       ├── lsp-config.lua  # LSP 配置
│       ├── ai.lua#         # AI 插件配置
│       ├── debugger.lua    # 调试器配置
│       └── theme.lua       # 主题配置
├── LSP/                    # LSP 服务器配置
│   ├── python.lua
│   ├── javascript.lua
│   └── ...
└── snippets/               # 代码片段
    ├── python.lua
    ├── javascript.lua
    └── ...
```

## 🔧 自定义配置

### 添加新的 LSP 服务器
1. 在 `LSP/` 目录下创建新的配置文件
2. 按照现有模板的格式进行配置
3. 重启 Neovim 或运行 `:Mason` 安装服务器

### 修改主题
编辑 `lua/core/colorscheme.lua` 文件，修改主题配置。

### 添加自定义键位
编辑 `lua/config/keymaps.lua` 文件，添加新的键位映射。

## 🌐 支持的语言

- **Python** - 完整的 LSP 支持
- **JavaScript/TypeScript** - 前端开发支持
- **C/C++** - 系统编程支持
- **Lua** - Neovim 配置语言
- **HTML/CSS** - Web 开发支持
- **Markdown** - 文档编写支持
- **JSON/YAML** - 配置文件支持
- **Rust** - 系统编程支持
- **Go** - 云原生开发支持
- **Java** - 企业级开发支持

## 📋 常用命令

### LazyVim 管理
```vim
:Lazy              # 插件管理器
:Mason             # LSP 服务器管理
:CheckHealth       # 健康检查
```

### 文件操作
```vim
<leader>ff         # 查找文件
<leader>fr         # 最近文件
<leader>fb         # 缓冲区列表
```

### Git 集成
```vim
<leader>gs         # Git 状态
<leader>gc         # Git 提交
<leader>gp         # Git 推送
```

## 🔍 故障排除

### 常见问题

1. **插件安装失败**
   - 检查网络连接
   - 运行 `:Lazy` 手动安装

2. **LSP 服务器不工作**
   - 运行 `:Mason` 检查安装状态
   - 检查 `:CheckHealth` 输出

3. **性能问题**
   - 禁用不必要的插件
   - 检查配置文件错误

### 获取帮助

- 使用 `<leader>sk` 查看所有快捷键
- 运行 `:help` 查看 Neovim 帮助
- 查看插件文档

## 🔄 更新配置

```bash
cd ~/.config/nvim
git pull origin full
```

重启 Neovim 以应用更新。

## 📄 许可证

MIT License - 详见 LICENSE 文件

---

**注意**: 这是 full 分支，包含了所有高级功能。如果需要更轻量的配置，请切换到 main 分支。