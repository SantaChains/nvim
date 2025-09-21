-- =============================================================================
-- C++ 代码片段集合
-- =============================================================================
-- 提供C++开发中常用的代码模板，包括：
-- - 基础语法结构
-- - 现代C++特性
-- - STL容器和算法
-- - 类和对象
-- - 模板编程
-- - 错误处理
-- - 调试输出
-- =============================================================================

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local types = require 'luasnip.util.types'

ls.add_snippets('cpp', {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    基础语法结构                           │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 条件编译
  s(
    '#if',
    c(1, {
      fmt(
        [[
#ifdef {}
{}
#endif
        ]],
        { i(1, "DEBUG"), i(2) }
      ),
      fmt(
        [[
#ifdef {}
{}
#else
{}
#endif
        ]],
        { i(1, "DEBUG"), i(2), i(3) }
      ),
    })
  ),
  
  -- 标准条件编译
  s(
    '#ifdef',
    fmt(
      [[
#ifdef {}
{}
#endif
      ]],
      { i(1, "MACRO"), i(2) }
    )
  ),
  
  s(
    '#ifndef',
    fmt(
      [[
#ifndef {}
#define {}
{}
#endif // {}
      ]],
      { i(1, "HEADER_GUARD"), rep(1), i(2), rep(1) }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    现代C++特性                          │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 主函数
  s(
    'main',
    fmt(
      [[
int main(int argc, char* argv[]) {{
    {}
    return 0;
}}
      ]],
      { i(1, "// 程序主逻辑") }
    )
  ),
  
  -- 命名空间
  s(
    'namespace',
    fmt(
      [[
namespace {} {{
    {}
}} // namespace {}
      ]],
      { i(1, "my_namespace"), i(2), rep(1) }
    )
  ),
  
  -- 自动类型推导
  s(
    'auto',
    fmt('auto {} = {};', { i(1, "var"), i(2) })
  ),
  
  -- Lambda表达式
  s(
    'lambda',
    fmt(
      [[
auto {} = [{}]({}) -> {} {{
    {}
}};
      ]],
      { 
        i(1, "lambda"), 
        c(2, {t(""), t("&"), t("="), t("&, =")}),
        i(3, "int x, int y"), 
        i(4, "int"), 
        i(5, "return x + y;") 
      }
    )
  ),
  
  -- Range-based for循环
  s(
    'forrange',
    fmt(
      [[
for (const auto& {} : {}) {{
    {}
}}
      ]],
      { i(1, "item"), i(2, "container"), i(3) }
    )
  ),
  s(
    'info',
    fmt(
      [[
      info() << {} << endmsg;
      ]],
      { i(1) }
    )
  ),
  s(
    'warning',
    fmt(
      [[
      warning() << {} << endmsg;
      ]],
      { i(1) }
    )
  ),
  s(
    'error',
    fmt(
      [[
      error() << {} << endmsg;
      ]],
      { i(1) }
    )
  ),
  s(
    'std::cout',
    fmt(
      [[
      std::cout << {} << '\n';
      ]],
      { i(1) }
    )
  ),
  s(
    'pvar',
    fmt(
      [[
    "\t{}: " << {} <<
    ]],
      { i(1), rep(1) }
    )
  ),
  s(
    'gaudiprop',
    fmt(
      [[
      Gaudi::Property<{}> {}{{this, "{}", {}, "{}"}};
      ]],
      { i(1, 'type'), i(2, 'name'), i(3, 'option'), i(4, 'default'), i(5, 'description') }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    STL容器和算法                         │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- Vector
  s(
    'vector',
    fmt(
      [[
std::vector<{}> {};
{} = {{{}}};
      ]],
      { i(1, "int"), i(2, "vec"), rep(2), i(3, "1, 2, 3, 4, 5") }
    )
  ),
  
  -- Map
  s(
    'map',
    fmt(
      [[
std::map<{}, {}> {};
{}[{}] = {};
      ]],
      { i(1, "std::string"), i(2, "int"), i(3, "map"), rep(3), i(4, "key"), i(5, "value") }
    )
  ),
  
  -- 迭代器循环
  s(
    'iterator',
    fmt(
      [[
for (auto it = {}.begin(); it != {}.end(); ++it) {{
    {}
}}
      ]],
      { i(1, "container"), rep(1), i(2) }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    类和对象                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 类定义
  s(
    'class',
    fmt(
      [[
class {} {{
public:
    {}();
    virtual ~{}();
    
private:
    {};
}};
      ]],
      { i(1, "ClassName"), rep(1), rep(1), i(2, "int member_") }
    )
  ),
  
  -- 构造函数
  s(
    'constructor',
    fmt(
      [[
{}::{}({}) : {} {{
    {}
}}
      ]],
      { i(1, "ClassName"), rep(1), i(2), i(3, "member_(value)"), i(4) }
    )
  ),
  
  -- 析构函数
  s(
    'destructor',
    fmt(
      [[
{}::~{}() {{
    {}
}}
      ]],
      { i(1, "ClassName"), rep(1), i(2, "// 清理资源") }
    )
  ),
  
  -- Getter和Setter
  s(
    'getter',
    fmt(
      [[
{} {}::{}() const {{
    return {};
}}
      ]],
      { i(1, "int"), i(2, "ClassName"), i(3, "getValue"), i(4, "member_") }
    )
  ),
  
  s(
    'setter',
    fmt(
      [[
void {}::{}({} {}) {{
    {} = {};
}}
      ]],
      { i(1, "ClassName"), i(2, "setValue"), i(3, "int"), i(4, "value"), i(5, "member_"), rep(4) }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    模板编程                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 函数模板
  s(
    'template_function',
    fmt(
      [[
template<typename {}>
{} {}({} {}) {{
    return {};
}}
      ]],
      { i(1, "T"), i(2, "T"), i(3, "functionName"), i(4, "T"), i(5, "param"), i(6, "param") }
    )
  ),
  
  -- 类模板
  s(
    'template_class',
    fmt(
      [[
template<typename {}>
class {} {{
public:
    {}({});
    
private:
    {} {};
}};
      ]],
      { i(1, "T"), i(2, "TemplateClass"), i(3, "TemplateClass"), i(4, "T value"), i(5, "T"), i(6, "value_") }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    错误处理                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- Try-catch
  s(
    'trycatch',
    fmt(
      [[
try {{
    {}
}} catch (const {}& {}) {{
    {}
}}
      ]],
      { i(1), c(2, {t("std::exception"), t("std::runtime_error"), t("std::invalid_argument")}), i(3, "e"), i(4, "std::cerr << e.what() << std::endl;") }
    )
  ),
  
  -- 异常抛出
  s(
    'throw',
    fmt('throw {}("{}");', {
      c(1, {t("std::runtime_error"), t("std::invalid_argument"), t("std::out_of_range")}),
      i(2, "错误信息")
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    智能指针                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- unique_ptr
  s(
    'unique_ptr',
    fmt('std::unique_ptr<{}> {} = std::make_unique<{}>({});', {
      i(1, "Type"), i(2, "ptr"), rep(1), i(3, "args")
    })
  ),
  
  -- shared_ptr
  s(
    'shared_ptr',
    fmt('std::shared_ptr<{}> {} = std::make_shared<{}>({});', {
      i(1, "Type"), i(2, "ptr"), rep(1), i(3, "args")
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    字符串处理                           │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 字符串操作
  s(
    'string_format',
    fmt('std::string {} = fmt::format("{}", {});', {
      i(1, "result"), i(2, "Hello {}!"), i(3, "name")
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    文件操作                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 文件读取
  s(
    'file_read',
    fmt(
      [[
std::ifstream {}("{}");
if ({}.is_open()) {{
    std::string line;
    while (std::getline({}, line)) {{
        {}
    }}
    {}.close();
}}
      ]],
      { i(1, "file"), i(2, "input.txt"), rep(1), rep(1), i(3, "// 处理每一行"), rep(1) }
    )
  ),
  
  -- 文件写入
  s(
    'file_write',
    fmt(
      [[
std::ofstream {}("{}");
if ({}.is_open()) {{
    {} << "{}" << std::endl;
    {}.close();
}}
      ]],
      { i(1, "file"), i(2, "output.txt"), rep(1), rep(1), i(3, "数据内容"), rep(1) }
    )
  ),
})
