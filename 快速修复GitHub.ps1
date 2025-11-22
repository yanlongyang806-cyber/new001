# 快速修复 GitHub Actions 设置

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Actions 快速修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$currentDir = Get-Location
Write-Host "当前目录: $currentDir" -ForegroundColor Yellow

# 检查是否在正确的目录
if (-not (Test-Path "Core\GameServer\CoreGameServer.sln") -and -not (Test-Path "package\Core\GameServer\CoreGameServer.sln")) {
    Write-Host "错误: 请在 package 目录下运行此脚本！" -ForegroundColor Red
    exit 1
}

# 1. 确保 .github 目录存在
Write-Host "1. 检查 .github 目录..." -ForegroundColor Yellow
if (-not (Test-Path ".github")) {
    New-Item -ItemType Directory -Path ".github" -Force | Out-Null
    Write-Host "   ✓ 创建 .github 目录" -ForegroundColor Green
} else {
    Write-Host "   ✓ .github 目录已存在" -ForegroundColor Green
}

if (-not (Test-Path ".github\workflows")) {
    New-Item -ItemType Directory -Path ".github\workflows" -Force | Out-Null
    Write-Host "   ✓ 创建 .github\workflows 目录" -ForegroundColor Green
} else {
    Write-Host "   ✓ .github\workflows 目录已存在" -ForegroundColor Green
}

# 2. 检查工作流文件
Write-Host ""
Write-Host "2. 检查工作流文件..." -ForegroundColor Yellow
$workflowFile = ".github\workflows\build-gameserver.yml"
if (Test-Path $workflowFile) {
    Write-Host "   ✓ 工作流文件已存在" -ForegroundColor Green
} else {
    Write-Host "   ✗ 工作流文件不存在，这不应该发生！" -ForegroundColor Red
    Write-Host "   请确保文件已创建" -ForegroundColor Yellow
}

# 3. 初始化 Git（如果需要）
Write-Host ""
Write-Host "3. 检查 Git 仓库..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    Write-Host "   初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    Write-Host "   ✓ Git 仓库已初始化" -ForegroundColor Green
} else {
    Write-Host "   ✓ Git 仓库已存在" -ForegroundColor Green
}

# 4. 添加所有文件到 Git
Write-Host ""
Write-Host "4. 添加文件到 Git..." -ForegroundColor Yellow
git add .
$status = git status --porcelain
if ($status) {
    Write-Host "   以下文件将被提交:" -ForegroundColor Yellow
    git status --short | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
} else {
    Write-Host "   ⚠ 没有需要提交的文件（可能已经提交）" -ForegroundColor Yellow
}

# 5. 检查远程仓库
Write-Host ""
Write-Host "5. 检查远程仓库..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>&1
if ($remote -and $remote -notmatch "fatal") {
    Write-Host "   ✓ 远程仓库: $remote" -ForegroundColor Green
} else {
    Write-Host "   添加远程仓库..." -ForegroundColor Yellow
    git remote add origin https://github.com/yanlongyang806-cyber/new001.git
    Write-Host "   ✓ 远程仓库已添加" -ForegroundColor Green
}

# 6. 创建提交
Write-Host ""
Write-Host "6. 创建提交..." -ForegroundColor Yellow
$hasChanges = git diff --cached --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    git commit -m "配置 GitHub Actions 工作流"
    Write-Host "   ✓ 提交已创建" -ForegroundColor Green
} else {
    Write-Host "   ⚠ 没有需要提交的更改" -ForegroundColor Yellow
}

# 7. 设置分支
Write-Host ""
Write-Host "7. 设置主分支..." -ForegroundColor Yellow
git branch -M main
Write-Host "   ✓ 分支已设置为 main" -ForegroundColor Green

# 8. 显示推送命令
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "准备就绪！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "请运行以下命令推送到 GitHub:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "或者运行自动推送脚本:" -ForegroundColor Yellow
Write-Host "  .\push-to-github.ps1" -ForegroundColor White
Write-Host ""

