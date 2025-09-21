# readline
| 类别   | 默认键           | 内部命令名                                  | 作用简述              |
| ---- | ------------- | -------------------------------------- | ----------------- |
| 光标移动 | Ctrl-a        | beginning-of-line                      | 移到行首              |
| 光标移动 | Ctrl-e        | end-of-line                            | 移到行末              |
| 光标移动 | Ctrl-f        | forward-char                           | 前进一个字符            |
| 光标移动 | Ctrl-b        | backward-char                          | 后退一个字符            |
| 光标移动 | Alt-f         | forward-word                           | 前进一个单词            |
| 光标移动 | Alt-b         | backward-word                          | 后退一个单词            |
| 光标移动 | Ctrl-]        | character-search                       | 查找字符并跳到该处（正向）     |
| 光标移动 | Alt-Ctrl-]    | character-search-backward              | 查找字符并跳到该处（反向）     |
| 删除剪切 | Ctrl-d        | delete-char                            | 删除光标下字符；空行则 EOF   |
| 删除剪切 | Ctrl-h        | backward-delete-char                   | 退格删除前字符           |
| 删除剪切 | Ctrl-w        | unix-word-rubout                       | 剪切前一个单词（Unix 风格）  |
| 删除剪切 | Alt-d         | kill-word                              | 剪切光标后一个单词         |
| 删除剪切 | Ctrl-k        | kill-line                              | 剪切到行末             |
| 删除剪切 | Ctrl-u        | unix-line-discard                      | 剪切到行首             |
| 删除剪切 | Ctrl-t        | transpose-chars                        | 交换当前字符与前字符        |
| 删除剪切 | Alt-t         | transpose-words                        | 交换当前词与前一词         |
| 粘贴   | Ctrl-y        | yank                                   | 粘贴最后一次剪切内容        |
| 粘贴   | Alt-y         | yank-pop                               | 轮询剪切环（需先 Ctrl-y）  |
| 大小写  | Alt-u         | upcase-word                            | 光标后单词转大写          |
| 大小写  | Alt-l         | downcase-word                          | 光标后单词转小写          |
| 大小写  | Alt-c         | capitalize-word                        | 光标后单词首字母大写        |
| 历史   | Ctrl-p        | previous-history                       | 上一条历史             |
| 历史   | Ctrl-n        | next-history                           | 下一条历史             |
| 历史   | Alt-<         | beginning-of-history                   | 跳到历史第一条           |
| 历史   | Alt->         | end-of-history                         | 跳到历史最后一条          |
| 历史   | Ctrl-r        | reverse-search-history                 | 反向增量搜索            |
| 历史   | Ctrl-s        | forward-search-history                 | 正向增量搜索（若终端未屏蔽）    |
| 历史   | Alt-p         | non-incremental-reverse-search-history | 非增量反向搜索           |
| 历史   | Alt-n         | non-incremental-forward-search-history | 非增量正向搜索           |
| 历史   | Alt-.         | yank-last-arg                          | 粘贴上条命令最后一个参数      |
| 历史   | Alt-\_        | yank-last-arg                          | 同上                |
| 历史   | Ctrl-o        | operate-and-get-next                   | 执行当前行并取下一条历史      |
| 补全   | Tab           | complete                               | 标准补全              |
| 补全   | Alt-?         | possible-completions                   | 列出所有可能补全          |
| 补全   | Alt-\*        | insert-completions                     | 插入所有可能补全          |
| 补全   | Alt-/         | complete-filename                      | 文件名补全             |
| 补全   | Alt-~         | complete-username                      | 用户名补全             |
| 补全   | Alt-\$        | complete-variable                      | 变量补全              |
| 补全   | Alt-@         | complete-hostname                      | 主机名补全             |
| 补全   | Alt-!         | complete-command                       | 命令名补全             |
| 补全   | Ctrl-x /      | complete-filename                      | 文件名补全（Ctrl-x 子序列） |
| 补全   | Ctrl-x ~      | complete-username                      | 用户名补全（Ctrl-x 子序列） |
| 补全   | Ctrl-x \$     | complete-variable                      | 变量补全（Ctrl-x 子序列）  |
| 补全   | Ctrl-x @      | complete-hostname                      | 主机名补全（Ctrl-x 子序列） |
| 补全   | Ctrl-x !      | complete-command                       | 命令名补全（Ctrl-x 子序列） |
| 文本块  | Ctrl-x Ctrl-e | edit-and-execute-command               | 调用 \$EDITOR 编辑当前行 |
| 文本块  | Ctrl-xt       | exchange-point-and-mark                | 交换光标与标记           |
| 文本块  | Ctrl-x Ctrl-x | exchange-point-and-mark                | 同上                |
| 文本块  | Ctrl-x (      | start-kbd-macro                        | 开始录制键盘宏           |
| 文本块  | Ctrl-x )      | end-kbd-macro                          | 结束录制键盘宏           |
| 文本块  | Ctrl-x e      | call-last-kbd-macro                    | 执行最后一次键盘宏         |
| 杂项   | Ctrl-l        | clear-screen                           | 清屏并重绘             |
| 杂项   | Ctrl-v        | quoted-insert                          | 原样插入下一键           |
| 杂项   | Alt-v         | quoted-insert                          | 同上                |
| 杂项   | Ctrl-g        | abort                                  | 取消当前命令/搜索         |
| 杂项   | Ctrl-c        | abort                                  | 同上（中断）            |
| 杂项   | Ctrl-x Ctrl-r | re-read-init-file                      | 重新读取 ~/.inputrc   |
| 杂项   | Ctrl-x Ctrl-v | display-version                        | 显示 readline 版本    |
| 杂项   | Ctrl-x Ctrl-u | undo                                   | 撤销                |
| 杂项   | Ctrl-\_       | undo                                   | 撤销                |
| 杂项   | Alt-r         | revert-line                            | 撤销对本行的所有修改        |
| 杂项   | Alt-#         | insert-comment                         | 当前行前加 # 并提交       |
| 杂项   | Ctrl-m        | accept-line                            | 提交行（同回车）          |
| 杂项   | Ctrl-o        | accept-line-and-down-history           | 提交并下移历史           |
| 杂项   | Ctrl-j        | accept-line                            | 提交行（同回车）          |
| 杂项   | Ctrl-x Ctrl-g | glob-expand-word                       | 通配符展开并插入          |
| 杂项   | Ctrl-x \*     | glob-expand-word                       | 同上                |
| 杂项   | Ctrl-x &      | tilde-expand                           | 展开 ~ 用户名          |
| 杂项   | Ctrl-x Ctrl-d | dump-functions                         | 列出所有绑定函数          |
| 杂项   | Ctrl-x Ctrl-v | dump-variables                         | 列出所有 readline 变量  |
| 杂项   | Ctrl-x Ctrl-s | dump-macros                            | 列出所有键盘宏           |

