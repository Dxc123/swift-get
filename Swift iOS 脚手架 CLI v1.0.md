# Swift iOS 脚手架 CLI 计划

## 概要
开发 `swift-get`：一个用 SwiftPM 构建的可执行 CLI，面向 UIKit iOS App，体验参考 `get_cli`。v1 支持创建 UIKit + MVVM + Coordinator + SnapKit 项目，并能在已有项目中生成模块/页面，同时自动更新 `.xcodeproj`。

参考：[Swift ArgumentParser](https://github.com/apple/swift-argument-parser)、[Tuist XcodeProj](https://github.com/tuist/XcodeProj)。

## 核心变化
- 在当前工作区创建 SwiftPM 可执行包，产物命令名为 `swift-get`。
- 使用：
  - `swift-argument-parser` 解析 CLI 命令。
  - `XcodeProj` 创建和修改 `.xcodeproj`。
  - v1 自带简单 `{{variable}}` 模板渲染器，先不引入额外模板依赖。
- 命令接口：
  - `swift-get create <AppName> --bundle-id <id> [--org <name>] [--path <path>]`
  - `swift-get generate module <Name> [--project <path>] [--force] [--dry-run]`
  - `swift-get generate page <Name> [--project <path>] [--module <module>] [--force] [--dry-run]`
- 默认生成：
  - iOS 15+ / Swift 5.9。
  - UIKit、纯代码布局、MVVM。
  - SnapKit 通过 Swift Package Manager 接入。
  - Coordinator 页面导航。
  - `AppDelegate`、`SceneDelegate`、`AppCoordinator`、Home 初始模块、App/Test targets。

## 公共接口与类型
- CLI 命令类型：
  - `SwiftGetCommand`
  - `CreateCommand`
  - `GenerateCommand`
  - `GenerateModuleCommand`
  - `GeneratePageCommand`
- 核心服务：
  - `TemplateRenderer`
  - `FileWriter`
  - `NameValidator`
  - `XcodeProjectEditor`
  - `ProjectScaffolder`
  - `ModuleScaffolder`
- 模板上下文：
  - `ProjectTemplateContext`
  - `ModuleTemplateContext`
  - `PageTemplateContext`
- 错误策略：
  - 名称非法时不写入任何文件。
  - 文件已存在时默认失败，除非传入 `--force`。
  - `--dry-run` 只打印计划生成的文件和工程修改。
  - 修改 `.xcodeproj` 前先创建带时间戳的备份。

## 测试计划
- 单元测试：
  - `create`、`generate module`、`generate page` 参数解析。
  - Swift 命名校验。
  - 模板变量渲染和未知变量失败。
  - 文件覆盖保护、`--force`、`--dry-run`。
- 集成测试：
  - `create DemoApp --bundle-id com.example.demo` 生成完整项目结构、`.xcodeproj`、App/Test targets、SnapKit SPM 依赖。
  - `generate module Login` 在 fixture 工程中生成文件并加入 target。
  - `generate page Profile --module Account` 生成轻量页面文件。
  - `--dry-run` 不改变 fixture 目录。
- 手动验收：
  - 运行 `swift run swift-get create DemoApp --bundle-id com.example.demo`。
  - 使用 `xcodebuild` 编译生成项目。
  - 启动 App，确认 Home 页面由 Coordinator 正常加载。

## 假设
- v1 不支持 SwiftUI、Storyboard、CocoaPods、多语言、资产生成、model-only 命令或自定义模板市场。
- 默认命令名为 `swift-get`；Homebrew 发布在本地 SwiftPM 运行稳定后再做。
- 实现时只在当前工作区写文件，避免触碰父级 `/Users/liyaping` Git 仓库。
