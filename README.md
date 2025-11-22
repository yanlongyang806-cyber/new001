# GameServer 完整独立构建包

此包包含编译 GameServer.exe 所需的所有源代码和依赖文件。

## 📋 目录结构

- **Core/** - 核心项目和代码
  - GameServer/ - GameServer 主项目（包含所有源代码）
  - Common/ - 共享代码
  - Controller/ - 控制器代码

- **CrossRoads/** - CrossRoads 相关代码
  - GameServerLib/ - GameServer 库（包含主入口点 wmain，完整源代码）
  - Common/ - 共享代码（大量被引用）

- **libs/** - 所有依赖的库项目（完整源代码）
  - AILib/ - AI 库
  - ContentLib/ - 内容库
  - HttpLib/ - HTTP 库
  - PatchClientLib/ - 补丁客户端库
  - ServerLib/ - 服务器库
  - StructParserStub/ - StructParser 存根
  - UtilitiesLib/ - 工具库
  - WorldLib/ - 世界/地图库
  - Common/ - 公共库

- **PropertySheets/** - Visual Studio 属性表

- **Utilities/Bin/** - 构建工具
  - StructParser.exe - 自动代码生成工具（已包含）

- **3rdparty/bin/** - 第三方库（空的，需要手动添加或下载）

## 🔧 编译要求

1. **Visual Studio 2010 或更高版本**
   - 需要 C++ 编译器
   - 需要 MSBuild

2. **Windows SDK**
   - ws2_32.lib (Windows Sockets)
   - kernel32.lib
   - Imm32.lib (输入法)
   - Msacm32.lib (音频)

3. **构建工具**
   - StructParser.exe - 自动代码生成工具（已包含）

4. **第三方库**
   - 可能需要 3rdparty 目录中的库文件
   - 检查项目文件的 AdditionalLibraryDirectories 查看需要哪些库

## 🚀 编译步骤

### 本地编译

1. 打开 Visual Studio Developer Command Prompt
2. 进入此目录
3. 运行：
   ```
   msbuild Core\GameServer\CoreGameServer.sln /p:Configuration=Debug /p:Platform=Win32
   ```

### GitHub Actions 自动编译

本项目已配置 GitHub Actions，可以在 GitHub 上自动编译。

**快速开始**：
1. 运行 `push-to-github.ps1` 脚本推送到 GitHub
2. 或按照 [PUSH_TO_GITHUB.md](./PUSH_TO_GITHUB.md) 中的步骤手动推送
3. 推送到 GitHub 后，Actions 会自动开始编译
4. 在 GitHub Actions 页面查看编译状态和下载构建产物

**详细说明**：
- [README_GITHUB.md](./README_GITHUB.md) - GitHub 使用指南
- [GITHUB_BUILD.md](./GITHUB_BUILD.md) - 详细编译说明
- [PUSH_TO_GITHUB.md](./PUSH_TO_GITHUB.md) - 推送步骤指南

## ⚠️ 注意事项

- 此包包含**完整的源代码**，不仅仅是项目文件
- AutoGen 目录下的文件会在编译前由 StructParser 自动生成
- 第三方库（3rdparty）可能需要单独添加或下载
- 编译时间可能需要 15-30 分钟（取决于机器性能）

## 📦 文件清单

此包包含：
- 所有项目文件（.vcxproj, .sln）
- 所有源文件（.c, .cpp）
- 所有头文件（.h, .hpp）
- 所有必需的共享代码
- 构建工具（StructParser）
- Visual Studio 属性表

总计约：__SIZE__ MB

## 🔗 相关链接

- GitHub 仓库: https://github.com/yanlongyang806-cyber/new001
- GitHub Actions: https://github.com/yanlongyang806-cyber/new001/actions

## 📚 文档

- [编译检查报告](./编译检查报告.md) - 初始检查报告
- [深度排查报告](./深度排查报告.md) - 深度排查结果
- [复制完成报告](./复制完成报告.md) - 依赖文件复制记录
