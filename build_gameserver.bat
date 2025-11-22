@echo off
REM ========================================
REM GameServer 本地编译脚本
REM 自动设置环境变量并调用 MSBuild
REM ========================================

echo ========================================
echo GameServer 本地编译脚本
echo ========================================
echo.

REM 查找 Visual Studio 安装路径
set VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist %VSWHERE% (
    echo [错误] 未找到 vswhere.exe
    echo 请确保已安装 Visual Studio
    pause
    exit /b 1
)

echo [1/4] 查找 Visual Studio 安装路径...
for /f "usebackq tokens=*" %%i in (`%VSWHERE% -latest -property installationPath`) do set VSPATH=%%i

if not defined VSPATH (
    echo [错误] 未找到 Visual Studio 安装
    pause
    exit /b 1
)

echo [成功] Visual Studio 路径: %VSPATH%
echo.

REM 设置 vcvarsall.bat 路径
set VCVARSALL=%VSPATH%\VC\Auxiliary\Build\vcvarsall.bat

if not exist "%VCVARSALL%" (
    echo [错误] 未找到 vcvarsall.bat: %VCVARSALL%
    pause
    exit /b 1
)

echo [2/4] 初始化 Visual Studio 开发环境（x86）...
call "%VCVARSALL%" x86

if errorlevel 1 (
    echo [错误] 初始化开发环境失败
    pause
    exit /b 1
)

echo [成功] 开发环境已初始化
echo.

REM 查找解决方案文件
echo [3/4] 查找解决方案文件...
set SOLUTION_PATH=
if exist "Core\GameServer\CoreGameServer.sln" (
    set SOLUTION_PATH=Core\GameServer\CoreGameServer.sln
    echo [成功] 找到解决方案: %SOLUTION_PATH%
) else (
    echo [错误] 未找到 CoreGameServer.sln
    echo 请确保在正确的目录下运行此脚本
    pause
    exit /b 1
)
echo.

REM 修复所有项目的 Windows SDK 版本
echo [4/4] 修复所有项目的 Windows SDK 版本...
powershell -Command "$sdk = '10.0.19041.0'; Get-ChildItem -Recurse -Filter *.vcxproj | ForEach-Object { $file = $_.FullName; (Get-Content $file) -replace '<WindowsTargetPlatformVersion>.*?</WindowsTargetPlatformVersion>', \"<WindowsTargetPlatformVersion>$sdk</WindowsTargetPlatformVersion>\" | Set-Content $file; Write-Host \"修复: $file\" }"
echo.

REM 编译项目
echo ========================================
echo 开始编译 GameServer (Debug Win32)
echo ========================================
echo.

msbuild "%SOLUTION_PATH%" ^
    /t:Rebuild ^
    /p:Configuration=Debug ^
    /p:Platform=Win32 ^
    /p:PlatformToolset=v143 ^
    /m ^
    /v:minimal

if errorlevel 1 (
    echo.
    echo ========================================
    echo [错误] 编译失败！
    echo ========================================
    pause
    exit /b 1
)

echo.
echo ========================================
echo [成功] 编译完成！
echo ========================================
echo.

REM 查找编译输出
echo 查找编译输出文件...
if exist "Core\GameServer\Debug\GameServer.exe" (
    echo [成功] 找到输出文件: Core\GameServer\Debug\GameServer.exe
) else (
    echo [警告] 未找到 GameServer.exe，可能在其他位置
)

echo.
pause

