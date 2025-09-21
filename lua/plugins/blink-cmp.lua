return {
	"saghen/blink.cmp",
	enabled = not vim.g.vscode, -- 在vscode-neovim禁用
	dependencies = {
		"xzbdmw/colorful-menu.nvim",
		"rafamadriz/friendly-snippets",
		-- "Kaiser-Yang/blink-cmp-avante", -- AI补全支持
	},
	-- 懒加载优化：仅在需要时加载
	event = { "InsertEnter", "CmdlineEnter" }, 
	version = nil, -- 使用最新版本获得最新功能
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		cmdline = {
			keymap = {
				-- 选择并接受预选择的第一个
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				-- 不预选第一个项目，选中后自动插入该项目文本
				list = { selection = { preselect = false, auto_insert = true } },
				-- 自动显示补全窗口，仅在输入命令时显示菜单，而搜索或使用其他输入菜单时则不显示
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
						-- enable for inputs as well, with:
						-- or vim.fn.getcmdtype() == '@'
					end,
				},
				-- 命令行模式禁用 ghost text（避免视觉干扰）
				ghost_text = { enabled = false },
				-- 命令行最小关键字长度配置
				min_keyword_length = function(ctx)
					-- when typing a command, only show when the keyword is 3 characters or longer
					if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
						return 3
					end
					return 0
				end,
			},
		},
		keymap = {
			-- 推荐使用官方预设，可选: "default", "super-tab", "enter", "none"
			preset = "default", -- 使用官方默认键位映射
			-- 自定义键位映射（会覆盖预设中的相同键位）
			["<S-space>"] = { "show", "show_documentation", "hide_documentation" },
			-- fallback命令将运行下一个非闪烁键盘映射(回车键的默认换行等操作需要)
			["<CR>"] = { "accept", "fallback" }, -- 更改成'select_and_accept'会选择第一项插入
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" }, -- 同时存在补全列表和snippet时，补全列表选择优先级更高

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			["<C-e>"] = { "snippet_forward", "select_next", "fallback" }, -- 同时存在补全列表和snippet时，snippet跳转优先级更高
			["<C-u>"] = { "snippet_backward", "select_prev", "fallback" },
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
			-- 官方推荐的 fuzzy 匹配配置
			fuzzy = {
				use_typo_resistance = true, -- 启用拼写错误容错
				use_frecency = true,        -- 启用频率排序
				use_proximity = true,       -- 启用近似度加权
			},
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
				selection = { preselect = false, auto_insert = false },
				-- 最大显示数量优化
				max_items = 15,
				-- 显示微调优化
				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},
			-- 触发优化（按照官方标准配置）
			trigger = {
				-- 自动显示补全的最小字符数
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_accept_on_trigger_character = false,
				-- 性能优化：防止过于频繁的触发
				show_on_insert_on_trigger_character = false,
				-- 官方推荐的性能参数
				show_in_snippet = true,
			},
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
					-- 优化显示列：只显示图标和标签
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					-- 组件配置：集成 colorful-menu
					components = {
						label = {
							text = function(ctx)
								local m = require("lib.safe_require").safe_require("colorful-menu")
								return m and m.blink_components_text(ctx) or ctx.label
							end,
							highlight = function(ctx)
								local m = require("lib.safe_require").safe_require("colorful-menu")
								return m and m.blink_components_highlight(ctx) or "BlinkCmpLabel"
							end,
						},
						kind_icon = {
							text = function(ctx)
								return ctx.kind_icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								return "BlinkCmpKind" .. ctx.kind
							end,
						},
					},
					treesitter = { "lsp" }, -- 仅对 LSP 结果使用 treesitter 高亮
				},
			},
			-- Ghost text 配置（仅在插入模式启用）
			ghost_text = {
				enabled = true, -- 插入模式启用 ghost text 提高体验
			},
		},
		-- 指定文件类型启用/禁用
		enabled = function()
			-- 性能优化：在特定文件类型中禁用
			return not vim.tbl_contains({
				"dashboard", -- Dashboard 页面
				"alpha", -- Alpha 页面
				"TelescopePrompt", -- Telescope 提示符
				"mason", -- Mason UI
				"lazy", -- Lazy UI
				"help", -- 帮助文档
				-- 可根据需要取消注释以在特定文件类型中禁用
				-- "lua",
				-- "markdown",
			}, vim.bo.filetype) 
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
		-- 优化的补全源配置
		sources = {
			default = {
				"lsp", -- 高优先级：语言服务器补全
				"path", -- 中优先级：路径补全
				"buffer", -- 低优先级：缓冲区补全
				"snippets", -- 启用 snippets，但优先级最低
				-- "avante", -- AI 补全（可选）
				-- "glm4", -- GLM-4 AI 补全源（可选）
			},
			providers = {
				-- score_offset 设置优先级：数字越大优先级越高
				lsp = { 
					score_offset = 10, -- 置顶，最高优先级
					-- 性能优化参数修正
					max_items = 20,
					min_keyword_length = 1,
				},
				path = { 
					score_offset = 5, -- 中等优先级
					max_items = 10,
					min_keyword_length = 2,
				},
				buffer = { 
					score_offset = 3, -- 较低优先级
					max_items = 8,
					min_keyword_length = 3, -- 缓冲区补全需要更多字符触发
				},
				snippets = { 
					score_offset = 1, -- 置底，不干扰 LSP（统一在此处配置优先级）
					max_items = 5,
					min_keyword_length = 2,
					-- 优化 snippet 行为
					should_show_items = function(ctx)
						-- 在注释中不显示 snippets（增加错误处理）
						return not vim.tbl_contains({"comment"}, ctx.treesitter_node_type or "")
					end,
				},
				-- AI 补全配置（如果启用）
				-- avante = {
				-- 	score_offset = 2, -- AI 补全优先级适中
				-- 	max_items = 3,
				-- 	min_keyword_length = 4,
				-- },
			},
			-- 性能优化：按需加载高级源（遵循最佳实践）
			transform_items = function(ctx, items)
				-- 限制总数量提高性能（根据记忆经验设置为25项）
				if #items > 25 then
					return vim.list_slice(items, 1, 25)
				end
				return items
			end,
		},
	},
	-- 扩展配置
	opts_extend = { "sources.default" },
}
