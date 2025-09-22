-- =============================================================================
-- Shell/Bash 代码片段集合
-- =============================================================================
-- 提供Shell脚本开发中常用的代码模板，包括：
-- - 基础语法结构
-- - 条件判断和循环
-- - 函数定义
-- - 文件操作
-- - 字符串处理
-- - 系统命令
-- - 错误处理
-- - 实用工具
-- =============================================================================

local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

ls.add_snippets('sh', {
  -- 基础语法结构
  s('shebang', t('#!/bin/bash\n\n')),
  s('comment', fmt('# {}', { i(1, '注释内容') })),
  
  -- 参数处理
  s('arg1', t('if [ ! $# -gt 0 ]; then\n  echo "No argument provided"\n  exit 1\nfi\n')),
  
  s('arg_check', fmt('if [ $# -ne {} ]; then\n    echo "Usage: $0 {}"\n    exit 1\nfi\n', { 
    i(1, 'num_args'), 
    i(2, 'arg1 arg2 ...') 
  })),
  
  s('arg_parse', t('while [[ $# -gt 0 ]]; do\n    case $1 in\n        -o|--option)\n            OPTION="$2"\n            shift 2\n            ;;\n        -h|--help)\n            echo "Usage: $0 [OPTIONS]"\n            echo "Options:"\n            echo "  -o, --option     Description"\n            echo "  -h, --help    Show this help message"\n            exit 0\n            ;;\n        *)\n            echo "Unknown option: $1"\n            exit 1\n            ;;\n    esac\ndone\n')),
  
  -- 输出和调试
  s('echo', fmt('echo "{}"', { i(1, 'message') })),
  s('error', fmt('echo "Error: {}" >&2', { i(1, 'error message') })),
  
  s('echo_color', fmt('echo -e "\\033[{}m{}\\033[0m"', { 
    c(1, { t('31'), t('32'), t('33'), t('34'), t('35'), t('36') }), 
    i(2, 'message') 
  })),
  
  s('log_function', t('log() {\n    local level="$1"\n    shift\n    local message="$*"\n    local timestamp=$(date \'+%%Y-%%m-%%d %%H:%%M:%%S\')\n    echo "[$timestamp] [$level] $message"\n}\n\nlog_info() { log "INFO" "$@"; }\nlog_warn() { log "WARN" "$@"; }\nlog_error() { log "ERROR" "$@"; }\n')),
  
  -- 文件操作
  s('file_exists', fmt('if [ -f "{}" ]; then\n    echo "File exists"\nelse\n    echo "File does not exist"\nfi\n', { i(1, 'file_path') })),
  s('dir_exists', fmt('if [ -d "{}" ]; then\n    echo "Directory exists"\nelse\n    echo "Directory does not exist"\nfi\n', { i(1, 'dir_path') })),
  s('read_file', fmt('while IFS= read -r line; do\n    echo "$line"\ndone < "{}"\n', { i(1, 'file_path') })),
  s('write_file', fmt('cat > "{}" << \'EOF\'\n{}\nEOF\n', { i(1, 'file_path'), i(2, 'content') })),
  
  -- 系统操作
  s('command_exists', fmt('if command -v {} >/dev/null 2>&1; then\n    echo "{} is installed"\nelse\n    echo "{} is not installed"\nfi\n', { i(1, 'command'), rep(1), rep(1) })),
  s('sys_info', t('echo "OS: $(uname -s)"\necho "Kernel: $(uname -r)"\necho "Architecture: $(uname -m)"\necho "Hostname: $(hostname)"\necho "Uptime: $(uptime -p)"\n')),
  s('memory_usage', t('free -h | awk \'/^Mem:/ {print $3 "/" $2}\'')),
  s('disk_usage', fmt('df -h {} | tail -1 | awk \'{{print $5}}\'', { i(1, '/') })),
  
  -- 网络操作
  s('check_network', fmt('if ping -c 1 {} >/dev/null 2>&1; then\n    echo "Network is reachable"\nelse\n    echo "Network is unreachable"\nfi\n', { i(1, 'google.com') })),
  s('download', fmt('curl -O {}', { i(1, 'url') })),
  s('http_request', fmt('curl -X {} -H "Content-Type: application/json" -d \'{}\' {}', { i(1, 'GET'), i(2, '{}'), i(3, 'url') })),
  
  -- 错误处理
  s('error_handler', t('handle_error() {\n    local exit_code=$1\n    local error_message=$2\n    \n    if [ $exit_code -ne 0 ]; then\n        echo "Error: $error_message" >&2\n        exit $exit_code\n    fi\n}\n')),
  s('set_error_trap', t('set -e  # 遇到错误时退出\nset -u  # 使用未定义变量时报错\nset -o pipefail  # 管道命令中任何一步失败都退出\n\ntrap \'echo "Error on line $LINENO" >&2; exit 1\' ERR\n')),
  
  -- 实用工具
  s('sleep', fmt('sleep {}', { i(1, '1') })),
  s('random', fmt('echo $((RANDOM % {} + {}))', { i(1, '100'), i(2, '1') })),
  s('date_time', fmt('date "+{}"', { i(1, '%Y-%m-%d %H:%M:%S') })),
  s('read_input', fmt('read -p "{}" {}\necho "You entered: ${}"\n', { i(1, 'Enter input: '), i(2, 'input'), rep(2) })),
  s('read_password', fmt('read -s -p "{}" {}\necho\n', { i(1, 'Enter password: '), i(2, 'password') })),
  
  -- macOS通知
  s('notification', fmt('osascript -e \'display notification "{}" with title "{}"\'', { i(2), i(1) })),
})
