# 推送工具集修复脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "推送工具集修复到 GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

Write-Host "修复内容：" -ForegroundColor Yellow
Write-Host "  - 强制使用 VS2022 工具集 (v143)" -ForegroundColor White
Write-Host "  - 设置 WindowsTargetPlatformVersion=10.0" -ForegroundColor White
Write-Host "  - 设置 PlatformToolsetVersion=143" -ForegroundColor White
Write-Host ""

# 检查工作流文件
if (-not (Test-Path ".github\workflows\build-gameserver.yml")) {
    Write-Host "✗ 工作流文件不存在！" -ForegroundColor Red
    exit 1
}

# 添加并提交
Write-Host "添加文件..." -ForegroundColor Yellow
git add .github\workflows\build-gameserver.yml

Write-Host "创建提交..." -ForegroundColor Yellow
git commit -m "修复：强制使用 VS2022 工具集 (v143) 以兼容 GitHub Actions"

Write-Host ""
Write-Host "准备推送到 GitHub..." -ForegroundColor Yellow
Write-Host "目标: https://github.com/yanlongyang806-cyber/new001.git" -ForegroundColor Cyan
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
        Write-Host "2. 等待新的工作流运行完成" -ForegroundColor White
        Write-Host "3. 查看编译结果" -ForegroundColor White
        Write-Host ""
        Write-Host "预期结果：" -ForegroundColor Cyan
        Write-Host "  - 不再出现 'v100 build tools cannot be found' 错误" -ForegroundColor White
        Write-Host "  - 使用 VS2022 工具集成功编译" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "✗ 推送失败" -ForegroundColor Red
    }
} else {
    Write-Host "已取消推送" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "您可以稍后手动运行: git push origin main" -ForegroundColor Cyan
}

Write-Host ""

