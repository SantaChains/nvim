---
--- 通用代码片段配置文件
--- 提供所有文件类型都可用的通用代码模板和快捷方式
---

-- 安全加载luasnip模块
local ok, ls = pcall(require, "luasnip")
if not ok then
  -- 如果luasnip不可用，提供一个空的兼容层
  return {}
end

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require "luasnip.util.types"

-- 获取用户名和邮箱（用于文件头部注释）
local function get_user_info()
  -- Windows兼容版本
  local name = "Unknown"
  local email = "user@example.com"
  
  -- 尝试获取Git配置的用户名
  local handle = io.popen("git config user.name 2>nul")
  if handle then
    local result = handle:read("*a"):gsub("%s+$", "")
    handle:close()
    if result ~= "" then
      name = result
    end
  end
  
  -- 尝试获取Git配置的邮箱
  handle = io.popen("git config user.email 2>nul")
  if handle then
    local result = handle:read("*a"):gsub("%s+$", "")
    handle:close()
    if result ~= "" then
      email = result
    end
  end
  
  return name, email
end

local user_name, user_email = get_user_info()

-- 全局snippets选择快捷键
vim.keymap.set({ "i", "s" }, "<A-n>", function()
  if ls.choice_active() then 
    ls.change_choice(1) 
  end
end, { silent = true })

-- 全局可用的snippets
ls.add_snippets("all", {
  -- 时间戳相关
  s("p3", t("lb-conda default/2023-04-26 python3")),
  
  s(
    "timestamp",
    fmt("{}", { t(tostring(os.date("%Y-%m-%d %H:%M:%S"))) })
  ),
  
  s(
    "date",
    fmt("{}", { t(tostring(os.date("%Y-%m-%d"))) })
  ),
  
  s(
    "time",
    fmt("{}", { t(tostring(os.date("%H:%M:%S"))) })
  ),
  
  -- 注释和文档
  s(
    "todo",
    fmt("TODO: {}", { i(1, "待办事项") })
  ),
  
  s(
    "fixme",
    fmt("FIXME: {}", { i(1, "需要修复的问题") })
  ),
  
  s(
    "hack",
    fmt("HACK: {}", { i(1, "临时解决方案") })
  ),
  
  s(
    "note",
    fmt("NOTE: {}", { i(1, "重要说明") })
  ),
  
  s(
    "warning",
    fmt("WARNING: {}", { i(1, "警告信息") })
  ),
  
  -- 文件头部注释模板
  s(
    "header",
    fmt(
      [[
/******************************************************************************
 * @file        {}
 * @brief       {}
 * @author      {}
 * @email       {}
 * @date        {}
 * @version     1.0.0
 * @license     {}
 * @copyright   Copyright (c) {}
 ******************************************************************************/
      ]],
      {
        i(1, "filename"),
        i(2, "Brief description"),
        t(user_name),
        t(user_email),
        t(tostring(os.date("%Y-%m-%d"))),
        c(3, {t("MIT"), t("GPL-3.0"), t("Apache-2.0"), t("BSD-3-Clause")}),
        t(tostring(os.date("%Y")))
      }
    )
  ),
  
  -- 分隔线注释
  s(
    "sep",
    fmt(
      [[
/******************************************************************************
 * {}
 ******************************************************************************/
      ]],
      { i(1, "Section") }
    )
  ),
  
  s(
    "line",
    t("/******************************************************************************/")
  ),
  
  -- 常用符号和特殊字符
  s("arrow", t("→")),
  s("larrow", t("←")),
  s("uarrow", t("↑")),
  s("darrow", t("↓")),
  s("check", t("✓")),
  s("cross", t("✗")),
  s("star", t("★")),
  s("heart", t("♥")),
  
  -- 数学符号
  s("alpha", t("α")),
  s("beta", t("β")),
  s("gamma", t("γ")),
  s("delta", t("δ")),
  s("theta", t("θ")),
  s("lambda", t("λ")),
  s("mu", t("μ")),
  s("pi", t("π")),
  s("sigma", t("σ")),
  
  -- 版权和商标
  s("copyright", t("©")),
  s("registered", t("®")),
  s("trademark", t("™")),
  
  -- 常用短语
  s("email", fmt("Email: {}", {t(user_email)})),
  s("author", fmt("Author: {}", {t(user_name)})),
  
  -- 代码模板
  s(
    "debug",
    fmt('console.log("{}", {});', {i(1, "Debug:"), i(2, "variable")})
  ),
  
  s(
    "error",
    fmt('console.error("{}", {});', {i(1, "Error:"), i(2, "error")})
  ),
  
  s(
    "warn",
    fmt('console.warn("{}", {});', {i(1, "Warning:"), i(2, "warning")})
  ),
})

-- 验证代码片段加载成功
local snippet_count = 0
for _ in pairs(ls.get_snippets("all")) do
  snippet_count = snippet_count + 1
end

if snippet_count > 0 then
  print(string.format("[luasnip] 成功加载 %d 个全局代码片段", snippet_count))
else
  print("[luasnip] 警告：未找到全局代码片段")
end