----------------------------------------------------------
-- readline 全套映射（插入 + 命令行）
----------------------------------------------------------
local rl = {
  -- 光标移动
  ["<C-a>"] = "<Home>",
  ["<C-e>"] = "<End>",
  ["<C-f>"] = "<Right>",
  ["<C-b>"] = "<Left>",
  ["<M-f>"] = "<C-Right>",   -- 单词右
  ["<M-b>"] = "<C-Left>",    -- 单词左
  ["<C-p>"] = "<Up>",
  ["<C-n>"] = "<Down>",

  -- 删除
  ["<C-d>"] = "<Del>",
  ["<C-h>"] = "<BS>",
  ["<C-w>"] = "<C-o>db",     -- 删前一词
  ["<C-u>"] = "<C-o>d0",     -- 删到行首
  ["<C-k>"] = "<C-o>D",      -- 删到行末

  -- 历史
  ["<C-r>"] = "<C-o>q:",     -- 反向搜索（命令行已自带）
}

for key, cmd in pairs(rl) do
  vim.keymap.set('i', key, cmd, { remap = false })
  vim.keymap.set('c', key, cmd, { remap = false })
end
# 单键
## 常规表
| 区域 | 键位                 | 默认作用       |
| -- | ------------------ | ---------- |
| 移动 | `h j k l`          | 左下上右       |
| 移动 | `w W e E b B`      | 单词/WORD 前后 |
| 移动 | `f F t T ; ,`      | 行内查找       |
| 移动 | `0 ^ $ + - _`      | 行首行尾、上下行   |
| 移动 | `G gg`             | 文件尾/首      |
| 移动 | `H M L`            | 屏幕高/中/低行   |
| 移动 | `{ }`              | 段前后        |
| 移动 | `( )`              | 句前后        |
| 移动 | `%`                | 匹配括号       |
| 移动 | \`'' \`\`          | 上次跳转位置     |
| 滚动 | `Ctrl-b f d u y e` | 翻页/半页/一行   |
| 滚动 | `zz zt zb`         | 当前行居中/顶/底  |
| 标记 | \`m ' \`\`         | 设标记/跳标记    |
| 操作 | `x X p P`          | 删字符、粘贴     |
| 操作 | `d y c`            | 删、复制、改     |
| 操作 | `u Ctrl-r`         | 撤销/重做      |
| 操作 | `.`                | 重复上次修改     |
| 操作 | `~`                | 大小写切换      |
| 操作 | `>` `<`            | 缩进         |
| 操作 | `=`                | 自动缩进       |
| 操作 | `J`                | 合并行        |
| 操作 | `r`                | 替换字符       |
| 操作 | `s S`              | 替换字符/整行    |
| 操作 | `i a I A`          | 进入插入       |
| 操作 | `o O`              | 上下新行       |
| 操作 | `v V Ctrl-v`       | 可视/行/块     |
| 操作 | `R`                | 替换模式       |
| 搜索 | `/ ? n N`          | 搜索/下一个     |
| 搜索 | `*` `#`            | 光标单词前后搜索   |
| 窗口 | `Ctrl-w`           | 窗口前缀       |
| 其它 | `Z Z Q`            | 保存退出/强制退出  |
| 其它 | `:`                | 命令行        |
| 其它 | `!`                | 过滤         |
| 其它 | `@`                | 宏播放        |
| 其它 | `q`                | 宏录制        |
| 其它 | `&`                | 重复上次 `:s`  |
## 顺序表
| 键   | 默认功能                  |
| --- | --------------------- |
| `a` | 进入插入模式，光标后移 1 位       |
| `A` | 进入插入模式，移到行尾           |
| `b` | 跳到上一单词首               |
| `B` | 跳到上一 WORD 首           |
| `c` | 进入修改（change）运算符       |
| `C` | 修改到行末（=c\$）           |
| `d` | 进入删除（delete）运算符       |
| `D` | 删除到行末（=d\$）           |
| `e` | 跳到当前/下一单词尾            |
| `E` | 跳到当前/下一 WORD 尾        |
| `f` | 行内向右查找字符（等待输入）        |
| `F` | 行内向左查找字符（等待输入）        |
| `g` | 前缀键，需二次按键             |
| `G` | 跳到指定行（默认文件尾）          |
| `h` | 光标左移                  |
| `H` | 跳到屏幕最上行               |
| `i` | 进入插入模式，光标位置不变         |
| `I` | 进入插入模式，移到行首第一个非空字符    |
| `j` | 光标下移                  |
| `J` | 合并下一行到当前行             |
| `k` | 光标上移                  |
| `l` | 光标右移                  |
| `L` | 跳到屏幕最下行               |
| `m` | 设置标记（等待字母）            |
| `M` | 跳到屏幕中间行               |
| `n` | 重复上一次搜索，同方向           |
| `N` | 重复上一次搜索，反方向           |
| `o` | 在当前行下方新建空行并进入插入       |
| `O` | 在当前行上方新建空行并进入插入       |
| `p` | 在光标后粘贴寄存器内容           |
| `P` | 在光标前粘贴寄存器内容           |
| `q` | 开始/结束录制宏（等待寄存器名）      |
| `r` | 替换光标下字符（等待输入）         |
| `R` | 进入替换模式（覆盖写入）          |
| `s` | 删除光标下字符并进入插入          |
| `S` | 删除整行并进入插入             |
| `t` | 行内向右移动到字符前（等待输入）      |
| `T` | 行内向左移动到字符后（等待输入）      |
| `u` | 撤销最近一次修改              |
| `v` | 进入字符可视模式              |
| `V` | 进入行可视模式               |
| `w` | 跳到下一单词首               |
| `W` | 跳到下一 WORD 首           |
| `x` | 删除光标下字符               |
| `X` | 删除光标前字符               |
| `y` | 进入复制（yank）运算符         |
| `Y` | 复制整行（=yy）             |
| `z` | 前缀键，需二次按键（如 zz、zt、zb） |
# 
