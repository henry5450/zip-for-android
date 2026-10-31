# Android 交叉编译

使用 Android NDK（默认 `/Application/android-ndk-r29`，可用 `NDK=` 覆盖）构建
`zip` / `zipnote` / `zipcloak` / `zipsplit`。

## 构建

```sh
./android/build-android.sh                  # 默认 arm64-v8a
./android/build-android.sh arm64-v8a armeabi-v7a x86_64
```

产物在 `android/out/<abi>/`，构建日志为同目录下的 `build.log`。

- 最低 API 24（Android 7.0）：32 位 ABI 的 `fseeko64` 需要 API 24。
- 已启用大文件/Zip64 支持：`-DLARGE_FILE_SUPPORT -D_FILE_OFFSET_BITS=64`。
- 未启用 bzip2（`-Z bzip2`）：NDK 不自带 `bzlib.h`/`libbz2.so`，源码树中也没有 bzip2 源码。
- 构建在 `tmp/build-android-<abi>/` 的源码副本中进行，不污染源码树。

## 安装到设备

```sh
adb push android/out/arm64-v8a/zip /data/local/tmp/
adb shell chmod 755 /data/local/tmp/zip
```

也可直接推送到 Termux 的 `$PREFIX/bin`。
