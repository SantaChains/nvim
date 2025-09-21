-- =============================================================================
-- Dockerfile 代码片段集合
-- =============================================================================
-- 提供Dockerfile开发中常用的代码模板，包括：
-- - 基础语法结构
-- - 多阶段构建
-- - 最佳实践模式
-- - 常见应用模板
-- - 优化技巧
-- =============================================================================

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local types = require "luasnip.util.types"

ls.add_snippets("dockerfile", {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    基础语法                           │
  -- ╰─────────────────────────────────────────────────────────╯
  -- 基础Dockerfile模板
  s(
    "dockerfile",
    fmt(
      [[
FROM {}
WORKDIR {}
COPY {} .
RUN {}
EXPOSE {}
CMD ["{}"]
      ]],
      {
        i(1, "node:18-alpine"),
        i(2, "/app"),
        i(3, "package*.json"),
        i(4, "npm install"),
        i(5, "3000"),
        c(6, {"npm", "start", "node", "python", "java"})
      }
    )
  ),
  
  -- FROM指令
  s(
    "from",
    fmt("FROM {}", {c(1, {"ubuntu:latest", "node:18-alpine", "python:3.11", "alpine:latest", "nginx:alpine"})})
  ),
  
  -- RUN指令
  s(
    "run",
    fmt("RUN {}", {c(1, {"apt-get update", "yum update", "apk update", "npm install", "pip install"})})
  ),
  
  -- COPY指令
  s(
    "copy",
    fmt("COPY {} {}", {i(1, "src"), i(2, "dest")})
  ),
  
  -- WORKDIR指令
  s(
    "workdir",
    fmt("WORKDIR {}", {i(1, "/app")})
  ),
  
  -- ENV指令
  s(
    "env",
    fmt("ENV {}={}", {c(1, {"NODE_ENV", "PYTHONPATH", "JAVA_HOME", "PATH"}), c(2, {"production", "development", "test"})})
  ),
  
  -- EXPOSE指令
  s(
    "expose",
    fmt("EXPOSE {}", {c(1, {"80", "3000", "8080", "443", "22"})})
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    高级指令                           │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- ADD指令
  s(
    "add",
    fmt("ADD {} {}", {i(1, "src"), i(2, "dest")})
  ),
  
  -- VOLUME指令
  s(
    "volume",
    fmt("VOLUME {}", {i(1, "/data")})
  ),
  
  -- USER指令
  s(
    "user",
    fmt("USER {}", {c(1, {"root", "nobody", "app", "www-data"})})
  ),
  
  -- LABEL指令
  s(
    "label",
    fmt("LABEL {}={}", {i(1, "version"), i(2, "1.0")})
  ),
  
  -- ARG指令
  s(
    "arg",
    fmt("ARG {}", {i(1, "VERSION")})
  ),
  
  -- ONBUILD指令
  s(
    "onbuild",
    fmt("ONBUILD {}", {i(1, "RUN npm install")})
  ),
  
  -- STOPSIGNAL指令
  s(
    "stopsignal",
    fmt("STOPSIGNAL {}", {c(1, {"SIGTERM", "SIGINT", "SIGKILL"})})
  ),
  
  -- HEALTHCHECK指令
  s(
    "healthcheck",
    fmt(
      [[
HEALTHCHECK --interval={} --timeout={} --start-period={} --retries={} \
  CMD {}
      ]],
      {i(1, "30s"), i(2, "10s"), i(3, "5s"), i(4, "3"), i(5, "curl -f http://localhost/ || exit 1")}
    )
  ),
  
  -- SHELL指令
  s(
    "shell",
    fmt("SHELL [\"{}\"]", {c(1, {"/bin/bash", "/bin/sh", "/bin/zsh"})})
  ),
})