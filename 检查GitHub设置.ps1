# 检查 GitHub Actions 设置脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Actions 设置检查" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查工作流文件
Write-Host "1. 检查工作流文件..." -ForegroundColor Yellow
$workflowPath = ".github\workflows\build-gameserver.yml"
if (Test-Path $workflowPath) {
    Write-Host "   ✓ 工作流文件存在: $workflowPath" -ForegroundColor Green
    $content = Get-Content $workflowPath -Raw
    if ($content -match "name:") {
        Write-Host "   ✓ 工作流文件格式正确" -ForegroundColor Green
    } else {
        Write-Host "   ✗ 工作流文件格式可能有问题" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ 工作流文件不存在！" -ForegroundColor Red
    Write-Host "   请确保文件位于: $workflowPath" -ForegroundColor Yellow
}

Write-Host ""

# 2. 检查解决方案文件
Write-Host "2. 检查解决方案文件..." -ForegroundColor Yellow
$slnPaths = @(
    "Core\GameServer\CoreGameServer.sln",
    "package\Core\GameServer\CoreGameServer.sln"
)

$foundSln = $false
foreach ($path in $slnPaths) {
    if (Test-Path $path) {
        Write-Host "   ✓ 找到解决方案: $path" -ForegroundColor Green
        $foundSln = $true
        break
    }
}

if (-not $foundSln) {
    Write-Host "   ✗ 未找到解决方案文件！" -ForegroundColor Red
    Write-Host "   正在搜索..." -ForegroundColor Yellow
    $allSln = Get-ChildItem -Recurse -Filter "CoreGameServer.sln" -ErrorAction SilentlyContinue
    if ($allSln) {
        Write-Host "   找到的解决方案文件:" -ForegroundColor Yellow
        $allSln | ForEach-Object { Write-Host "     $($_.FullName)" }
    }
}

Write-Host ""

# 3. 检查 Git 状态
Write-Host "3. 检查 Git 状态..." -ForegroundColor Yellow
if (Test-Path .git) {
    Write-Host "   ✓ Git 仓库已初始化" -ForegroundColor Green
    
    # 检查工作流文件是否在 Git 中
    $gitStatus = git status --porcelain .github\workflows\build-gameserver.yml 2>&1
    if ($gitStatus -match "\.github") {
        Write-Host "   ⚠ 工作流文件有未提交的更改" -ForegroundColor Yellow
    } else {
        $gitLs = git ls-files .github\workflows\build-gameserver.yml 2>&1
        if ($gitLs) {
            Write-Host "   ✓ 工作流文件已在 Git 中" -ForegroundColor Green
        } else {
            Write-Host "   ✗ 工作流文件未添加到 Git！" -ForegroundColor Red
            Write-Host "   请运行: git add .github\workflows\build-gameserver.yml" -ForegroundColor Yellow
        }
    }
    
    # 检查远程仓库
    $remote = git remote get-url origin 2>&1
    if ($remote -and $remote -notmatch "fatal") {
        Write-Host "   ✓ 远程仓库: $remote" -ForegroundColor Green
    } else {
        Write-Host "   ✗ 未配置远程仓库！" -ForegroundColor Red
        Write-Host "   请运行: git remote add origin https://github.com/yanlongyang806-cyber/new001.git" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ✗ Git 仓库未初始化！" -ForegroundColor Red
    Write-Host "   请运行: git init" -ForegroundColor Yellow
}

Write-Host ""

# 4. 检查目录结构
Write-Host "4. 检查目录结构..." -ForegroundColor Yellow
Write-Host "   当前目录: $(Get-Location)" -ForegroundColor Gray
Write-Host "   根目录内容:" -ForegroundColor Gray
Get-ChildItem | Select-Object Name, PSIsContainer | Format-Table -AutoSize

Write-Host ""

# 5. 提供修复建议
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复建议" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$issues = @()

if (-not (Test-Path $workflowPath)) {
    $issues += "工作流文件不存在"
}

if (-not $foundSln) {
    $issues += "解决方案文件未找到"
}

if (-not (Test-Path .git)) {
    $issues += "Git 仓库未初始化"
}

if ($issues.Count -eq 0) {
    Write-Host "✓ 所有检查通过！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步操作：" -ForegroundColor Cyan
    Write-Host "1. 确保所有文件已提交: git add ." -ForegroundColor White
    Write-Host "2. 提交更改: git commit -m 'Add GitHub Actions workflow'" -ForegroundColor White
    Write-Host "3. 推送到 GitHub: git push origin main" -ForegroundColor White
    Write-Host "4. 在 GitHub 上查看 Actions 标签页" -ForegroundColor White
} else {
    Write-Host "发现以下问题：" -ForegroundColor Yellow
    $issues | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

Write-Host ""

