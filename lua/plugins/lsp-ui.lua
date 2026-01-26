-- LSP UI 和交互配置文件 (职责分离版本)
-- 职责：专注于 LSP 的 UI 显示、交互体验和高级功能
-- 不包含服务器配置和基础快捷键（由 lsp-config.lua 统一管理）

-- UI 图标配置 (内联定义，避免依赖缺失模块)
local icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Info = " ",
    Hint = " ",
  }
}

-- 诊断显示配置
vim.diagnostic.config {
  virtual_text = {
    spacing = 4,
    prefix = '',
    source = "if_many",
  },
  float = {
    severity_sort = true,
    source = 'if_many',
    border = 'single',
    focusable = false,
    style = "minimal",
    header = "",
    prefix = "",
    max_width = 80,
    max_height = 20,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
}

-- LSP UI 处理器配置
local custom_handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { 
    border = 'single',
    max_width = 80,
    max_height = 20,
  }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { 
    border = 'single',
    max_width = 80,
    max_height = 20,
  }),
}

-- 应用自定义处理器
for method, handler in pairs(custom_handlers) do
  vim.lsp.handlers[method] = handler
end

-- LSP 高级功能和 UI 交互配置
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-ui-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end
    
    -- 高级导航快捷键（使用更好的选择器）
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP UI: ' .. desc })
    end

    -- 增强的定义跳转（带检查）
    map('gd', function()
      local safe_require = require('utils.safe_require')
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(event.buf, 'textDocument/definition', params, function(_, result, _, _)
        if not result or vim.tbl_isempty(result) then
          vim.notify('No definition found', vim.log.levels.INFO)
        else
          -- 优先使用 snacks.picker，回退到内置
          local snacks = safe_require.safe_require('snacks')
          if snacks then
            snacks.picker.lsp_definitions()
          else
            vim.lsp.buf.definition()
          end
        end
      end)
    end, 'Goto Definition (Enhanced)')

    -- 增强的引用查找
    map('gr', function()
      local safe_require = require('utils.safe_require')
      local snacks = safe_require.safe_require('snacks')
      if snacks then
        snacks.picker.lsp_references()
      else
        vim.lsp.buf.references()
      end
    end, 'Goto References (Enhanced)')

    -- LSP 操作快捷键
    map('<leader>la', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')

    -- 诊断管理快捷键
    map('<leader>ld', function()
      vim.diagnostic.open_float { source = true }
    end, 'Open Diagnostic Float')
    
    -- 切换诊断显示
    map('<leader>td', function()
      local current_config = vim.diagnostic.config()
      if current_config.virtual_text then
        vim.diagnostic.config { 
          underline = false, 
          virtual_text = false, 
          signs = false, 
          update_in_insert = false 
        }
        vim.notify("Diagnostics disabled", vim.log.levels.INFO)
      else
        vim.diagnostic.config { 
          underline = true, 
          virtual_text = true, 
          signs = true, 
          update_in_insert = false 
        }
        vim.notify("Diagnostics enabled", vim.log.levels.INFO)
      end
    end, 'Toggle Diagnostics Display')

    -- 文档高亮功能（如果支持）
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) and vim.bo[event.buf].filetype ~= 'bigfile' then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-ui-highlight-' .. event.buf, { clear = true })
      
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- 清理高亮
      vim.api.nvim_create_autocmd('LspDetach', {
        buffer = event.buf,
        group = vim.api.nvim_create_augroup('lsp-ui-detach-' .. event.buf, { clear = true }),
        callback = function()
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = highlight_augroup }
        end,
      })
    end

    -- 内联提示功能（如果支持）
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        local current_state = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        vim.lsp.inlay_hint.enable(not current_state, { bufnr = event.buf })
        vim.notify(
          string.format("Inlay hints %s", current_state and "disabled" or "enabled"),
          vim.log.levels.INFO
        )
      end, 'Toggle Inlay Hints')
    end
    
    -- 代码镜头功能（如果支持）
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        buffer = event.buf,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = event.buf })
        end,
      })
      
      map('<leader>cl', function()
        vim.lsp.codelens.run()
      end, 'Run Code Lens')
    end
  end,
})

-- 全局 LSP UI 增强功能
vim.api.nvim_create_user_command('LspRestart', function()
  local clients = vim.lsp.get_clients()
  for _, client in pairs(clients) do
    client.stop()
    vim.defer_fn(function()
      vim.cmd('edit')
    end, 500)
  end
  vim.notify('LSP servers restarted', vim.log.levels.INFO)
end, { desc = 'Restart all LSP servers' })

vim.api.nvim_create_user_command('LspLog', function()
  local safe_require = require('utils.safe_require')
  safe_require.safe_call(function()
    vim.cmd('edit ' .. vim.lsp.get_log_path())
  end, "打开 LSP 日志文件失败")
end, { desc = 'Open LSP log file' })

vim.api.nvim_create_user_command('LspInfo', function()
  local safe_require = require('utils.safe_require')
  safe_require.safe_cmd('LspInfo', "显示 LSP 客户端信息失败")
end, { desc = 'Show LSP client information' })

-- LSP 状态显示（可选）
vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  callback = function()
    vim.defer_fn(function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        local names = {}
        for _, client in pairs(clients) do
          table.insert(names, client.name)
        end
        vim.notify(
          string.format('LSP active: %s', table.concat(names, ', ')),
          vim.log.levels.INFO,
          { title = 'LSP Status' }
        )
      end
    end, 100)
  end,
})

return {}