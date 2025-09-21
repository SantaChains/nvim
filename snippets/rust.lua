-- =============================================================================
-- Rust 代码片段集合
-- =============================================================================
-- 提供Rust开发中常用的代码模板，包括：
-- - 基础语法结构
-- - 所有权和借用
-- - 错误处理
-- - 并发编程
-- - 标准库常用类型
-- - 模式匹配
-- - 宏定义
-- - 测试代码
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

ls.add_snippets('rust', {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    基础语法结构                         │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 主函数
  s(
    'main',
    fmt(
      [[
fn main() {{
    {}
}}
      ]],
      { i(1, "// 程序主逻辑") }
    )
  ),
  
  -- 函数定义
  s(
    'fn',
    fmt(
      [[
fn {}({}) -> {} {{
    {}
}}
      ]],
      { i(1, "function_name"), i(2, "x: i32"), i(3, "i32"), i(4, "x + 1") }
    )
  ),
  
  -- 变量声明
  s(
    'let',
    fmt('let {} = {};', { i(1, "x"), i(2, "42") })
  ),
  
  s(
    'letmut',
    fmt('let mut {} = {};', { i(1, "x"), i(2, "42") })
  ),
  
  -- 常量
  s(
    'const',
    fmt('const {}: {} = {};', { i(1, "MAX_VALUE"), i(2, "i32"), i(3, "100") })
  ),
  
  -- 静态变量
  s(
    'static',
    fmt('static {}: {} = {};', { i(1, "INSTANCE"), i(2, "String"), i(3, "String::new()") })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    控制流                               │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- if表达式
  s(
    'if',
    fmt(
      [[
if {} {{
    {}
}} else {{
    {}
}}
      ]],
      { i(1, "condition"), i(2, "// if分支"), i(3, "// else分支") }
    )
  ),
  
  -- if let表达式
  s(
    'iflet',
    fmt(
      [[
if let Some({}) = {} {{
    {}
}}
      ]],
      { i(1, "value"), i(2, "option"), i(3, "// 处理Some分支") }
    )
  ),
  
  -- match表达式
  s(
    'match',
    fmt(
      [[
match {} {{
    {} => {},
    {} => {},
    _ => {},
}}
      ]],
      { 
        i(1, "value"),
        i(2, "Some(x)"), i(3, "x * 2"),
        i(4, "None"), i(5, "0"),
        i(6, "// 默认情况")
      }
    )
  ),
  
  -- for循环
  s(
    'for',
    fmt(
      [[
for {} in {} {{
    {}
}}
      ]],
      { i(1, "item"), i(2, "collection"), i(3, "// 循环体") }
    )
  ),
  
  -- while循环
  s(
    'while',
    fmt(
      [[
while {} {{
    {}
}}
      ]],
      { i(1, "condition"), i(2, "// 循环体") }
    )
  ),
  
  -- loop循环
  s(
    'loop',
    fmt(
      [[
loop {{
    {}
    break;
}}
      ]],
      { i(1, "// 循环体") }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    输出和调试                           │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- println宏
  s(
    'println',
    fmt('println!("{}", {});', { i(1, "{}", "{\"Hello, {}!\"}"), i(2, "name") })
  ),
  
  s(
    'pri',
    fmt('println!("{}", {});', { i(1, "{}", "{\"Hello, {}!\"}"), i(2, "name") })
  ),
  
  -- print宏
  s(
    'print',
    fmt('print!("{}", {});', { i(1, "{}", "{\"Hello, {}!\"}"), i(2, "name") })
  ),
  
  -- eprintln宏
  s(
    'eprintln',
    fmt('eprintln!("{}", {});', { i(1, "{}", "{\"Error: {}\"}"), i(2, "message") })
  ),
  
  -- 调试输出
  s(
    'dbg',
    fmt('dbg!({});', { i(1, "variable") })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    数据结构                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 结构体
  s(
    'struct',
    fmt(
      [[
#[derive(Debug)]
struct {} {{
    {}: {},
    {}: {},
}}
      ]],
      { i(1, "Person"), i(2, "name"), i(3, "String"), i(4, "age"), i(5, "u32") }
    )
  ),
  
  -- 元组结构体
  s(
    'tuple_struct',
    fmt('struct {}({}, {});', { i(1, "Point"), i(2, "f64"), i(3, "f64") })
  ),
  
  -- 枚举
  s(
    'enum',
    fmt(
      [[
#[derive(Debug)]
enum {} {{
    {}({}),
    {} {{ {}: {} }},
}}
      ]],
      { 
        i(1, "Message"), 
        i(2, "Move"), i(3, "i32"),
        i(4, "ChangeColor"), i(5, "r"), i(6, "u8")
      }
    )
  ),
  
  -- Option枚举
  s(
    'option',
    fmt(
      [[
let {}: Option<{}> = {};
match {} {{
    Some({}) => {},
    None => {},
}}
      ]],
      { 
        i(1, "maybe_value"), i(2, "i32"), i(3, "Some(42)"),
        rep(1), i(4, "value"), i(5, "value * 2"),
        i(6, "0")
      }
    )
  ),
  
  -- Result枚举
  s(
    'result',
    fmt(
      [[
let {}: Result<{}, {}> = {};
match {} {{
    Ok({}) => {},
    Err({}) => {},
}}
      ]],
      { 
        i(1, "result"), i(2, "i32"), i(3, "String"), i(4, "Ok(42)"),
        rep(1), i(5, "value"), i(6, "value * 2"),
        i(7, "error"), i(8, "eprintln!(\"Error: {}\", error)")
      }
    )
  ),
  
  -- 向量
  s(
    'vec',
    fmt('let mut {}: Vec<{}> = vec![{}];', { i(1, "v"), i(2, "i32"), i(3, "1, 2, 3, 4, 5") })
  ),
  
  -- 哈希映射
  s(
    'hashmap',
    fmt(
      [[
use std::collections::HashMap;

let mut {} = HashMap::new();
{}.insert({}, {});
      ]],
      { i(1, "map"), rep(1), i(2, "key"), i(3, "value") }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    函数和方法                           │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 方法定义
  s(
    'impl',
    fmt(
      [[
impl {} {{
    fn {}({}) -> {} {{
        {}
    }}
}}
      ]],
      { i(1, "StructName"), i(2, "method_name"), i(3, "&self"), i(4, "ReturnType"), i(5, "// 方法实现") }
    )
  ),
  
  -- 关联函数
  s(
    'impl_new',
    fmt(
      [[
impl {} {{
    fn new({}) -> Self {{
        Self {{
            {}
        }}
    }}
}}
      ]],
      { i(1, "StructName"), i(2, "param: Type"), i(3, "field: param") }
    )
  ),
  
  -- 特质实现
  s(
    'impl_trait',
    fmt(
      [[
impl {} for {} {{
    fn {}({}) -> {} {{
        {}
    }}
}}
      ]],
      { i(1, "TraitName"), i(2, "TypeName"), i(3, "method_name"), i(4, "&self"), i(5, "ReturnType"), i(6, "// 方法实现") }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    所有权和借用                         │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 借用检查
  s(
    'borrow',
    fmt(
      [[
fn {}({}) -> {} {{
    {}
}}
      ]],
      { 
        i(1, "function_name"),
        c(2, {t("&str"), t("&String"), t("&Vec<i32>"), t("&mut Vec<i32>")}),
        i(3, "ReturnType"),
        i(4, "// 函数实现")
      }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    错误处理                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 错误传播
  s(
    'error_propagation',
    fmt('let {} = {}?;', { i(1, "value"), i(2, "function_call()") })
  ),
  
  -- unwrap_or
  s(
    'unwrap_or',
    fmt('let {} = {}.unwrap_or({});', { i(1, "value"), i(2, "option"), i(3, "default_value") })
  ),
  
  -- expect
  s(
    'expect',
    fmt('let {} = {}.expect("{}");', { i(1, "value"), i(2, "option"), i(3, "错误信息") })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    并发编程                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 线程创建
  s(
    'thread',
    fmt(
      [[
use std::thread;

let {} = thread::spawn(|| {{
    {}
}});
{}.join().unwrap();
      ]],
      { i(1, "handle"), i(2, "// 线程逻辑"), rep(1) }
    )
  ),
  
  -- Arc和Mutex
  s(
    'arc_mutex',
    fmt(
      [[
use std::sync::{Arc, Mutex};
use std::thread;

let {} = Arc::new(Mutex::new({}));
let {} = Arc::clone(&{});
let {} = thread::spawn(move || {{
    let mut {} = {}.lock().unwrap();
    {}
}});
      ]],
      { 
        i(1, "data"), i(2, "0"),
        i(3, "data_clone"), rep(1),
        i(4, "handle"), i(5, "num"), rep(3),
        i(6, "*num += 1;")
      }
    )
  ),
  
  -- Channel
  s(
    'channel',
    fmt(
      [[
use std::sync::mpsc;

let ({}, {}) = mpsc::channel();
{}.send({}).unwrap();
let {} = {}.recv().unwrap();
      ]],
      { i(1, "tx"), i(2, "rx"), rep(1), i(3, "message"), i(4, "received"), rep(2) }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    宏定义                               │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 宏定义
  s(
    'macro',
    fmt(
      [[
macro_rules! {} {{
    ({}) => {{
        {}
    }};
}}
      ]],
      { i(1, "macro_name"), i(2, "$x:expr"), i(3, "$x * 2") }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    测试代码                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 测试模块
  s(
    'test_module',
    fmt(
      [[
#[cfg(test)]
mod tests {{
    use super::*;

    #[test]
    fn {}() {{
        {}
    }}
}}
      ]],
      { i(1, "test_function"), i(2, "assert_eq!(2 + 2, 4);") }
    )
  ),
  
  -- 测试函数
  s(
    'test',
    fmt(
      [[
#[test]
fn {}() {{
    {}
}}
      ]],
      { i(1, "test_name"), i(2, "assert!(true);") }
    )
  ),
  
  -- 基准测试
  s(
    'bench',
    fmt(
      [[
#[bench]
fn {}(b: &mut Bencher) {{
    b.iter(|| {{
        {}
    }});
}}
      ]],
      { i(1, "bench_name"), i(2, "// 基准测试代码") }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    模块和包                             │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 模块声明
  s(
    'mod',
    fmt('mod {};', { i(1, "module_name") })
  ),
  
  -- use语句
  s(
    'use',
    fmt('use {}::{};', { i(1, "std"), i(2, "collections::HashMap") })
  ),
  
  -- pub关键字
  s(
    'pub',
    fmt('pub {} {}: {},', { c(1, {t("fn"), t("struct"), t("enum")}), i(2, "name"), i(3, "Type") })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    迭代器和闭包                        │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 迭代器方法
  s(
    'iterator',
    fmt(
      [[
let {}: Vec<_> = {}
    .iter()
    .filter(|{}| {})
    .map(|{}| {})
    .collect();
      ]],
      { i(1, "result"), i(2, "collection"), i(3, "x"), i(4, "x > 0"), rep(3), i(5, "x * 2") }
    )
  ),
  
  -- 闭包
  s(
    'closure',
    fmt('let {} = |{}| -> {} {{ {} }};', { i(1, "closure_name"), i(2, "x: i32"), i(3, "i32"), i(4, "x + 1") })
  ),
})