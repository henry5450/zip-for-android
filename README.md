# zip-for-android

Info-ZIP **zip 3.0**（2008-07-05，上游源码）的 Android 交叉编译版本。

预编译产物见 [Releases](https://github.com/henry5450/zip-for-android/releases)：`arm64-v8a`、`armeabi-v7a`、`x86_64`。

## 包含的二进制

| 程序 | 说明 |
| --- | --- |
| `zip` | 创建/更新 zip 归档 |
| `zipnote` | 编辑归档注释与文件名 |
| `zipcloak` | 归档加密/解密 |
| `zipsplit` | 将大归档分卷 |

## 构建

需要 Android NDK（r29 测试通过）：

```sh
NDK=/path/to/android-ndk ./android/build-android.sh
./android/build-android.sh arm64-v8a armeabi-v7a x86_64
```

产物输出到 `android/out/<abi>/`，详见 [android/README.md](android/README.md)。

构建参数：

- 最低 API 24（Android 7.0）
- 启用大文件 / Zip64：`-DLARGE_FILE_SUPPORT -D_FILE_OFFSET_BITS=64`
- 未启用 bzip2（`-Z bzip2`）：NDK 与源码树均未提供 `libbz2`

## 安装

```sh
adb push zip /data/local/tmp/ && adb shell chmod 755 /data/local/tmp/zip
```

或推送到 Termux 的 `$PREFIX/bin`。

## 许可证

本仓库包含 Info-ZIP zip 3.0 源码，遵循 [LICENSE](LICENSE)（Info-ZIP license）。
修改部分（`android/`）同样以 Info-ZIP license 发布。
