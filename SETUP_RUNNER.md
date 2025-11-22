# GitHub Self-Hosted Runner 安装指南

## 📋 前置要求

- Windows 10/11 或 Windows Server
- 已安装 Visual Studio（用于编译）
- 管理员权限

## 🚀 快速安装步骤（3 分钟）

### 第 1 步：获取安装命令

1. 访问：`https://github.com/yanlongyang806-cyber/new001/settings/actions/runners`
2. 点击 **"New self-hosted runner"**
3. 选择：
   - **Operating System**: Windows
   - **Architecture**: x64
4. 复制显示的安装命令（类似下面的格式）

### 第 2 步：在 Windows 机器上执行安装

**方法 A：使用 PowerShell（推荐）**

```powershell
# 创建 runner 目录
mkdir actions-runner
cd actions-runner

# 下载 runner（版本号可能不同，使用 GitHub 提供的实际版本）
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.309.0/actions-runner-win-x64-2.309.0.zip -OutFile actions-runner-win-x64.zip

# 解压
Expand-Archive actions-runner-win-x64.zip

# 配置 runner（使用 GitHub 提供的实际 URL 和 TOKEN）
.\config.cmd --url https://github.com/yanlongyang806-cyber/new001 --token YOUR_TOKEN

# 启动 runner
.\run.cmd
```

**方法 B：使用提供的自动化脚本**

直接运行 `setup_runner.bat`（见下方）

### 第 3 步：验证连接

看到以下消息表示成功：
```
√ Connected to GitHub
```

此时 GitHub Actions 会自动开始执行工作流。

## 🔧 自动化安装脚本

已创建 `setup_runner.bat`，可以自动完成大部分安装步骤。

## ⚙️ Runner 配置说明

### 默认标签
Runner 会自动带有以下标签：
- `self-hosted`
- `Windows`
- `X64`

这些标签与工作流中的 `runs-on: self-hosted` 匹配。

### 运行模式

**交互式运行（开发测试）**
```cmd
.\run.cmd
```

**作为服务运行（推荐用于服务器）**
```cmd
.\config.cmd --url https://github.com/xxx/xxx --token TOKEN --runasservice
```

## 🛠️ 故障排除

### Runner 无法连接
- 检查网络连接
- 确认防火墙允许访问 GitHub
- 验证 token 是否有效（token 有时效性）

### 工作流卡在 "Waiting for a runner"
- 确认 runner 正在运行（`run.cmd`）
- 检查 runner 标签是否匹配
- 查看 runner 日志

### 编译失败
- 确认已安装 Visual Studio
- 检查 MSBuild 是否在 PATH 中
- 验证项目文件路径是否正确

## 📝 注意事项

1. **Token 安全**：配置 token 只在短时间内有效，配置完成后会自动失效
2. **持续运行**：Runner 需要保持运行才能执行工作流
3. **资源占用**：Runner 会占用一些系统资源，建议在专用机器上运行

## 🔄 更新 Runner

```cmd
cd actions-runner
.\run.cmd --update
```

## 🗑️ 卸载 Runner

```cmd
cd actions-runner
.\config.cmd remove --token YOUR_TOKEN
```

