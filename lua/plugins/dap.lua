return {
  -- DAP 核心
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- DAP UI界面
      {
        'rcarriga/nvim-dap-ui',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
        config = function()
          local dap = require('dap')
          local dapui = require('dapui')
          
          -- DAP UI 标准配置
          dapui.setup({
            -- 侧边栏布局
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  { id = 'breakpoints', size = 0.25 },
                  { id = 'stacks', size = 0.25 },
                  { id = 'watches', size = 0.25 },
                },
                size = 40,
                position = 'left',
              },
              {
                elements = {
                  { id = 'repl', size = 0.5 },
                  { id = 'console', size = 0.5 },
                },
                size = 10,
                position = 'bottom',
              },
            },
            -- 图标配置
            icons = { 
              expanded = '▾', 
              collapsed = '▸',
              current_frame = '▸',
            },
            -- 映射配置
            mappings = {
              expand = { '<CR>', '<2-LeftMouse>' },
              open = 'o',
              remove = 'd',
              edit = 'e',
              repl = 'r',
              toggle = 't',
            },
            -- 渲染配置
            render = {
              max_type_length = nil,
              max_value_lines = 100,
            },
            -- 浮动窗口配置
            floating = {
              max_height = nil,
              max_width = nil,
              border = 'rounded',
              mappings = {
                close = { 'q', '<Esc>' },
              },
            },
            -- 窗口配置
            windows = { indent = 1 },
          })
          
          -- 自动开关UI
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },
      -- 虚拟文本显示变量值
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
          require('nvim-dap-virtual-text').setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            filter_references_pattern = '<module',
            virt_text_pos = 'eol',
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil
          })
        end,
      },
      -- Python 调试支持
    --   {
    --     'mfussenegger/nvim-dap-python',
    --     ft = 'python',
    --     config = function()
    --       -- 使用 Mason 安装的 debugpy
    --       local mason_path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/Scripts/python.exe'
    --       if vim.fn.executable(mason_path) == 1 then
    --         require('dap-python').setup(mason_path)
    --       else
    --         require('dap-python').setup('python')
    --       end
    --     end,
    --   },
    },
    config = function()
      local dap = require('dap')
      
      -- 调试器适配器配置已由 Mason 统一管理
      -- 这里只保留调试配置，适配器配置由 mason-nvim-dap 自动处理
      
      -- C/C++ 调试配置 (适配器由 Mason 自动配置)
      dap.configurations.cpp = {
        {
          name = 'Launch C++ Program',
          type = 'cppdbg',  -- 使用 Mason 安装的 cpptools
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = false,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = true
            },
          },
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = 'gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = true
            },
          },
        },
        {
          name = 'Launch with CodeLLDB',
          type = 'codelldb',  -- 使用 Mason 安装的 codelldb
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      
      -- C 使用相同的配置
      dap.configurations.c = dap.configurations.cpp
      
      -- Rust 调试配置 (使用 codelldb)
      dap.configurations.rust = {
        {
          name = 'Launch Rust Program',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          sourceLanguages = { 'rust' },
        },
      }
      
    --   -- Python 调试配置 (适配器由 Mason 自动配置)
    --   dap.configurations.python = {
    --     {
    --       type = 'python',  -- 使用 Mason 安装的 debugpy
    --       request = 'launch',
    --       name = 'Launch Python File',
    --       program = '${file}',
    --       console = 'integratedTerminal',
    --       cwd = '${workspaceFolder}',
    --       pythonPath = function()
    --         -- 优先使用虚拟环境
    --         local cwd = vim.fn.getcwd()
    --         local venv_paths = {
    --           cwd .. '/venv/Scripts/python.exe',
    --           cwd .. '/.venv/Scripts/python.exe',
    --         }
            
    --         for _, path in ipairs(venv_paths) do
    --           if vim.fn.executable(path) == 1 then
    --             return path
    --           end
    --         end
            
    --         -- 回退到系统 Python
    --         return 'python'
    --       end,
    --     },
    --     {
    --       type = 'python',
    --       request = 'launch',
    --       name = 'Launch with Arguments',
    --       program = '${file}',
    --       args = function()
    --         local args_string = vim.fn.input('Arguments: ')
    --         return vim.split(args_string, ' +')
    --       end,
    --       console = 'integratedTerminal',
    --       cwd = '${workspaceFolder}',
    --     },
    --     {
    --       type = 'python',
    --       request = 'launch',
    --       name = 'Launch Module',
    --       module = function()
    --         return vim.fn.input('Module name: ')
    --       end,
    --       console = 'integratedTerminal',
    --       cwd = '${workspaceFolder}',
    --     },
    --     {
    --       type = 'python',
    --       request = 'attach',
    --       name = 'Attach to Process',
    --       connect = {
    --         port = 5678,
    --         host = '127.0.0.1',
    --       },
    --       pathMappings = {
    --         {
    --           localRoot = '${workspaceFolder}',
    --           remoteRoot = '.',
    --         },
    --       },
    --     },
    --   }
      
      -- 调试快捷键配置 (使用 <leader>d 前缀)
      local keymap = vim.keymap.set
      
      -- 基本调试操作
      keymap('n', '<leader>dc', function() dap.continue() end, { desc = '[D]ebug [C]ontinue' })
      keymap('n', '<leader>ds', function() dap.step_over() end, { desc = '[D]ebug [S]tep over' })
      keymap('n', '<leader>di', function() dap.step_into() end, { desc = '[D]ebug [I]nto' })
      keymap('n', '<leader>do', function() dap.step_out() end, { desc = '[D]ebug [O]ut' })
      keymap('n', '<leader>dt', function() dap.terminate() end, { desc = '[D]ebug [T]erminate' })
      
      -- 断点管理
      keymap('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = '[D]ebug [B]reakpoint' })
      keymap('n', '<leader>dB', function() 
        local condition = vim.fn.input('Breakpoint condition: ')
        if condition ~= '' then
          dap.set_breakpoint(condition)
        end
      end, { desc = '[D]ebug conditional [B]reakpoint' })
      keymap('n', '<leader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = '[D]ebug [L]og point' })
      
      -- UI 控制
      keymap('n', '<leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug [U]I toggle' })
      keymap('n', '<leader>de', function() require('dapui').eval() end, { desc = '[D]ebug [E]valuate' })
      keymap('v', '<leader>de', function() require('dapui').eval() end, { desc = '[D]ebug [E]valuate selection' })
      
      -- REPL 和重跑
      keymap('n', '<leader>dr', function() dap.repl.open() end, { desc = '[D]ebug [R]EPL' })
      keymap('n', '<leader>dR', function() dap.run_last() end, { desc = '[D]ebug [R]un last' })
      
      -- Python 特定功能
      keymap('n', '<leader>dpm', function() require('dap-python').test_method() end, { desc = '[D]ebug [P]ython [M]ethod' })
      keymap('n', '<leader>dpc', function() require('dap-python').test_class() end, { desc = '[D]ebug [P]ython [C]lass' })
      
      -- 设置调试图标
      vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointCondition', {text='◆', texthl='DapBreakpointCondition', linehl='', numhl=''})
      vim.fn.sign_define('DapLogPoint', {text='◉', texthl='DapLogPoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='▶', texthl='DapStopped', linehl='debugPC', numhl=''})
      vim.fn.sign_define('DapBreakpointRejected', {text='✖', texthl='DapBreakpointRejected', linehl='', numhl=''})
    end,
  },
}
