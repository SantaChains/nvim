# UI与视觉增强

<cite>
**本文档中引用的文件**  
- [init.lua](file://init.lua)
- [theme.lua](file://lua/plugins/theme.lua)
- [bufferline.lua](file://lua/plugins/bufferline.lua)
- [essential.lua](file://lua/plugins/essential.lua)
- [options.lua](file://lua/config/options.lua)
</cite>

## 目录
1. [主题配置与切换](#主题配置与切换)  
2. [标签页美化](#标签页美化)  
3. [Neovide GUI 特殊设置](#neovide-gui-特殊设置)  
4. [沉浸式写作模式](#沉浸式写作模式)  
5. [Markdown 渲染与状态栏配置](#markdown-渲染与状态栏配置)  
6. [个性化视觉设置指导](#个性化视觉设置指导)

## 主题配置与切换

`lua/plugins/theme.lua` 文件负责管理多个主题的加载与配置，其中 OneDarkPro 主题作为重点支持之一，提供了丰富的自定义选项。该主题通过 `olimorris/onedarkpro.nvim` 插件实现，并在配置中启用了多种代码样式、文件类型支持及插件集成。

OneDarkPro 支持以下主题变体：
- `onedark`
- `onelight`
- `onedark_vivid`
- `onedark_dark`
- `vaporwave`

通过 `styles` 配置项，可定义注释、关键字、函数等语法元素的显示样式。例如，注释为斜体，关键字为粗体加斜体，提升代码可读性。

此外，系统通过 `vim.api.nvim_create_user_command` 注册了 `OneDarkProTheme` 命令，允许用户动态切换主题变体。命令支持参数补全，使用方式如下：
```
:OneDarkProTheme onedark
:OneDarkProTheme vaporwave
```

同时，`themery.nvim` 主题管理器提供了图形化主题选择界面，并绑定了一系列快捷键（如 `<leader>Tt` 打开主题选择器，`<leader>To` 切换到 OneDark），极大提升了主题切换的便捷性。

**Section sources**  
- [theme.lua](file://lua/plugins/theme.lua#L435-L470)
- [theme.lua](file://lua/plugins/theme.lua#L501-L541)

## 标签页美化

`lua/plugins/bufferline.lua` 配置了 `akinsho/bufferline.nvim` 插件，用于美化 Neovim 的标签页显示。该插件在缓冲区列表上方显示可点击的标签，支持图标、颜色高亮和分组管理。

主要配置特性包括：
- 模式设置为 `buffers`，仅显示打开的缓冲区
- `always_show_bufferline = false` 表示仅在有多个缓冲区时显示标签栏
- 与 `nvim-web-devicons` 集成，显示文件类型图标
- 在侧边栏（如 NvimTree）旁添加偏移文本“文件浏览器”，提升界面辨识度

同时，该文件还定义了丰富的快捷键，便于管理缓冲区：
- `<leader>bp`：切换当前标签的固定状态
- `<leader>bo`：关闭其他标签
- `[b` 和 `]b`：在标签间循环切换

这些设置显著提升了多文件编辑时的导航效率与视觉体验。

**Section sources**  
- [bufferline.lua](file://lua/plugins/bufferline.lua#L0-L76)

## Neovide GUI 特殊设置

`init.lua` 文件中包含了针对 Neovide 图形界面的专用配置，优化了窗口外观与交互体验。

### 窗口透明度
通过 `vim.g.neovide_opacity` 设置整体窗口透明度为 `0.9`，营造柔和的视觉氛围。背景颜色设为 `#1a1b26`，与主题配色协调统一。

### 光标动画
启用光标动画效果，提升视觉流畅性：
- `neovide_cursor_animation_length = 0.1`：光标移动动画时长
- `neovide_cursor_trail_size = 0.8`：光标拖尾长度
- `neovide_cursor_antialiasing = true`：启用抗锯齿，使光标更平滑

### 字体与渲染
设置默认字体为 `"Monaco Nerd Font Mono:h14"`，确保图标与文字清晰可读。同时启用 `neovide_floating_blur_amount_x/y` 实现浮动窗口的模糊背景效果，增强层次感。

这些设置共同构建了一个现代、美观且响应灵敏的编辑环境。

**Section sources**  
- [init.lua](file://init.lua#L20-L49)
- [options.lua](file://lua/config/options.lua#L10-L18)

## 沉浸式写作模式

通过 `folke/zen-mode.nvim` 和 `folke/twilight.nvim` 插件实现沉浸式写作功能，帮助用户专注于内容创作。

### Zen Mode 配置
Zen Mode 启用后，界面将进入极简状态：
- 背景透明度设为 `0.95`
- 窗口宽度限制为 `120` 字符，高度为 `1`（全屏）
- 隐藏行号、相对行号、光标行、折叠列等干扰元素

### Twilight 模式
Twilight 模式自动与 Zen Mode 集成，对非当前段落的代码或文本进行淡化处理：
- `alpha = 0.25`：非焦点区域透明度
- `context = 10`：保留上下文行数
- 支持 Treesitter 语法分析，精准识别函数、条件语句等结构

此组合有效减少视觉干扰，提升写作与阅读专注度。

**Section sources**  
- [essential.lua](file://lua/plugins/essential.lua#L40-L92)
- [essential.lua](file://lua/plugins/essential.lua#L88-L135)

## Markdown 渲染与状态栏配置

### Markdown 渲染增强
OneDarkPro 主题配置中启用了 `render_markdown = true`，确保 Markdown 文件的语法高亮与渲染效果达到最佳。同时，`essential.lua` 中对 Markdown 标题字号进行了分级设置：
- h1: 1.4 倍
- h2: 1.3 倍
- ...
- h6: 0.9 倍

并启用了粗体与上下边距，使文档结构更清晰。

### 状态栏（lualine）配置
虽然未在当前文件中直接配置 `lualine`，但 OneDarkPro 的 `plugins` 配置中已启用 `lualine` 集成。结合主题的 `lualine_transparency = false` 设置，状态栏将保持不透明，确保信息清晰可见。

此外，`options.lua` 中启用了 `termguicolors` 和 `signcolumn = "yes"`，保证状态栏与整体界面色彩一致，且符号列始终显示。

**Section sources**  
- [theme.lua](file://lua/plugins/theme.lua#L501-L541)
- [essential.lua](file://lua/plugins/essential.lua#L40-L92)
- [options.lua](file://lua/config/options.lua#L45-L47)

## 个性化视觉设置指导

用户可根据个人偏好调整以下视觉参数：

### 修改透明度级别
- **Neovide 窗口透明度**：修改 `init.lua` 中的 `vim.g.neovide_opacity` 值（范围 0.0-1.0）
- **Zen Mode 背景**：调整 `essential.lua` 中 `backdrop` 值
- **Twilight 淡化程度**：修改 `alpha` 值控制非焦点区域透明度

### 禁用动画效果
在 `init.lua` 中注释或删除以下行以禁用光标动画：
```lua
-- vim.g.neovide_cursor_animation_length = 0.1
-- vim.g.neovide_cursor_trail_size = 0.8
```

### 更换字体
修改 `options.lua` 中的 `vim.opt.guifont` 设置，例如：
```lua
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h14"
```

### 自定义主题样式
在 `theme.lua` 中修改 `onedarkpro.setup().styles` 部分，例如将注释改为非斜体：
```lua
comments = "NONE"
```

### 切换默认主题
修改 `theme.lua` 中 `HardHacker` 主题的优先级或直接更改 `colorscheme` 命令。

以上设置均可即时生效，无需重启编辑器（部分需重新加载配置）。

**Section sources**  
- [init.lua](file://init.lua#L20-L49)
- [options.lua](file://lua/config/options.lua#L10-L18)
- [theme.lua](file://lua/plugins/theme.lua#L435-L470)
- [essential.lua](file://lua/plugins/essential.lua#L40-L135)