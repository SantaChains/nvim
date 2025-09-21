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
				-- 命令行最小关键字长度配置（智能判断）
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
			
			-- 新增：Alt+数字快速选择补全项（深度定制）
			["<A-1>"] = { function(cmp) cmp.accept({ index = 1 }) end },
			["<A-2>"] = { function(cmp) cmp.accept({ index = 2 }) end },
			["<A-3>"] = { function(cmp) cmp.accept({ index = 3 }) end },
			["<A-4>"] = { function(cmp) cmp.accept({ index = 4 }) end },
			["<A-5>"] = { function(cmp) cmp.accept({ index = 5 }) end },
			["<A-6>"] = { function(cmp) cmp.accept({ index = 6 }) end },
			["<A-7>"] = { function(cmp) cmp.accept({ index = 7 }) end },
			["<A-8>"] = { function(cmp) cmp.accept({ index = 8 }) end },
			["<A-9>"] = { function(cmp) cmp.accept({ index = 9 }) end },
			["<A-0>"] = { function(cmp) cmp.accept({ index = 10 }) end },
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
			-- 官方推荐的 fuzzy 匹配配置（已移至 list 部分）
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
				-- 新增：Emacs 行为模式（深度定制）
				-- 当没有输入内容时，Tab 键不会触发补全
				-- 新增：模糊匹配的精确匹配优先
				fuzzy = {
					use_typo_resistance = true, -- 启用拼写错误容错
					use_frecency = true,        -- 启用频率排序
					use_proximity = true,       -- 启用近似度加权
					-- 新增：精确匹配优先
					boost_exact_match = true,
				},
				-- 新增：精确匹配优先配置
				-- 总是将精确匹配置顶显示
				prefer_exact = true,
			},
			-- 新增：智能触发配置（深度定制）
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_accept_on_trigger_character = false,
				-- 性能优化：防止过于频繁的触发
				show_on_insert_on_trigger_character = false,
				show_in_snippet = true,
				-- 新增：最小关键字长度动态配置
				min_keyword_length = function(ctx)
					-- 在注释中需要更多字符才触发补全
					if ctx.treesitter_node_type == "comment" then
						return 3
					end
					-- 在字符串中也需要更多字符
					if ctx.treesitter_node_type == "string" then
						return 2
					end
					return 1 -- 默认最小长度
				end,
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
					-- 优化显示列：图标、索引和标签（支持 Alt+数字快速选择）
					columns = { { "kind_icon" }, { "item_idx" }, { "label", gap = 1 } },
					-- 组件配置：集成 colorful-menu 和深度自定义
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
					-- 新增：显示补全项索引（支持 Alt+数字快速选择）
					item_idx = {
						text = function(ctx)
							return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
						end,
						highlight = function(ctx)
							return ctx.is_selected and "BlinkCmpItemIdxCurrent" or "BlinkCmpItemIdx"
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
					-- 新增：从当前工作目录获取路径补全
				cwd = function()
					-- 优先使用 git 项目根目录
					local git_root = vim.fn.system("git rev-parse --show-toplevel 2>nul"):gsub("%s*", "")
					if git_root ~= "" and vim.fn.isdirectory(git_root) == 1 then
						return git_root
					end
					return vim.fn.getcwd()
				end,
				},
				buffer = { 
					score_offset = 3, -- 较低优先级
					max_items = 8,
					min_keyword_length = 3, -- 缓冲区补全需要更多字符触发
					-- 新增：从所有打开的缓冲区获取补全（跨缓冲区）
					get_bufnrs = function()
						local bufs = {}
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							-- 只包含已加载且有内容的缓冲区
							if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_lines(buf, 0, -1, false) then
								table.insert(bufs, buf)
							end
						end
						return bufs
					end,
				},
				snippets = { 
					score_offset = 1, -- 置底，不干扰 LSP（统一在此处配置优先级）
					max_items = 5,
					min_keyword_length = 2,
					-- 优化 snippet 行为（智能显示判断）
				should_show_items = function(ctx)
					-- 在注释中不显示 snippets
					if ctx.treesitter_node_type == "comment" then
						return false
					end
					-- 在字符串中不显示复杂 snippets
					if ctx.treesitter_node_type == "string" then
						return ctx.label:match("^[\"']") == nil
					end
					-- 在 shell 脚本中更严格的过滤
					if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" then
						return ctx.label:match("^[%$%`]") == nil
					end
					return true
				end,
				-- 新增：排除特定关键词（避免干扰）
				exclude_from_completion = function(ctx)
					-- 排除常见的常量关键词
					local excluded_keywords = {
						"true", "false", "null", "undefined",
						"const", "let", "var", "function",
						"if", "else", "for", "while", "return",
						"class", "interface", "extends", "implements",
						"public", "private", "protected", "static"
					}
					local label = ctx.label:lower()
					for _, keyword in ipairs(excluded_keywords) do
						if label == keyword then
							return true
						end
					end
					return false
				end,
				},
				-- AI 补全配置（如果启用）
				-- avante = {
				-- 	score_offset = 2, -- AI 补全优先级适中
				-- 	max_items = 3,
				-- 	min_keyword_length = 4,
				-- },
			},
				-- 优化的补全源配置
				transform_items = function(ctx, items)
					-- 限制总数量提高性能（根据记忆经验设置为25项）
					if #items > 25 then
						return vim.list_slice(items, 1, 25)
					end
					return items
				end,
				-- 新增：动态源选择（基于 treesitter 节点类型）
				-- 根据上下文动态调整补全源优先级
				dynamic_providers = function(ctx)
					-- 在字符串中优先使用 buffer 补全
					if ctx.treesitter_node_type == "string" then
						return { "buffer", "path", "lsp", "snippets" }
					end
					-- 在注释中优先使用 buffer 补全
					if ctx.treesitter_node_type == "comment" then
						return { "buffer", "snippets" }
					end
					-- 在 markdown 文件中调整优先级
					if vim.bo.filetype == "markdown" then
						return { "buffer", "path", "snippets", "lsp" }
					end
					-- 在配置文件中优先使用 lsp
					if vim.bo.filetype == "lua" or vim.bo.filetype == "vim" then
						return { "lsp", "snippets", "buffer", "path" }
					end
					-- 默认优先级
					return { "lsp", "path", "buffer", "snippets" }
				end,
		},
	},
	-- 扩展配置
	opts_extend = { "sources.default" },
	-- 新增：自定义高亮组定义
	config = function(_, opts)
		-- 定义自定义高亮组
		vim.api.nvim_set_hl(0, "BlinkCmpItemIdx", { fg = "#888888", italic = true })
		vim.api.nvim_set_hl(0, "BlinkCmpItemIdxCurrent", { fg = "#ff9e64", bold = true })
		
		-- 应用配置
		require("blink.cmp").setup(opts)
		
		-- 新增：自定义命令用于显示补全统计
		vim.api.nvim_create_user_command("CmpStats", function()
			local cmp = require("blink.cmp")
			local sources = cmp.get_sources()
			print("Blink.cmp 统计信息:")
			for name, source in pairs(sources) do
				print(string.format("  %s: %s", name, source.enabled and "启用" or "禁用"))
			end
		end, { desc = "显示补全统计信息" })
		
		-- 新增：自定义命令用于切换自动补全
		vim.api.nvim_create_user_command("CmpToggle", function()
			local enabled = require("blink.cmp").config.completion.menu.auto_show
			require("blink.cmp").config.completion.menu.auto_show = not enabled
			print("自动补全已" .. (enabled and "禁用" or "启用"))
		end, { desc = "切换自动补全" })
		
		-- 新增：自定义命令用于重新加载配置
		vim.api.nvim_create_user_command("CmpReload", function()
			require("blink.cmp").setup(opts)
			print("Blink.cmp 配置已重新加载")
		end, { desc = "重新加载补全配置" })
		
		-- 新增：自定义命令用于性能分析
		vim.api.nvim_create_user_command("CmpProfile", function()
			local start_time = vim.loop.hrtime()
			require("blink.cmp").show()
			local end_time = vim.loop.hrtime()
			print(string.format("补全显示耗时: %.2f ms", (end_time - start_time) / 1000000))
		end, { desc = "分析补全性能" })
	end,
}
