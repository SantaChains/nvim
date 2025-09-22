return {
	"saghen/blink.cmp",
	enabled = not vim.g.vscode, -- 在vscode-neovim禁用
	dependencies = {
		"xzbdmw/colorful-menu.nvim",
		"rafamadriz/friendly-snippets",
		-- "Kaiser-Yang/blink-cmp-avante", -- AI补全支持
	},
	-- 懒加载优化：仅在需要时加载
	event = { "InsertEnter", "CmdlineEnter" , "BufReadPost", "BufNewFile"}, 
	-- 版本设置 - 使用官方推荐的稳定版本
	version = '1.*',
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		cmdline = {
			enabled = true,
			keymap = { preset = 'cmdline' },
			sources = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == '/' or type == '?' then return { 'buffer' } end
				-- Commands
				if type == ':' or type == '@' then return { 'cmdline', 'buffer' } end
				return {}
			end,
			completion = {
				-- 不预选第一个项目，选中后自动插入该项目文本
				list = { selection = { preselect = false, auto_insert = true } },
				-- 自动显示补全窗口，仅在输入命令时显示菜单，而搜索或使用其他输入菜单时则不显示
				menu = { auto_show = true },
				-- 命令行模式禁用 ghost text（避免视觉干扰）
				ghost_text = { enabled = false },
			},
		},
		keymap = {
			-- 使用自定义键位映射，不使用预设
			preset = "none", -- 不使用官方预设，完全自定义
			-- 自定义键位映射（会覆盖预设中的相同键位）
			["<S-space>"] = { "show", "show_documentation", "hide_documentation" },
			-- fallback命令将运行下一个非闪烁键盘映射(回车键的默认换行等操作需要)
			["<CR>"] = { "fallback" }, -- 回车键直接执行命令，不选中补全
			["<S-Tab>"] = { "select_prev", "fallback" }, -- Shift+Tab向上选择
			["<Tab>"] = { "select_and_accept" }, -- Tab直接选择并应用第一个补全

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			-- 独立的snippet跳转键位，避免与Tab冲突
			["<C-j>"] = { "snippet_forward", "fallback" },
			["<C-k>"] = { "snippet_backward", "fallback" },
			
			-- ESC取消补全
			["<Esc>"] = { "hide", "fallback" },
			
			-- Alt+数字快速选择补全项
			["<A-1>"] = { function(cmp) cmp.accept({ index = 1 }) end },
			["<A-2>"] = { function(cmp) cmp.accept({ index = 2 }) end },
			["<A-3>"] = { function(cmp) cmp.accept({ index = 3 }) end },
			["<A-4>"] = { function(cmp) cmp.accept({ index = 4 }) end },
			["<A-5>"] = { function(cmp) cmp.accept({ index = 5 }) end },
			["<A-6>"] = { function(cmp) cmp.accept({ index = 6 }) end },
			["<A-7>"] = { function(cmp) cmp.accept({ index = 7 }) end },
			["<A-8>"] = { function(cmp) cmp.accept({ index = 8 }) end },
			["<A-9>"] = { function(cmp) cmp.accept({ index = 9 }) end },
			["<A-0>"] = { function(cmp) cmp.accept({ index = 10 }) end }
			
		},
		-- 签名帮助配置
		signature = {
			enabled = true,
			window = {
				border = "rounded",
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
			},
		},
		completion = {
			-- 示例：使用'prefix'对于'foo_|_bar'单词将匹配'foo_'(光标前面的部分),使用'full'将匹配'foo__bar'(整个单词)
			keyword = { range = "full" },
			-- 选择补全项目时显示文档(0秒延迟)
			documentation = { 
				auto_show = true, 
				auto_show_delay_ms = 0,
				window = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				},
			},
			-- 强制：LSP 文档优先，snippet 不自动插入
			list = { 
				selection = { preselect = false, auto_insert = false }, -- 不预选择，手动插入
				-- 最大显示数量优化
				max_items = 25,
				-- 显示微调优化
				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},
			-- 智能触发配置
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_accept_on_trigger_character = false,
				-- 性能优化：防止过于频繁的触发
				show_on_insert_on_trigger_character = false,
				show_in_snippet = false, -- 修复：在snippet中禁用自动触发避免冲突
				-- 自定义：不默认选择第一项
				selection_offset = 0,
			},
			-- 触发优化配置已移至 list 部分（避免重复）
			-- 菜单外观配置
			menu = {
				-- 窗口尺寸优化
				min_width = 25,
				max_height = 12,
				border = "rounded",
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				-- 自动显示优化
				auto_show = true,
				-- 绘制配置优化
				draw = {
					-- 优化显示列：图标和标签
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					treesitter = { "lsp" }, -- 仅对 LSP 结果使用 treesitter 高亮
				},
			},
			-- Ghost text 配置（仅在插入模式启用）
			ghost_text = {
				enabled = true, -- 插入模式启用 ghost text 提高体验
			},
	},
	-- Snippets 配置 - 使用默认预设支持 friendly-snippets
	snippets = {
		preset = 'default', -- 使用默认预设，支持 friendly-snippets
		-- LSP 提供的 snippets 配置
		expand = function(snippet) 
			-- 性能优化：添加错误处理避免崩溃
			local ok, err = pcall(vim.snippet.expand, snippet)
			if not ok then
				vim.notify("Snippet expansion failed: " .. tostring(err), vim.log.levels.WARN)
			end
		end,
		active = function(filter) 
			-- 性能优化：安全地检查snippet状态
			local ok, result = pcall(vim.snippet.active, filter)
			return ok and result or false
		end,
		jump = function(direction) 
			-- 性能优化：添加错误处理避免崩溃
			local ok, err = pcall(vim.snippet.jump, direction)
			if not ok then
				vim.notify("Snippet jump failed: " .. tostring(err), vim.log.levels.WARN)
			end
		end,
	},
		-- 模糊匹配配置
		fuzzy = {
			implementation = 'prefer_rust_with_warning', -- 使用Rust实现，性能更好
			max_typos = function(keyword) 
				-- 根据关键词长度动态设置最大容错字符数
				return math.floor(#keyword / 4) 
			end,
			use_frecency = true, -- 启用频率加权
			use_proximity = true, -- 启用邻近性加权
		},
		-- 指定文件类型启用/禁用（智能判断）
		enabled = function()
			-- 性能优化：在特定文件类型中禁用
			local disabled_filetypes = {
				"dashboard", -- Dashboard 页面
				"alpha", -- Alpha 页面
				"TelescopePrompt", -- Telescope 提示符
				"mason", -- Mason UI
				"lazy", -- Lazy UI
				"help", -- 帮助文档
				-- Windows 特定：在某些文件类型中禁用避免冲突
				"qf", -- quickfix 窗口
				"loclist", -- location list
			}
			
			-- 动态禁用：在大文件中禁用补全提高性能
			local bufnr = vim.api.nvim_get_current_buf()
			local line_count = vim.api.nvim_buf_line_count(bufnr)
			if line_count > 10000 then
				return false
			end
			
			-- Windows 特定：在 git bash 或 WSL 中禁用 shell 命令补全避免挂起
			if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!") then
				return false
			end
			
			return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype) 
				and vim.bo.buftype ~= "prompt" 
				and vim.b.completion ~= false
				and not vim.g.vscode -- 在 vscode-neovim 中禁用
		end,
		
		-- 优化的外观配置
		appearance = {
			-- 将后备高亮组设置为 nvim-cmp 的高亮组
			-- 当您的主题不支持blink.cmp 时很有用
			use_nvim_cmp_as_default = true,
			-- 将"Nerd Font Mono"设置为"mono"，将"Nerd Font"设置为"normal"
			-- 调整间距以确保图标对齐
			nerd_font_variant = "mono",
		},
	},
	-- 优化的补全源配置
	sources = {
		default = { 'lsp', 'path', 'buffer', 'snippets' }, -- 添加 snippets 支持 friendly-snippets
		-- 配置每个源的具体选项
		providers = {
			lsp = {
				name = 'LSP',
				module = 'blink.cmp.sources.lsp',
				opts = {},
				enabled = true,
				async = false,
				timeout_ms = 2000,
				min_keyword_length = 0,
				max_items = nil,
				score_offset = 0,
			},
			path = {
				name = 'Path',
				module = 'blink.cmp.sources.path',
				opts = {},
				enabled = true,
				min_keyword_length = 0,
			},

			buffer = {
				name = 'Buffer',
				module = 'blink.cmp.sources.buffer',
				opts = {},
				enabled = true,
				min_keyword_length = 0,
				max_items = 10,
				fallbacks = { 'lsp' }, -- 当 LSP 没有结果时回退到 buffer
			},
			snippets = {
				name = 'Snippets',
				module = 'blink.cmp.sources.snippets',
				score_offset = -1,
				opts = {
					friendly_snippets = true,
					search_paths = { vim.fn.stdpath('config') .. '/snippets' },
					global_snippets = { 'all' },
					extended_filetypes = {},
					ignored_filetypes = {},
					get_filetype = function(context)
						return vim.bo.filetype
					end,
					clipboard_register = nil
				}
			},
		},
		-- 最小关键字长度配置（智能判断）
		min_keyword_length = function(ctx)
			-- 当输入命令时，只有关键字长度为3个字符或更长时才显示
			if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
				return 3
			end
			-- 在 shell 命令中禁用补全（避免 Windows 下的挂起问题）
			if ctx.mode == "cmdline" and vim.fn.getcmdtype() == ":" and vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!") then
				return 999 --  effectively disable
			end
			return 0
		end,
		-- 优化的补全源配置
		transform_items = function(ctx, items)
			-- 为LSP源提供更多项目空间
			local max_items = 30
			if ctx.source_name == "lsp" then
				max_items = 50
			elseif #items > max_items then
				return vim.list_slice(items, 1, max_items)
			end
			return items
		end,
	},
	-- 扩展配置 - 允许在其他地方扩展 sources.default 而不重新定义整个配置
	-- 这个配置项允许你在其他配置文件中扩展默认的补全源，而不需要重新定义整个 sources 配置
	opts_extend = { "sources.default" },
	-- 自定义高亮组定义
	config = function(_, opts)
		-- 定义自定义高亮组
		vim.api.nvim_set_hl(0, "BlinkCmpItemIdx", { fg = "#888888", italic = true })
		vim.api.nvim_set_hl(0, "BlinkCmpItemIdxCurrent", { fg = "#ff9e64", bold = true })
		
		-- 应用配置
		require("blink.cmp").setup(opts)
	end,
}
