# GameServer 编译方案说明

由于 GitHub Actions 的 Windows runner 已移除 MSVC 工具链，提供了两种编译方案：

## 方案 A：使用 Self-Hosted Runner（推荐用于 GitHub）

### 设置步骤

1. **下载 GitHub Runner**
   - 访问：`https://github.com/yanlongyang806-cyber/new001/settings/actions/runners`
   - 点击 "New self-hosted runner"
   - 选择 Windows 和 x64
   - 下载并解压到本地目录

2. **配置 Runner**
   ```cmd
   cd runner目录
   .\config.cmd --url https://github.com/yanlongyang806-cyber/new001 --token YOUR_TOKEN
   ```

3. **运行 Runner**
   ```cmd
   .\run.cmd
   ```

4. **工作流会自动使用你的本地环境**
   - 使用你本机的 Visual Studio
   - 使用你本机的 Windows SDK
   - 使用你本机的 MSVC 工具链

### 优势
- ✅ 完全使用本地环境，不会失败
- ✅ 编译速度快
- ✅ 无需等待 GitHub Actions 安装工具

---

## 方案 C：本地编译脚本（推荐用于快速编译）

### 使用方法

1. **直接运行脚本**
   ```cmd
   cd I:\wd112\package
   build_gameserver.bat
   ```

2. **脚本会自动：**
   - 查找 Visual Studio 安装路径
   - 初始化开发环境（x86）
   - 修复所有项目的 Windows SDK 版本
   - 编译 GameServer (Debug Win32)
   - 显示编译结果

### 输出位置
- `Core\GameServer\Debug\GameServer.exe`

### 优势
- ✅ 完全不依赖 GitHub
- ✅ 立即编译，无需等待
- ✅ 使用本地 Visual Studio 环境
- ✅ 适合日常开发

---

## 当前工作流配置

工作流已配置为使用 `self-hosted` runner。如果你还没有设置 GitHub Runner，工作流会等待 runner 上线。

如果你想继续使用 GitHub Actions 的云端 runner，需要等待微软恢复工具链支持，或者使用其他 CI/CD 服务。

