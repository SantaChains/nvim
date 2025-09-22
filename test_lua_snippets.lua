-- 测试 Lua snippets
-- 输入 "func" 然后按 Tab 键应该展开为函数模板

local function test_function(params)
  -- body
  return nil
end

-- 测试 "lfunc" snippet
local function name(params)
  -- body
end

-- 测试 "if" snippet
if condition then
  -- body
end

-- 测试 "for" snippet
for i = 1, 10 do
  -- body
end

-- 测试 "table" snippet
local table_name = {
  key = value
}

-- 测试 "req" snippet
-- local module = require('module_name')  -- 注释掉，因为模块不存在

-- 测试 all.json 中的 snippets
-- 输入 "todo" 应该展开为 "TODO: "

return test_function