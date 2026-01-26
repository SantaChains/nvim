-- ShaDa 文件问题修复配置
-- 解决 E138: All .shada.tmp.X files exist 错误

local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd

-- 创建 ShaDa 修复组
local shada_fix_group = augroup("ShadaFix", { clear = true })

-- 启动时清理 ShaDa 临时文件
autocmd("VimEnter", {
    group = shada_fix_group,
    desc = "清理 ShaDa 临时文件",
    callback = function()
        local shada_dir = vim.fn.stdpath('data') .. '/shada'
        local tmp_files = vim.fn.glob(shada_dir .. '/main.shada.tmp.*', false, true)
        
        for _, file in ipairs(tmp_files) do
            local ok, err = pcall(vim.fn.delete, file)
            if ok then
                vim.notify("已删除 ShaDa 临时文件: " .. vim.fn.fnamemodify(file, ':t'), vim.log.levels.DEBUG)
            end
        end
        
        -- 如果存在大量临时文件，显示警告
        if #tmp_files > 5 then
            vim.notify("已清理 " .. #tmp_files .. " 个 ShaDa 临时文件", vim.log.levels.WARN)
        end
    end,
})

-- 配置 ShaDa 选项以避免频繁写入
vim.opt.shada = {
    "!",        -- 保存全局变量
    "'100",     -- 保存最多100个文件的位置信息
    "\"50",     -- 保存最多50行的寄存器内容
    "<50",      -- 保存最多50行的命令行历史
    "s10",      -- 最大项目大小10KB
    "h",        -- 禁用高亮搜索历史
}

-- 减少 ShaDa 写入频率
vim.opt.shadafile = ""  -- 使用默认路径

-- 退出时确保 ShaDa 文件正确关闭
autocmd("VimLeavePre", {
    group = shada_fix_group,
    desc = "确保 ShaDa 文件正确关闭",
    callback = function()
        -- 强制写入 ShaDa 文件
        pcall(vim.cmd, "wshada!")
    end,
})

-- 定期清理 ShaDa 临时文件（每天一次）
autocmd("VimEnter", {
    group = shada_fix_group,
    pattern = "*",
    callback = function()
        local last_clean_file = vim.fn.stdpath('data') .. '/.shada_last_clean'
        local current_time = os.time()
        
        -- 检查上次清理时间
        local last_clean = 0
        if vim.fn.filereadable(last_clean_file) == 1 then
            local content = vim.fn.readfile(last_clean_file)
            if #content > 0 then
                last_clean = tonumber(content[1]) or 0
            end
        end
        
        -- 如果超过24小时，进行清理
        if current_time - last_clean > 86400 then
            local shada_dir = vim.fn.stdpath('data') .. '/shada'
            local tmp_files = vim.fn.glob(shada_dir .. '/main.shada.tmp.*', false, true)
            
            for _, file in ipairs(tmp_files) do
                pcall(vim.fn.delete, file)
            end
            
            -- 记录清理时间
            vim.fn.writefile({tostring(current_time)}, last_clean_file)
            
            if #tmp_files > 0 then
                vim.notify("定期清理: 已删除 " .. #tmp_files .. " 个 ShaDa 临时文件", vim.log.levels.INFO)
            end
        end
    end,
})