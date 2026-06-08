# swift-get

swift项目脚手架

`swift-get` is a Swift CLI that scaffolds UIKit iOS projects and feature modules.

## Current Commands

```bash
swift run swift-get create DemoApp --bundle-id com.example.demo --path /tmp
swift run swift-get generate module Login --project /tmp/DemoApp/DemoApp/Modules
swift run swift-get generate page Profile --project /tmp/DemoApp/DemoApp/Modules --module Account
```

Common flags:

```bash
--force
--dry-run
```

## Generated iOS Style

- UIKit
- MVVM
- Coordinator navigation
- SnapKit layout imports
- iOS 15+ project baseline

## Implementation Notes

This desktop build is intentionally offline-friendly: it has no remote SwiftPM dependencies, so it can compile and test without GitHub access.

The original plan called for `swift-argument-parser` and Tuist `XcodeProj`. The current code keeps command parsing and project generation behind focused core types so those packages can be added later without changing the command surface.

The generated `.xcodeproj` is a minimal placeholder. The next production step is replacing that placeholder with an `XcodeProj`-backed writer once package resolution is available.

## Verification

```bash
swift test
swift run swift-get --help
```
