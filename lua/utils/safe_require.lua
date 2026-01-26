-- 安全的插件加载工具
-- 用于处理中文路径和空格路径的兼容性问题

local M = {}

-- 安全地执行函数，捕获错误并提供友好的中文错误信息
function M.safe_call(func, error_msg)
  local ok, result = pcall(func)
  if not ok then
    local msg = error_msg or "操作执行失败"
    vim.notify(msg .. ": " .. tostring(result), vim.log.levels.ERROR)
    return nil, result
  end
  return result, nil
end

-- 安全地加载模块
function M.safe_require(module_name, error_msg)
  local ok, module = pcall(require, module_name)
  if not ok then
    local msg = error_msg or ("模块 '" .. module_name .. "' 加载失败")
    vim.notify(msg .. ": " .. tostring(module), vim.log.levels.ERROR)
    return nil, module
  end
  return module, nil
end

-- 安全地执行 vim.cmd 命令
function M.safe_cmd(cmd_str, error_msg)
  return M.safe_call(function() vim.cmd(cmd_str) end, error_msg or "命令执行失败")
end

-- 安全地执行 LSP 相关命令
function M.safe_lsp_call(func, desc)
  return M.safe_call(func, (desc or "LSP 操作") .. " 失败")
end

-- 批量安全执行命令
function M.safe_batch_calls(calls)
  local results = {}
  local errors = {}
  
  for i, call in ipairs(calls) do
    local result, err = M.safe_call(call.func, call.error_msg)
    if err then
      table.insert(errors, {index = i, error = err, msg = call.error_msg})
    else
      table.insert(results, result)
    end
  end
  
  return results, errors
end

-- 创建带错误处理的包装函数
function M.wrap_with_error_handler(func, error_msg)
  return function(...)
    local args = {...}
    return M.safe_call(function() return func(unpack(args)) end, error_msg)
  end
end

return M