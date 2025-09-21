---
--- CSS代码片段配置文件
--- 提供CSS开发中常用的代码模板和快捷方式
---

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- 常用的CSS属性和值选择
local css_properties = {
  display = {"block", "flex", "grid", "inline", "inline-block", "none"},
  position = {"static", "relative", "absolute", "fixed", "sticky"},
  text_align = {"left", "center", "right", "justify"},
  font_weight = {"normal", "bold", "lighter", "bolder", "100", "200", "300", "400", "500", "600", "700", "800", "900"},
  overflow = {"visible", "hidden", "scroll", "auto"},
  visibility = {"visible", "hidden"},
  white_space = {"normal", "nowrap", "pre", "pre-line", "pre-wrap"}
}

ls.add_snippets("css", {
  -- 基础CSS规则模板
  s(
    "rule",
    fmt(
      [[
{} {{
    {}: {};
}}
      ]],
      {
        i(1, ".class"), 
        i(2, "property"), 
        i(3, "value")
      }
    )
  ),
  
  -- 带注释的CSS规则模板
  s(
    "rulec",
    fmt(
      [[
/* {} */
{} {{
    {}: {};
}}
      ]],
      {
        i(1, "Description"),
        i(2, ".class"), 
        i(3, "property"), 
        i(4, "value")
      }
    )
  ),
  -- Flexbox容器
  s(
    "flex",
    fmt(
      [[
display: flex;
justify-content: {};
align-items: {};
      ]],
      {i(1, "center"), i(2, "center")}
    )
  ),
  -- Grid布局
  s(
    "grid",
    fmt(
      [[
display: grid;
grid-template-columns: {};
grid-gap: {};
      ]],
      {i(1, "repeat(3, 1fr)"), i(2, "1rem")}
    )
  ),
  -- CSS变量定义
  s(
    "var",
    fmt("--{}: {};", {i(1, "variable-name"), i(2, "value")})
  ),
  -- 媒体查询
  s(
    "media",
    fmt(
      [[
@media ({}) {{
    {}
}}
      ]],
      {i(1, "max-width: 768px"), i(2, "/* styles */")}
    )
  ),
  -- 动画关键帧
  s(
    "keyframes",
    fmt(
      [[
@keyframes {} {{
    0% {{
        {}
    }}
    50% {{
        {}
    }}
    100% {{
        {}
    }}
}}
      ]],
      {
        i(1, "animationName"), 
        i(2, "transform: translateX(0);"), 
        i(3, "transform: translateX(50px);"),
        i(4, "transform: translateX(100px);")
      }
    )
  ),
  
  -- 现代CSS Grid布局
  s(
    "grid-area",
    fmt(
      [[
grid-area: {} / {} / {} / {};
      ]],
      {
        i(1, "1"), 
        i(2, "1"), 
        i(3, "2"), 
        i(4, "2")
      }
    )
  ),
  
  -- CSS容器查询（现代特性）
  s(
    "container",
    fmt(
      [[
container-type: {};
container-name: {};
      ]],
      {
        c(1, {t("inline-size"), t("size"), t("block-size")}),
        i(2, "container-name")
      }
    )
  ),
  
  -- CSS嵌套（现代特性）
  s(
    "nest",
    fmt(
      [[
& {} {{
    {}: {};
}}
      ]],
      {
        i(1, ":hover"), 
        i(2, "property"), 
        i(3, "value")
      }
    )
  ),
  
  -- 响应式字体大小（clamp函数）
  s(
    "clamp",
    fmt("font-size: clamp({}, {}, {});", {
      i(1, "1rem"), 
      i(2, "2.5vw"), 
      i(3, "3rem")
    })
  ),
  
  -- 现代色彩函数
  s(
    "color",
    fmt(
      [[
color: {};
background-color: {};
      ]],
      {
        c(1, {
          fmt("rgb({}, {}, {})", {i(1, "255"), i(2, "255"), i(3, "255")}),
          fmt("hsl({}, {}%, {}%)", {i(1, "0"), i(2, "100"), i(3, "50")}),
          fmt("oklch({} {} {})", {i(1, "0.5"), i(2, "0.2"), i(3, "180")})
        }),
        c(2, {
          fmt("rgb({}, {}, {})", {i(1, "0"), i(2, "0"), i(3, "0")}),
          fmt("hsl({}, {}%, {}%)", {i(1, "240"), i(2, "100"), i(3, "50")}),
          fmt("oklch({} {} {})", {i(1, "0.3"), i(2, "0.1"), i(3, "270")})
        })
      }
    )
  ),
  
  -- 盒阴影（增强版）
  s(
    "shadow",
    fmt(
      [[
box-shadow: {} {} {} {} {};
      ]],
      {
        i(1, "0"), 
        i(2, "2px"), 
        i(3, "4px"), 
        i(4, "rgba(0,0,0,0.1)"),
        c(5, {t(""), t("inset")})
      }
    )
  ),
  
  -- 文本阴影
  s(
    "text-shadow",
    fmt("text-shadow: {} {} {} {};", {
      i(1, "1px"), 
      i(2, "1px"), 
      i(3, "2px"), 
      i(4, "rgba(0,0,0,0.5)")
    })
  ),
  
  -- 过渡动画
  s(
    "transition",
    fmt(
      [[
transition: {} {} {} {};
      ]],
      {
        i(1, "all"), 
        i(2, "0.3s"), 
        c(3, {t("ease"), t("linear"), t("ease-in"), t("ease-out"), t("ease-in-out")}),
        i(4, "0s")
      }
    )
  ),
  
  -- 变换（Transform）
  s(
    "transform",
    fmt(
      [[
transform: {}({});
      ]],
      {
        c(1, {
          t("translate"),
          t("translateX"),
          t("translateY"),
          t("scale"),
          t("scaleX"),
          t("scaleY"),
          t("rotate"),
          t("skewX"),
          t("skewY")
        }),
        i(2, "value")
      }
    )
  ),
  
  -- 边框圆角
  s(
    "border-radius",
    fmt("border-radius: {};", {
      c(1, {
        t("4px"),
        t("8px"),
        t("50%"),
        fmt("{} {} {} {}", {i(1, "4px"), i(2, "4px"), i(3, "4px"), i(4, "4px")})
      })
    })
  ),
  
  -- 现代CSS重置
  s(
    "reset",
    fmt(
      [[
*, *::before, *::after {{
    box-sizing: border-box;
}}

* {{
    margin: 0;
}}

html, body {{
    height: 100%;
}}

body {{
    line-height: 1.5;
    -webkit-font-smoothing: antialiased;
}}

img, picture, video, canvas, svg {{
    display: block;
    max-width: 100%;
}}

input, button, textarea, select {{
    font: inherit;
}}

p, h1, h2, h3, h4, h5, h6 {{
    overflow-wrap: break-word;
}}

#root, #__next {{
    isolation: isolate;
}}
      ]],
      {}
    )
  ),
})
