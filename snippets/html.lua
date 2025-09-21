---
--- HTML代码片段配置文件
--- 提供HTML5开发中常用的代码模板和快捷方式
--- 包括现代Web组件、表单、媒体元素等
---

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("html", {
  -- HTML5基础模板
  s(
    "html5",
    fmt(
      [[
<!DOCTYPE html>
<html lang="{}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{}</title>
    {}
</head>
<body>
    {}
</body>
</html>
      ]],
      {
        i(1, "zh-CN"),
        i(2, "Page Title"),
        i(3, ""),
        i(4, "<h1>Hello World</h1>")
      }
    )
  ),
  -- div标签
  s(
    "div",
    fmt('<div class="{}">{}</div>', {i(1, "container"), i(2, "")})
  ),
  -- 带id的div
  s(
    "divid",
    fmt('<div id="{}">{}</div>', {i(1, "myId"), i(2, "")})
  ),
  -- 链接
  s(
    "a",
    fmt('<a href="{}">{}</a>', {i(1, "#"), i(2, "链接文本")})
  ),
  -- 图片
  s(
    "img",
    fmt('<img src="{}" alt="{}">', {i(1, "image.jpg"), i(2, "描述")})
  ),
  -- 表单
  s(
    "form",
    fmt(
      [[
<form action="{}" method="{}">
    {}
    <input type="submit" value="{}">
</form>
      ]],
      {
        i(1, "#"),
        i(2, "POST"),
        i(3, '<input type="text" name="username" placeholder="用户名">'),
        i(4, "提交")
      }
    )
  ),
  -- 输入框
  s(
    "input",
    fmt('<input type="{}" name="{}" placeholder="{}">', {i(1, "text"), i(2, "name"), i(3, "输入...")})
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    现代HTML5元素                         │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 语义化标签
  s(
    "header",
    fmt(
      [[
<header>
    <nav>
        <ul>
            <li><a href="{}">{}</a></li>
            <li><a href="{}">{}</a></li>
        </ul>
    </nav>
</header>
      ]],
      {
        i(1, "#home"), i(2, "首页"),
        i(3, "#about"), i(4, "关于")
      }
    )
  ),
  
  s(
    "article",
    fmt(
      [[
<article>
    <header>
        <h2>{}</h2>
        <time datetime="{}">{}</time>
    </header>
    <p>{}</p>
    <footer>
        <p>作者: {}</p>
    </footer>
</article>
      ]],
      {
        i(1, "文章标题"),
        i(2, "2024-01-01"),
        i(3, "2024年1月1日"),
        i(4, "文章内容..."),
        i(5, "作者名")
      }
    )
  ),
  
  s(
    "section",
    fmt(
      [[
<section>
    <h2>{}</h2>
    <p>{}</p>
</section>
      ]],
      {
        i(1, "章节标题"),
        i(2, "章节内容...")
      }
    )
  ),
  
  -- 媒体元素
  s(
    "video",
    fmt(
      [[
<video width="{}" height="{}" controls>
    <source src="{}" type="video/{}">
    您的浏览器不支持视频标签。
</video>
      ]],
      {
        i(1, "320"),
        i(2, "240"),
        i(3, "video.mp4"),
        c(4, {t("mp4"), t("webm"), t("ogg")})
      }
    )
  ),
  
  s(
    "audio",
    fmt(
      [[
<audio controls>
    <source src="{}" type="audio/{}">
    您的浏览器不支持音频标签。
</audio>
      ]],
      {
        i(1, "audio.mp3"),
        c(2, {t("mpeg"), t("wav"), t("ogg")})
      }
    )
  ),
  
  -- 图形和图表
  s(
    "svg",
    fmt(
      [[
<svg width="{}" height="{}" viewBox="0 0 {} {}">
    <rect x="{}" y="{}" width="{}" height="{}" fill="{}" />
</svg>
      ]],
      {
        i(1, "100"),
        i(2, "100"),
        i(3, "100"),
        i(4, "100"),
        i(5, "10"),
        i(6, "10"),
        i(7, "80"),
        i(8, "80"),
        i(9, "blue")
      }
    )
  ),
  
  -- Canvas元素
  s(
    "canvas",
    fmt('<canvas id="{}" width="{}" height="{}">{}</canvas>', {
      i(1, "myCanvas"),
      i(2, "200"),
      i(3, "100"),
      i(4, "您的浏览器不支持Canvas标签。")
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    表单增强                              │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 现代表单输入类型
  s(
    "input_email",
    fmt('<input type="email" name="{}" placeholder="{}" required>', {
      i(1, "email"),
      i(2, "请输入邮箱地址")
    })
  ),
  
  s(
    "input_tel",
    fmt('<input type="tel" name="{}" placeholder="{}" pattern="{}">', {
      i(1, "phone"),
      i(2, "请输入电话号码"),
      i(3, "[0-9]{11}")
    })
  ),
  
  s(
    "input_date",
    fmt('<input type="date" name="{}" min="{}" max="{}">', {
      i(1, "date"),
      i(2, "2024-01-01"),
      i(3, "2024-12-31")
    })
  ),
  
  s(
    "input_range",
    fmt('<input type="range" name="{}" min="{}" max="{}" step="{}" value="{}">', {
      i(1, "range"),
      i(2, "0"),
      i(3, "100"),
      i(4, "1"),
      i(5, "50")
    })
  ),
  
  -- 下拉选择
  s(
    "select",
    fmt(
      [[
<select name="{}" id="{}">
    <option value="{}">{}</option>
    <option value="{}">{}</option>
    <option value="{}">{}</option>
</select>
      ]],
      {
        i(1, "select"),
        i(2, "mySelect"),
        i(3, "option1"), i(4, "选项1"),
        i(5, "option2"), i(6, "选项2"),
        i(7, "option3"), i(8, "选项3")
      }
    )
  ),
  
  -- 文本域
  s(
    "textarea",
    fmt('<textarea name="{}" rows="{}" cols="{}" placeholder="{}">{}</textarea>', {
      i(1, "message"),
      i(2, "4"),
      i(3, "50"),
      i(4, "请输入您的消息..."),
      i(5, "")
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    Web组件和现代特性                       │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 进度条
  s(
    "progress",
    fmt('<progress value="{}" max="{}">{}%</progress>', {
      i(1, "70"),
      i(2, "100"),
      i(3, "70")
    })
  ),
  
  s(
    "meter",
    fmt('<meter value="{}" min="{}" max="{}" low="{}" high="{}">{}</meter>', {
      i(1, "7"),
      i(2, "0"),
      i(3, "10"),
      i(4, "3"),
      i(5, "7"),
      i(6, "7 out of 10")
    })
  ),
  
  -- 详情/摘要
  s(
    "details",
    fmt(
      [[
<details>
    <summary>{}</summary>
    {}
</details>
      ]],
      {
        i(1, "点击展开"),
        i(2, "详细内容...")
      }
    )
  ),
  
  -- 标记文本
  s(
    "mark",
    fmt('<mark>{}</mark>', {
      i(1, "重要文本")
    })
  ),
  
  -- 缩写词
  s(
    "abbr",
    fmt('<abbr title="{}">{}</abbr>', {
      i(1, "HyperText Markup Language"),
      i(2, "HTML")
    })
  ),
  
  -- 引用
  s(
    "blockquote",
    fmt(
      [[
<blockquote cite="{}">
    <p>{}</p>
    <footer>— <cite>{}</cite></footer>
</blockquote>
      ]],
      {
        i(1, "https://example.com"),
        i(2, "引用的内容..."),
        i(3, "引用来源")
      }
    )
  ),
  
  -- 代码块
  s(
    "codeblock",
    fmt('<pre><code class="language-{}">{}</code></pre>', {
      i(1, "python"),
      i(2, "# 代码内容")
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    元信息和链接                          │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 完整的head标签
  s(
    "head",
    fmt(
      [[
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="{}">
    <meta name="keywords" content="{}">
    <meta name="author" content="{}">
    <meta name="robots" content="index, follow">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta property="og:title" content="{}">
    <meta property="og:description" content="{}">
    <meta property="og:image" content="{}">
    <meta property="og:url" content="{}">
    <meta name="twitter:card" content="summary_large_image">
    <link rel="canonical" href="{}">
    <link rel="icon" type="image/x-icon" href="{}">
    <title>{}</title>
</head>
      ]],
      {
        i(1, "页面描述"),
        i(2, "关键词1, 关键词2, 关键词3"),
        i(3, "作者名"),
        i(4, "页面标题"),
        i(5, "页面描述"),
        i(6, "https://example.com/image.jpg"),
        i(7, "https://example.com"),
        i(8, "https://example.com"),
        i(9, "/favicon.ico"),
        i(10, "页面标题")
      }
    )
  ),
})