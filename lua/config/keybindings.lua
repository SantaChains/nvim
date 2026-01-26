-- Neovim 键位配置 - 精简高效版本
-- 核心原则：简洁、实用、无冲突

local keymap = vim.keymap
local cmd = vim.cmd
local fn = vim.fn

-- ===== 工具函数 =====
local function has_plugin(name) return pcall(require, name) end

local function safe_unmap(mode, key)
  local ok = pcall(keymap.del, mode, key)
  return ok
end

-- ===== 清理冲突键位 =====
local conflicts = {
  -- {"n", "<space>l"}, {"n", "<space>e"}, {"n", "<space>n"},
  -- {"n", "<leader>x"}, {"n", "<leader>l"}, {"n", "<leader>gol"}, {"n", "<leader>golr"}
}

for _, map in ipairs(conflicts) do
  safe_unmap(map[1], map[2])
end

-- ===== LSP 功能组 (<leader>p) =====
local lsp_mappings = {
  {"pr", vim.lsp.buf.rename, "🔧 重命名"},
  {"pa", vim.lsp.buf.code_action, "🔧 代码操作"},
  {"pd", vim.lsp.buf.definition, "🔧 跳转到定义"},
  {"pD", vim.lsp.buf.declaration, "🔧 跳转到声明"},
  {"pi", vim.lsp.buf.implementation, "🔧 跳转到实现"},
  {"pR", vim.lsp.buf.references, "🔧 查找引用"},
  {"ps", vim.lsp.buf.document_symbol, "🔧 文档符号"},
  {"ph", vim.lsp.buf.hover, "🔧 悬停信息"},
  -- {"pf", function() vim.lsp.buf.format({async = true}) end, "🔧 格式化"}, -- 已移至 conform.lua 统一管理
}

for _, map in ipairs(lsp_mappings) do
  keymap.set("n", "<leader>" .. map[1], map[2], {desc = map[3]})
end

-- ===== 诊断功能组 (<leader>x) =====
keymap.set("n", "<leader>xx", function()
  if has_plugin("trouble") then
    cmd("Trouble diagnostics toggle")
  else
    vim.diagnostic.setloclist()
  end
end, {desc = "🔍 诊断列表"})

keymap.set("n", "<leader>xj", function() vim.diagnostic.goto_next({wrap = true}) end, {desc = "🔍 下一个诊断"})
keymap.set("n", "<leader>xk", function() vim.diagnostic.goto_prev({wrap = true}) end, {desc = "🔍 上一个诊断"})
keymap.set("n", "<leader>xe", vim.diagnostic.open_float, {desc = "🔍 诊断详情"})

-- ===== Python 调试组 (<leader>py) =====
keymap.set("n", "<leader>pyb", function()
  if has_plugin("dap") then
    require("dap").toggle_breakpoint()
  else
    vim.notify("需要安装 nvim-dap", vim.log.levels.WARN)
  end
end, {desc = "🐍 切换断点"})

keymap.set("n", "<leader>pyc", function()
  if has_plugin("dap") then
    require("dap").continue()
  else
    vim.notify("需要安装 nvim-dap", vim.log.levels.WARN)
  end
end, {desc = "🐍 继续执行"})

-- ===== 配置管理组 (<leader>C) =====
local config_paths = {
  {"Cc", "init.lua", "⚙️ 编辑配置"},
  {"Cv", "lua/config/keybindings.lua", "⚙️ 编辑键位"},
  {"Cp", "lua/plugins/", "⚙️ 编辑插件"},
  {"Cs", "snippets/", "⚙️ 编辑片段"},
}

for _, map in ipairs(config_paths) do
  keymap.set("n", "<leader>" .. map[1], function()
    cmd("edit " .. fn.stdpath("config") .. "/" .. map[2])
  end, {desc = map[3]})
end

keymap.set("n", "<leader>Cr", function()
  if vim.bo.modified then cmd("write") end
  cmd("source " .. fn.stdpath("config") .. "/init.lua")
  vim.notify("✅ 配置已重载", vim.log.levels.INFO)
  cmd("edit!")
end, {desc = "🔄 重载配置"})

keymap.set("n", "<leader>Ch", cmd.checkhealth, {desc = "⚙️ 健康检查"})
keymap.set("n", "<leader>Cm", cmd.Mason, {desc = "⚙️ Mason管理器"})

-- ===== 注释生成组 (<leader>n) =====
keymap.set("n", "<leader>nf", function()
  if has_plugin("neogen") then
    require("neogen").generate({ type = "func" })
  else
    vim.notify("需要安装 neogen", vim.log.levels.WARN)
  end
end, {desc = "📝 生成函数注释"})

keymap.set("n", "<leader>nc", function()
  if has_plugin("neogen") then
    require("neogen").generate({ type = "class" })
  else
    vim.notify("需要安装 neogen", vim.log.levels.WARN)
  end
end, {desc = "📝 生成类注释"})

keymap.set("n", "<leader>nt", function()
  if has_plugin("neogen") then
    require("neogen").generate({ type = "type" })
  else
    vim.notify("需要安装 neogen", vim.log.levels.WARN)
  end
end, {desc = "📝 生成类型注释"})

