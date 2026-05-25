[English](README.md) · **简体中文**

# Ravel

库优先（library-first）的原生 C++ Agent 基础库。方向见
`docs/project-charter.md`，进行中的规格见
`openspec/changes/define-ravel-core-runtime/`。

> 状态：spec 优先，目前仅有脚手架 —— 各模块均为占位，等待运行时契约定稿。

## 开始开发

```bash
git clone --recursive git@github.com:Jenwein/Ravel.git
cd Ravel
scripts/Setup-Linux.sh        # macOS: Setup-Mac.sh   ·   Windows: Setup-Windows.bat
make -C build config=debug -j$(nproc)
./build/bin/Debug-linux-x86_64/Ravel-Tests/Ravel-Tests
```

Premake 5 二进制直接捆绑在 `vendor/premake/bin/<platform>/`，clone 完无需
全局安装。首次在 macOS / Windows 构建前，需先把对应平台的 premake5 二进制
放到 `vendor/premake/bin/macosx/` 或 `vendor/premake/bin/windows/`。

需要支持 C++23 的编译器（GCC 13+、Clang 16+、MSVC 19.37+）。

## 依赖

构建工具：
- [Premake 5](https://premake.github.io/) —— 工程生成器（已捆绑 v5.0.0-beta7 二进制）

`Ravel/vendor/`（库依赖，均为 header-only 的 git submodule）：
- [nlohmann/json](https://github.com/nlohmann/json) v3.12.0 —— JSON 值与事件序列化
- [spdlog](https://github.com/gabime/spdlog) v1.17.0 —— 日志（header-only 模式）
- [stduuid](https://github.com/mariusbancila/stduuid) v1.2.3 —— UUID / 会话标识

`Ravel-Runner/vendor/`：
- [CLI11](https://github.com/CLIUtils/CLI11) v2.6.2 —— 命令行参数解析

`Ravel-Tests/vendor/`：
- [GoogleTest + GoogleMock](https://github.com/google/googletest) v1.17.0

HTTP/TLS 客户端（libcurl、OpenSSL 或更轻的替代）推迟到 model adapter 实现
阶段再选。
