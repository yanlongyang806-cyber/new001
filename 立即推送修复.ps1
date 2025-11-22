# 立即推送修复脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "推送修复到 GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# 1. 检查工作流文件
Write-Host "1. 检查工作流文件..." -ForegroundColor Yellow
if (Test-Path ".github\workflows\build-gameserver.yml") {
    Write-Host "   ✓ 工作流文件存在" -ForegroundColor Green
} else {
    Write-Host "   ✗ 工作流文件不存在！" -ForegroundColor Red
    exit 1
}

# 2. 检查解决方案文件
Write-Host ""
Write-Host "2. 检查解决方案文件..." -ForegroundColor Yellow
$slnPath = "Core\GameServer\CoreGameServer.sln"
if (Test-Path $slnPath) {
    Write-Host "   ✓ 解决方案文件存在: $slnPath" -ForegroundColor Green
    
    # 检查是否在 Git 中
    $inGit = git ls-files $slnPath 2>&1
    if ($inGit -and $inGit -notmatch "fatal") {
        Write-Host "   ✓ 文件已在 Git 中" -ForegroundColor Green
    } else {
        Write-Host "   ⚠ 文件未添加到 Git，正在添加..." -ForegroundColor Yellow
        git add $slnPath
    }
} else {
    Write-Host "   ✗ 解决方案文件不存在: $slnPath" -ForegroundColor Red
    Write-Host "   正在搜索..." -ForegroundColor Yellow
    $found = Get-ChildItem -Recurse -Filter "CoreGameServer.sln" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        Write-Host "   ✓ 找到文件: $($found.FullName)" -ForegroundColor Green
        $relPath = $found.FullName.Replace((Get-Location).Path + "\", "")
        git add $relPath
    } else {
        Write-Host "   ✗ 未找到解决方案文件！" -ForegroundColor Red
        exit 1
    }
}

# 3. 添加所有更改
Write-Host ""
Write-Host "3. 添加所有更改..." -ForegroundColor Yellow
git add .
$status = git status --short
if ($status) {
    Write-Host "   以下文件将被提交:" -ForegroundColor Yellow
    git status --short | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
} else {
    Write-Host "   ⚠ 没有需要提交的文件" -ForegroundColor Yellow
}

# 4. 提交
Write-Host ""
Write-Host "4. 创建提交..." -ForegroundColor Yellow
$hasChanges = git diff --cached --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    git commit -m "修复：改进路径检测，优先使用递归搜索查找解决方案文件"
    Write-Host "   ✓ 提交已创建" -ForegroundColor Green
} else {
    Write-Host "   ⚠ 没有需要提交的更改" -ForegroundColor Yellow
}

# 5. 推送
Write-Host ""
Write-Host "5. 推送到 GitHub..." -ForegroundColor Yellow
Write-Host "   目标: https://github.com/yanlongyang806-cyber/new001.git" -ForegroundColor Cyan
Write-Host ""
$confirm = Read-Host "确认推送? (Y/N)"

if ($confirm -eq "Y" -or $confirm -eq "y") {
    git push origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✓ 推送成功！" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "下一步：" -ForegroundColor Cyan
        Write-Host "1. 访问 https://github.com/yanlongyang806-cyber/new001/actions" -ForegroundColor White
        Write-Host "2. 查看新的工作流运行" -ForegroundColor White
        Write-Host "3. 查看 '调试 - 显示目录结构' 步骤的输出" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "✗ 推送失败" -ForegroundColor Red
        Write-Host "请检查网络连接和 GitHub 认证" -ForegroundColor Yellow
    }
} else {
    Write-Host "已取消推送" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "您可以稍后手动运行: git push origin main" -ForegroundColor Cyan
}

Write-Host ""