keymap.set("n", "<leader>nd", function()
  if has_plugin("neogen") then
    require("neogen").generate({ type = "file" })
  else
    vim.notify("需要安装 neogen", vim.log.levels.WARN)
  end
end, {desc = "📝 生成文件注释"})

keymap.set("n", "<leader>na", function()
  if has_plugin("neogen") then
    require("neogen").generate()
  else
    vim.notify("需要安装 neogen", vim.log.levels.WARN)
  end
end, {desc = "📝 智能生成注释"})

-- ===== 通知管理组 (<leader>N) =====
keymap.set("n", "<leader>Nh", function()
  if has_plugin("telescope") then
    cmd("Telescope notify")
  elseif has_plugin("snacks") then
    require("snacks").notifier.show_history()
  else
    cmd("messages")
  end
end, {desc = "📢 通知历史"})

keymap.set("n", "<leader>Nc", function()
  cmd("messages clear")
  if vim.notify and vim.notify.dismiss then
    vim.notify.dismiss()
  end
  vim.notify("📢 通知已清理", vim.log.levels.INFO)
end, {desc = "📢 清理通知"})

-- ===== 文件搜索组 (<leader>f) =====
keymap.set("n", "<leader>fg", function()
  if has_plugin("telescope") then
    cmd("Telescope live_grep")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "🔍 全局搜索"})

keymap.set("n", "<leader>ff", function()
  if has_plugin("telescope") then
    cmd("Telescope find_files")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "🔍 搜索文件"})

keymap.set("n", "<leader>fb", function()
  if has_plugin("telescope") then
    cmd("Telescope buffers")
  else
    cmd("ls")
  end
end, {desc = "🔍 浏览缓冲区"})

keymap.set("n", "<leader>fh", function()
  if has_plugin("telescope") then
    cmd("Telescope help_tags")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "❓ 帮助搜索"})

keymap.set("n", "<leader>fk", function()
  if has_plugin("telescope") then
    cmd("Telescope keymaps")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "⌨️ 键位搜索"})

keymap.set("n", "<leader>fc", function()
  if has_plugin("telescope") then
    cmd("Telescope commands")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "⚙️ 命令搜索"})

keymap.set("n", "<leader>fr", function()
  if has_plugin("telescope") then
    cmd("Telescope registers")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "📋 寄存器搜索"})

keymap.set("n", "<leader>fm", function()
  if has_plugin("telescope") then
    cmd("Telescope marks")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "📍 标记搜索"})

keymap.set("n", "<leader>fj", function()
  if has_plugin("telescope") then
    cmd("Telescope jumplist")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "🚀 跳转历史"})

keymap.set("n", "<leader>fs", function()
  if has_plugin("telescope") then
    cmd("Telescope current_buffer_fuzzy_find")
  else
    vim.notify("需要安装 telescope", vim.log.levels.WARN)
  end
end, {desc = "📄 当前文件搜索"})

-- ===== 实用功能 =====
keymap.set("n", "<leader>h", ":nohlsearch<CR>", {desc = "💡 取消高亮"})
keymap.set("n", "<Esc>", ":nohlsearch<CR>", {desc = "💡 取消高亮"})
keymap.set("n", "<leader>Q", ":q<CR>", {desc = "🚪 退出窗口"})

-- 智能退出命令
vim.api.nvim_create_user_command('Q', function()
  local modified = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
      modified = modified + 1
    end
  end
  
  if modified > 0 then
    local choice = fn.confirm(
      string.format("有 %d 个未保存文件，您想要：", modified),
      "&保存并退出\n&直接退出\n&取消", 1)
    
    if choice == 1 then
      vim.cmd("silent! wa | qa")
    elseif choice == 2 then
      vim.cmd("silent! qa!")
    end
  else
    vim.cmd("silent! qa")
  end
end, {desc = "🚪 智能退出"})

-- ===== 仪表盘访问 =====
keymap.set("n", "<leader>D", function()
  if has_plugin("dashboard") then
    cmd("Dashboard")
  elseif has_plugin("alpha") then
    cmd("Alpha")
  elseif has_plugin("snacks") then
    require("snacks").dashboard.open()
  else
    vim.notify("未找到仪表盘插件", vim.log.levels.WARN)
  end
end, {desc = "📊 打开仪表盘"})

-- ===== which-key 配置 =====
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then return end
  
  wk.add({
    {"<leader>p", group = "🔧 LSP功能"},
    {"<leader>py", group = "🐍 Python调试"},
    {"<leader>C", group = "⚙️ 配置管理"},
    {"<leader>N", group = "📢 通知管理"},
    {"<leader>T", group = "🎨 色彩管理"},
  })
end)

-- ===== 实用命令 =====
vim.api.nvim_create_user_command('ShowKeymaps', function(opts)
  local modes = opts.args ~= "" and {opts.args} or {'n', 'i', 'v'}
  for _, mode in ipairs(modes) do
    print("\n=== " .. mode:upper() .. " 模式 ===")
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      if map.lhs:match("^<leader>") then
        print(string.format("  %s -> %s (%s)", map.lhs, map.rhs or "回调", map.desc or "无描述"))
      end
    end
  end
end, {nargs = '?', desc = "显示键位映射"})

