---
--- Python代码片段配置文件
--- 提供Python开发中常用的代码模板和快捷方式
--- 包括现代Python特性、数据科学、Web开发等
---

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require('luasnip.extras.fmt').fmt
local types = require 'luasnip.util.types'

local function node_with_virtual_text(pos, node, text)
  local nodes
  if node.type == types.textNode then
    node.pos = 2
    nodes = { i(1), node }
  else
    node.pos = 1
    nodes = { node }
  end
  return sn(pos, nodes, {
    node_ext_opts = {
      active = {
        -- override highlight here ("GruvboxOrange").
        virt_text = { { text, 'GruvboxOrange' } },
      },
    },
  })
end

local function nodes_with_virtual_text(nodes, opts)
  if opts == nil then
    opts = {}
  end
  local new_nodes = {}
  for pos, node in ipairs(nodes) do
    if opts.texts[pos] ~= nil then
      node = node_with_virtual_text(pos, node, opts.texts[pos])
    end
    table.insert(new_nodes, node)
  end
  return new_nodes
end

local function choice_text_node(pos, choices, opts)
  choices = nodes_with_virtual_text(choices, opts)
  return c(pos, choices, opts)
end

local ct = choice_text_node

ls.add_snippets('python', {
  s(
  "histo1d", 
      fmt(
      [[
      df.Histo1D(({}), "{}")
      ]],
      {
        i(1, "histogram_binning"),
        i(2, "branch_name")
      }
    )
  ),
  s(
    'ryaml',
    fmt(
      [[
with open({}, "r") as f:
  {} = yaml.safe_load(f)
      ]],
      { i(1, 'yamlfile'), i(2, 'content') }
    )
  ),
  s(
    'main',
    fmt(
      [[
def main():
    {}
if __name__ == "__main__":
    main()
  ]],
      { i(1, 'pass') }
    )
  ),
  s(
    'year',
    t {
      'ps.add_argument("--year", choices=["16", "17", "18"])',
      'ps.add_argument("--pol", choices=["Down", "Up"])',
      'year = args.year',
      'pol = args.pol',
    }
  ),
  s('cwd', t { 'cwd = get_cwd(__file__)' }),
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                          ROOT                           │
  -- ╰─────────────────────────────────────────────────────────╯
  s('NumCPU', fmt('ROOT.RooFit.NumCPU({})', { i(1, '48') })),
  s('rootth1d', fmt('ROOT.TH1D("{}", "{}", {})', { i(1, 'h'), i(2, 'h'), i(3) })),
  s('rootth2d', fmt('ROOT.TH2D("{}", "{}", {})', { i(1, 'h'), i(2, 'h'), i(3) })),
  s('rootbatch', t { 'ROOT.gROOT.SetBatch(True)' }),
  s(
    'bookds',
    fmt(
      [[
df.Book(
  ROOT.std.move(ROOT.RooDataSetHelper("data", "data", ROOT.RooArgSet(x))),
  ["B_DTFDict_B_M"]
)
  ]],
      {}
    )
  ),
  s(
    'rootdf',
    c(1, {
      fmt('df = ROOT.RDataFrame("{}", {})', { i(1, 'DecayTree'), i(2, 'file_list') }),
      fmt(
        [[
file_list = ["{}"]
df = ROOT.RDataFrame("{}", file_list)
    ]],
        { i(1), i(2, 'DecayTree') }
      ),
    })
  ),
  s(
    'mt',
    c(1, {
      t {
        'ps.add_argument("--ncpu", type=int, default=0)',
        'ROOT.EnableImplicitMT(args.ncpu)',
        'print(f"Enabled multithreading with {args.ncpu} CPUs...")',
      },
      t {
        'ROOT.EnableImplicitMT()',
      },
    })
  ),
  s('TLegend', t { 'lg = ROOT.TLegend(0.7,0.7,0.9,0.9)', 'lg.SetFillStyle(4000)', 'lg.SetBorderSize(0)' }),
  s(
    'ROOT',
    t {
      'import ROOT',
      'ROOT.gROOT.SetBatch(True)',
    }
  ),
  s(
    'canvas',
    fmt(
      [[
  c = ROOT.TCanvas("c", "c", {})
  {}
  c.SaveAs("{}")
  ]],
      {
        i(1, '800, 600'),
        i(0),
        i(2, 'test.pdf'),
      }
    )
  ),
  s(
    'gaudi debug',
    t {
      'from Gaudi.Configuration import DEBUG',
      'options.output_level = DEBUG',
    }
  ),
  s(
    'agg',
    t {
      'import matplotlib as mpl',
      'mpl.use("Agg")',
    }
  ),
  s(
    'cwd',
    t {
      'import os',
      'cwd = os.path.dirname(os.path.abspath(__file__))',
    }
  ),
  s(
    'syspath',
    fmt(
      [[
      import sys
      sys.path.append("{}")
      ]],
      { i(1, '..') }
    )
  ),
  s(
    'osexists',
    fmt('os.path.exists({file})', {
      file = i(1),
    })
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    现代Python特性                        │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 类型注解函数
  s(
    'def_typed',
    fmt(
      [[
def {}({}) -> {}:
    """{}"""
    {}
    return {}
      ]],
      {
        i(1, 'function_name'),
        i(2, 'param: type'),
        i(3, 'ReturnType'),
        i(4, 'Function description'),
        i(5, 'pass'),
        i(6, 'None')
      }
    )
  ),
  
  -- 异步函数
  s(
    'async_def',
    fmt(
      [[
async def {}({}) -> {}:
    """{}"""
    {}
    return {}
      ]],
      {
        i(1, 'function_name'),
        i(2, 'param: type'),
        i(3, 'ReturnType'),
        i(4, 'Async function description'),
        i(5, 'await some_async_operation()'),
        i(6, 'result')
      }
    )
  ),
  
  -- 数据类
  s(
    'dataclass',
    fmt(
      [[
from dataclasses import dataclass

@dataclass
class {}:
    {}: {}
    {}: {}
      ]],
      {
        i(1, 'ClassName'),
        i(2, 'field1'),
        i(3, 'type1'),
        i(4, 'field2'),
        i(5, 'type2')
      }
    )
  ),
  
  -- Pydantic模型
  s(
    'pydantic',
    fmt(
      [[
from pydantic import BaseModel

class {}(BaseModel):
    {}: {}
    {}: {}
      ]],
      {
        i(1, 'ModelName'),
        i(2, 'field1'),
        i(3, 'type1'),
        i(4, 'field2'),
        i(5, 'type2')
      }
    )
  ),
  
  -- 枚举类
  s(
    'enum',
    fmt(
      [[
from enum import Enum

class {}(Enum):
    {} = {}
    {} = {}
      ]],
      {
        i(1, 'EnumName'),
        i(2, 'VALUE1'),
        i(3, '1'),
        i(4, 'VALUE2'),
        i(5, '2'
        )
      }
    )
  ),
  
  -- 上下文管理器
  s(
    'contextmanager',
    fmt(
      [[
from contextlib import contextmanager

@contextmanager
def {}({}):
    """{}"""
    try:
        {}
        yield {}
    finally:
        {}
      ]],
      {
        i(1, 'manager_name'),
        i(2, 'param: type'),
        i(3, 'Context manager description'),
        i(4, '# setup code'),
        i(5, 'resource'),
        i(6, '# cleanup code')
      }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    数据处理与科学计算                      │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- NumPy数组创建
  s(
    'numpy_array',
    fmt(
      [[
import numpy as np

{} = np.array([{}])
      ]],
      {
        i(1, 'arr'),
        i(2, '1, 2, 3, 4, 5')
      }
    )
  ),
  
  -- Pandas DataFrame
  s(
    'pandas_df',
    fmt(
      [[
import pandas as pd

{} = pd.DataFrame({{
    '{}': [{}],
    '{}': [{}]
}})
      ]],
      {
        i(1, 'df'),
        i(2, 'column1'),
        i(3, '1, 2, 3'),
        i(4, 'column2'),
        i(5, '4, 5, 6')
      }
    )
  ),
  
  -- Matplotlib绘图
  s(
    'matplotlib_plot',
    fmt(
      [[
import matplotlib.pyplot as plt

plt.figure(figsize=({}, {}))
plt.plot({}, {}, label='{}')
plt.xlabel('{}')
plt.ylabel('{}')
plt.title('{}')
plt.legend()
plt.grid(True)
plt.show()
      ]],
      {
        i(1, '8'),
        i(2, '6'),
        i(3, 'x'),
        i(4, 'y'),
        i(5, 'data'),
        i(6, 'X Label'),
        i(7, 'Y Label'),
        i(8, 'Plot Title')
      }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    Web开发与API                           │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- FastAPI路由
  s(
    'fastapi_route',
    fmt(
      [[
from fastapi import FastAPI

app = FastAPI()

@app.{}('{}')
async def {}({}):
    """{}"""
    return {{'{}': {}}}
      ]],
      {
        i(1, 'get'),
        i(2, '/path'),
        i(3, 'function_name'),
        i(4, 'param: type'),
        i(5, 'Route description'),
        i(6, 'message'),
        i(7, '"Hello World"')
      }
    )
  ),
  
  -- Flask路由
  s(
    'flask_route',
    fmt(
      [[
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('{}', methods=['{}'])
def {}({}):
    """{}"""
    return jsonify({{'{}': {}}})

if __name__ == '__main__':
    app.run(debug=True)
      ]],
      {
        i(1, '/path'),
        i(2, 'GET'),
        i(3, 'function_name'),
        i(4, ''),
        i(5, 'Route description'),
        i(6, 'message'),
        i(7, '"Hello World"')
      }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    错误处理与日志                          │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- 异常处理
  s(
    'try_except',
    fmt(
      [[
try:
    {}
except {} as e:
    print(f"Error: {{e}}")
    {}
      ]],
      {
        i(1, '# Code that might raise an exception'),
        i(2, 'Exception'),
        i(3, '# Handle exception')
      }
    )
  ),
  
  -- 日志配置
  s(
    'logging_setup',
    fmt(
      [[
import logging

logging.basicConfig(
    level=logging.{},
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('{}.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)
      ]],
      {
        i(1, 'INFO'),
        i(2, 'app')
      }
    )
  ),
  
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    测试相关                              │
  -- ╰─────────────────────────────────────────────────────────╯
  
  -- pytest测试函数
  s(
    'pytest_function',
    fmt(
      [[
def test_{}():
    """Test {} functionality"""
    # Arrange
    {}
    
    # Act
    {}
    
    # Assert
    {}
      ]],
      {
        i(1, 'function_name'),
        i(2, 'function'),
        i(3, 'input_data = ...'),
        i(4, 'result = function(input_data)'),
        i(5, 'assert result == expected_output')
      }
    )
  ),
  
  -- unittest测试类
  s(
    'unittest_class',
    fmt(
      [[
import unittest

class Test{}(unittest.TestCase):
    def setUp(self):
        {}
    
    def test_{}(self):
        """Test {}"""
        {}
        self.assert{}({}, {})

if __name__ == '__main__':
    unittest.main()
      ]],
      {
        i(1, 'ClassName'),
        i(2, '# Setup code'),
        i(3, 'method_name'),
        i(4, 'method description'),
        i(5, '# Test code'),
        i(6, 'Equal'),
        i(7, 'actual'),
        i(8, 'expected')
      }
    )
  ),
  s(
    'yearpol',
    t {
      'for year in args.years:',
      '\tfor pol in args.pols:',
    }
  ),
  s(
    'argg',
    fmt(
      [[
      from argparse import ArgumentParser as AP
      from argparse import ArgumentDefaultsHelpFormatter as ADHF
      ps = AP(formatter_class=ADHF)
      ps.add_argument("--test", action="store_true")
      args = ps.parse_args()
      ]],
      {}
    )
  ),
  s(
    'argyears',
    t {
      'ps.add_argument("--years",nargs="+",type=str,default=["16", "17", "18"],choices=["16", "17","18"])',
    }
  ),
  s(
    'argpols',
    t {
      'ps.add_argument("--pols",nargs="+",type=str,default=["Down", "Up"],choices=["Down", "Up"])',
    }
  ),
  s(
    'paras',
    fmt(
      [[
      import os
      import sys
      sys.path.append(os.environ["MAJORANA"])
      from paras import *
      ]],
      {}
    )
  ),
})
