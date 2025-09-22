-- conform.nvim 插件配置
-- 代码格式化工具，支持多种语言
-- 文档: https://github.com/stevearc/conform.nvim
-- ⚠️ 重要：不要设置 plugin.config，这会破坏 LazyVim 的格式化功能
-- 参考文档: https://www.lazyvim.org/plugins/formatting
-- none-ls   nvim-lint

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- 在保存前执行格式化
  cmd = { "ConformInfo" },    -- 提供格式化信息命令
  keys = {
    -- 统一的格式化快捷键
    {
      "<leader>pf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "🔧 格式化文件",
    },
    {
      "<leader>F",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "格式化代码",
    },
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Conform 格式化",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, async = true })
      end,
      mode = "n",
      desc = "Conform 注入格式化",
    },
  },
  opts = {
    -- 默认格式化选项 - 遵循 LazyVim 最佳实践
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- 不建议更改
      quiet = false, -- 不建议更改
      lsp_format = "fallback", -- 不建议更改
    },
    
    -- 辅助函数：检查formatter是否可用
    formatters_available = function(bufnr)
      local conform = require("conform")
      local available = {}
      
      -- 检查Python formatter
      if conform.get_formatter_info("ruff_format", bufnr).available then
        table.insert(available, "ruff_format")
      elseif conform.get_formatter_info("black", bufnr).available then
        table.insert(available, "black")
      end
      
      -- 检查JavaScript/TypeScript formatter
      if conform.get_formatter_info("prettier", bufnr).available then
        table.insert(available, "prettier")
      end
      
      -- 检查Shell formatter - 禁用fish_indent
      if conform.get_formatter_info("shfmt", bufnr).available then
        table.insert(available, "shfmt")
      end
      
      return available
    end,
    
    -- 定义每个文件类型的格式化工具
    formatters_by_ft = {
      -- Lua
      lua = { "stylua" },
      
      -- Python - 使用 ruff 替代 black 和 isort
      python = function(bufnr)
        local conform = require("conform")
        local ruff_info = conform.get_formatter_info("ruff_format", bufnr)
        if ruff_info.available then
          return { "ruff_format" }
        else
          -- 回退到 black 和 isort
          local formatters = {}
          if conform.get_formatter_info("black", bufnr).available then
            table.insert(formatters, "black")
          end
          if conform.get_formatter_info("isort", bufnr).available then
            table.insert(formatters, "isort")
          end
          return formatters
        end
      end,
      
      -- JavaScript/TypeScript - 优先使用prettier，避免prettierd
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      
      -- Web开发 - 使用prettier
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      vue = { "prettier" },
      svelte = { "prettier" },
      
      -- Shell脚本 - 禁用fish_indent，只使用shfmt
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      fish = { "shfmt" }, -- 明确指定fish文件使用shfmt，避免使用fish_indent
      
      -- 配置文件 - 使用prettier，移除不可用的formatter
      yaml = { "prettier" },
      toml = { "prettier" },
      graphql = { "prettier" },
      
      -- 其他语言 - 简化配置，只使用可用的formatter
      go = { "gofmt" },
      rust = { "rustfmt" },
      cpp = { "clang-format" },
      c = { "clang-format" },
      
      -- 支持代码块格式化 - 使用prettier
      markdown = { "prettier" },
      vimwiki = { "prettier" },
      
      -- 默认格式化器
      ["_"] = { "trim_whitespace" },
    },
    
    -- 格式化工具配置
    formatters = {
      -- Python Ruff 配置 - 修复Windows环境下的参数格式
      ruff_format = {
        command = "ruff",
        args = function(ctx)
          -- 构建参数列表，确保在Windows环境下正确处理
          local args = { "format" }
          
          -- 只有在文件名有效时才添加 --stdin-filename 参数
          if ctx.filename and ctx.filename ~= "" then
            table.insert(args, "--stdin-filename")
            table.insert(args, ctx.filename)
          end
          
          table.insert(args, "-")
          return args
        end,
        stdin = true,
        cwd = require("conform.util").root_file({ "pyproject.toml", "ruff.toml", ".ruff.toml" }),
        require_cwd = true, -- 确保在有效工作目录下运行
        -- 添加条件检查，避免在无效环境下运行
        condition = function(ctx)
          return ctx.filename and ctx.filename ~= "" and vim.fn.executable("ruff") == 1
        end,
      },
      
      -- Shell 脚本格式化 - 禁用 fish_indent
      shfmt = {
        command = "shfmt",
        args = { "-i", "2", "-ci", "-bn", "-filename", "$FILENAME" },
        stdin = true,
        -- 添加条件检查，确保只在 shfmt 可用时使用
        condition = function()
          return vim.fn.executable("shfmt") == 1
        end,
      },
      
      -- YAML 格式化
      yamlfmt = {
        command = "yamlfmt",
        args = { "-" },
        stdin = true,
      },
      
      -- 添加对用户名包含空格的支持 - 仅在需要时使用
      -- 使用 Mason 安装路径的格式化器配置
      stylua = {
        command = "stylua",
        args = { "--stdin-filepath", "$FILENAME", "-" },
        stdin = true,
      },
      
      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },
    },
    
    -- 异步格式化配置
    notify_on_error = true, -- 格式化失败时显示通知
    notify_no_formatters = true, -- 当没有可用格式化工具时显示通知
    
    -- 禁用 fish_indent 格式化器
    formatters_disabled = { "fish_indent" },
    
    -- 日志配置 - 帮助调试格式化问题
    log_level = vim.log.levels.WARN, -- 设置日志级别
  },
  
  -- 插件初始化配置 - 遵循 LazyVim 最佳实践
  init = function()
    -- 创建用户命令
    vim.api.nvim_create_user_command("ConformInfo", function()
      require("conform").show_info()
    end, { desc = "显示conform格式化信息" })
    
    -- 添加格式化错误处理
    vim.api.nvim_create_autocmd("User", {
      pattern = "ConformFormatFailed",
      callback = function(args)
        local conform = require("conform")
        local errors = args.data.errors
        local formatter = args.data.formatter
        
        -- 显示具体的错误信息
        vim.notify(
          string.format("格式化失败: %s\n错误: %s", formatter or "未知", table.concat(errors, "\n")),
          vim.log.levels.ERROR
        )
        
        -- 记录详细错误信息到日志
        vim.schedule(function()
          local log_file = vim.fn.stdpath("cache") .. "/conform_errors.log"
          local log_content = string.format(
            "[%s] Formatter: %s\nErrors:\n%s\n\n",
            os.date("%Y-%m-%d %H:%M:%S"),
            formatter or "unknown",
            table.concat(errors, "\n")
          )
          
          local file = io.open(log_file, "a")
          if file then
            file:write(log_content)
            file:close()
          end
        end)
      end,
    })
  end,
}