@echo off
REM ========================================
REM GitHub Self-Hosted Runner 自动化安装脚本
REM ========================================

echo ========================================
echo GitHub Self-Hosted Runner 安装脚本
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [警告] 建议以管理员权限运行此脚本
    echo.
)

REM 设置仓库信息
set REPO_URL=https://github.com/yanlongyang806-cyber/new001
set RUNNER_VERSION=2.329.0

echo [1/5] 创建 runner 目录...
if exist "actions-runner" (
    echo [警告] actions-runner 目录已存在
    set /p OVERWRITE="是否删除并重新安装? (Y/N): "
    if /i "%OVERWRITE%"=="Y" (
        rmdir /s /q actions-runner
    ) else (
        echo 安装已取消
        pause
        exit /b 1
    )
)

mkdir actions-runner 2>nul
cd actions-runner

echo [成功] 目录已创建
echo.

echo [2/5] 下载 GitHub Runner...
echo 正在下载 runner v%RUNNER_VERSION%...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/actions/runner/releases/download/v%RUNNER_VERSION%/actions-runner-win-x64-%RUNNER_VERSION%.zip' -OutFile 'actions-runner-win-x64.zip'"

if not exist "actions-runner-win-x64.zip" (
    echo [错误] 下载失败，请检查网络连接
    pause
    exit /b 1
)

echo [成功] 下载完成
echo.

echo [3/5] 解压文件...
powershell -Command "Expand-Archive -Path 'actions-runner-win-x64.zip' -DestinationPath '.' -Force"
del actions-runner-win-x64.zip

echo [成功] 解压完成
echo.

echo [4/5] 配置 Runner...
echo.
echo ========================================
echo 重要：请按照以下步骤操作
echo ========================================
echo.
echo 1. 访问: %REPO_URL%/settings/actions/runners
echo 2. 点击 "New self-hosted runner"
echo 3. 选择 Windows x64
echo 4. 复制显示的配置命令（包含 URL 和 TOKEN）
echo.
echo 配置命令格式类似：
echo   .\config.cmd --url %REPO_URL% --token YOUR_TOKEN
echo.
set /p CONFIG_CMD="请粘贴完整的配置命令（或按 Enter 跳过手动配置）: "

if not "%CONFIG_CMD%"=="" (
    echo.
    echo 正在执行配置命令...
    %CONFIG_CMD%
    
    if errorlevel 1 (
        echo [错误] 配置失败，请检查 URL 和 TOKEN 是否正确
        pause
        exit /b 1
    )
    
    echo [成功] Runner 配置完成
) else (
    echo.
    echo [提示] 请手动运行配置命令：
    echo   .\config.cmd --url %REPO_URL% --token YOUR_TOKEN
    echo.
)

echo.
echo [5/5] 启动 Runner...
echo.
echo ========================================
echo Runner 安装完成！
echo ========================================
echo.
echo 下一步：
echo   1. 如果已配置，运行: .\run.cmd
echo   2. 如果未配置，先运行配置命令，然后运行: .\run.cmd
echo.
echo 看到 "√ Connected to GitHub" 表示连接成功
echo.
echo 按任意键退出...
pause >nul

