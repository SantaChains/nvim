return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      -- 基本配置
      default_file_explorer = true,
      columns = {
        "icon",
        "size",
        "mtime",
      },
      
      -- 键位映射
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
      
      -- 显示配置
      view_options = {
        show_hidden = true,  -- 显示隐藏文件
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".") or name == "node_modules"
        end,
        is_always_hidden = function(name, bufnr)
          return name == "node_modules" or name == ".git"
        end,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      
      -- 窗口配置
      window_options = {
        wrap = false,
        number = false,
        relativenumber = false,
      },
      
      -- 文件操作
      restore_win_options = true,
      skip_confirm_for_simple_edits = true,
      delete_to_trash = false,  -- Windows系统建议设为false
      trash_command = nil,
      
      -- 实验性功能
      experimental_watch_for_changes = true,
      
      -- 性能优化
      max_file_length = 10000,
      max_buffer_lines = 100000,
    },
    
    -- 依赖配置
    dependencies = { 
      { "nvim-mini/mini.icons", opts = {} } 
    },
    
    lazy = false,
    
    -- 额外的配置和键位映射
    config = function(_, opts)
      require("oil").setup(opts)
      
      -- 为Oil缓冲区添加特殊保护
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("OilConfig", { clear = true }),
        pattern = "oil",
        callback = function()
          -- 设置Oil窗口为固定大小
          vim.wo.winfixwidth = true
          vim.wo.winfixheight = true
          
          -- 禁用一些可能干扰的选项
          vim.wo.cursorline = false
          vim.wo.signcolumn = "no"
          
          -- 设置合适的缓冲区选项
          vim.bo.swapfile = false
          vim.bo.backup = false
          vim.bo.writebackup = false
          
          -- 添加Oil专用的快捷键
          local bufnr = vim.api.nvim_get_current_buf()
          local keymap_opts = { buffer = bufnr, silent = true }
          
          -- 快速退出
          vim.keymap.set("n", "q", "<cmd>OilClose<cr>", keymap_opts)
          
          -- 快速刷新
          vim.keymap.set("n", "r", "<cmd>OilRefresh<cr>", keymap_opts)
          
          -- 快速创建文件/目录
          vim.keymap.set("n", "n", function()
            vim.ui.input({ prompt = "新建文件名: " }, function(input)
              if input then
                vim.cmd("OilCreate " .. input)
              end
            end)
          end, keymap_opts)
          
          -- 快速删除
          vim.keymap.set("n", "d", function()
            local entry = require("oil").get_cursor_entry()
            if entry then
              vim.ui.input({
                prompt = string.format("确认删除 '%s'? (y/N): ", entry.name),
              }, function(input)
                if input and input:lower() == "y" then
                  vim.cmd("OilTrash")
                end
              end)
            end
          end, keymap_opts)
        end,
      })
    end,
  },
}