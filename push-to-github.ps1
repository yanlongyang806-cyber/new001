# GameServer 推送到 GitHub 脚本
# 目标仓库: https://github.com/yanlongyang806-cyber/new001

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GameServer 推送到 GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在正确的目录
if (-not (Test-Path "Core\GameServer\CoreGameServer.sln")) {
    Write-Host "错误: 请在 package 目录下运行此脚本！" -ForegroundColor Red
    Write-Host "当前目录: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "当前目录: $(Get-Location)" -ForegroundColor Green
Write-Host ""

# 检查 Git 是否已安装
try {
    $gitVersion = git --version
    Write-Host "✓ Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ 错误: Git 未安装或不在 PATH 中" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 步骤 1: 初始化 Git 仓库
if (-not (Test-Path ".git")) {
    Write-Host "步骤 1: 初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ 初始化失败" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Git 仓库已初始化" -ForegroundColor Green
} else {
    Write-Host "✓ Git 仓库已存在" -ForegroundColor Green
}

Write-Host ""

# 步骤 2: 检查远程仓库
Write-Host "步骤 2: 检查远程仓库配置..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>$null

if ($remote) {
    Write-Host "当前远程仓库: $remote" -ForegroundColor Cyan
    $update = Read-Host "是否更新为 https://github.com/yanlongyang806-cyber/new001.git? (Y/N)"
    if ($update -eq "Y" -or $update -eq "y") {
        git remote set-url origin https://github.com/yanlongyang806-cyber/new001.git
        Write-Host "✓ 远程仓库已更新" -ForegroundColor Green
    }
} else {
    Write-Host "添加远程仓库..." -ForegroundColor Yellow
    git remote add origin https://github.com/yanlongyang806-cyber/new001.git
    Write-Host "✓ 远程仓库已添加" -ForegroundColor Green
}

Write-Host ""

# 步骤 3: 检查文件大小
Write-Host "步骤 3: 检查大文件..." -ForegroundColor Yellow
$largeFiles = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue | 
    Where-Object { $_.Length -gt 50MB } | 
    Select-Object FullName, @{Name="Size(MB)";Expression={[math]::Round($_.Length/1MB,2)}}

if ($largeFiles) {
    Write-Host "⚠ 发现大文件 (>50MB):" -ForegroundColor Yellow
    $largeFiles | Format-Table -AutoSize
    $continue = Read-Host "是否继续? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-Host "已取消" -ForegroundColor Yellow
        exit 0
    }
} else {
    Write-Host "✓ 未发现超大文件" -ForegroundColor Green
}

Write-Host ""

# 步骤 4: 添加文件
Write-Host "步骤 4: 添加文件到 Git..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 添加文件失败" -ForegroundColor Red
    exit 1
}

$fileCount = (git status --short | Measure-Object -Line).Lines
Write-Host "✓ 已添加 $fileCount 个文件/更改" -ForegroundColor Green

Write-Host ""

# 步骤 5: 创建提交
Write-Host "步骤 5: 创建提交..." -ForegroundColor Yellow
$commitMessage = "Initial commit: GameServer build package with GitHub Actions"
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 提交失败" -ForegroundColor Red
    Write-Host "提示: 可能没有更改需要提交" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ 提交已创建" -ForegroundColor Green

Write-Host ""

# 步骤 6: 设置分支
Write-Host "步骤 6: 设置主分支..." -ForegroundColor Yellow
git branch -M main
Write-Host "✓ 分支已设置为 main" -ForegroundColor Green

Write-Host ""

# 步骤 7: 推送到 GitHub
Write-Host "步骤 7: 推送到 GitHub..." -ForegroundColor Yellow
Write-Host "目标仓库: https://github.com/yanlongyang806-cyber/new001.git" -ForegroundColor Cyan
Write-Host ""
$confirm = Read-Host "确认推送到 GitHub? (Y/N)"

if ($confirm -eq "Y" -or $confirm -eq "y") {
    Write-Host "正在推送..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✓ 推送成功！" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "下一步:" -ForegroundColor Cyan
        Write-Host "1. 访问 https://github.com/yanlongyang806-cyber/new001" -ForegroundColor White
        Write-Host "2. 点击 'Actions' 标签查看编译状态" -ForegroundColor White
        Write-Host "3. 等待编译完成（约 15-30 分钟）" -ForegroundColor White
        Write-Host "4. 下载编译好的 GameServer.exe" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "✗ 推送失败" -ForegroundColor Red
        Write-Host ""
        Write-Host "可能的原因:" -ForegroundColor Yellow
        Write-Host "1. 需要 GitHub 认证（用户名和密码/Token）" -ForegroundColor White
        Write-Host "2. 网络连接问题" -ForegroundColor White
        Write-Host "3. 权限问题" -ForegroundColor White
        Write-Host ""
        Write-Host "解决方案:" -ForegroundColor Yellow
        Write-Host "1. 使用 GitHub Personal Access Token 代替密码" -ForegroundColor White
        Write-Host "2. 或使用 SSH 方式: git remote set-url origin git@github.com:yanlongyang806-cyber/new001.git" -ForegroundColor White
    }
} else {
    Write-Host "已取消推送" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "您可以稍后手动执行:" -ForegroundColor Cyan
    Write-Host "  git push -u origin main" -ForegroundColor White
}

Write-Host ""

