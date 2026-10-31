#!/bin/sh
# Cross-compile Info-ZIP zip 3.0 for Android with the NDK.
#
# Usage: android/build-android.sh [abi ...]
#   abi: arm64-v8a (default), armeabi-v7a, x86_64
#
# Requires NDK (default /Application/android-ndk-r29 or $NDK).
# Binaries are written to android/out/<abi>/.

set -e

SRC=$(cd "$(dirname "$0")/.." && pwd)
NDK=${NDK:-/Application/android-ndk-r29}
# API 24 is the minimum for fseeko64, needed by 32-bit targets with LFS.
API=24
HOST_TAG=linux-x86_64
TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/$HOST_TAG/bin"

if [ ! -x "$TOOLCHAIN/clang" ]; then
  echo "error: NDK toolchain not found at $TOOLCHAIN" >&2
  exit 1
fi

[ $# -gt 0 ] || set -- arm64-v8a

for abi in "$@"; do
  case $abi in
    arm64-v8a)   target="aarch64-linux-android${API}" ;;
    armeabi-v7a) target="armv7a-linux-androideabi${API}" ;;
    x86_64)      target="x86_64-linux-android${API}" ;;
    *) echo "error: unsupported ABI: $abi" >&2; exit 1 ;;
  esac

  cc="$target-clang"
  build="$SRC/tmp/build-android-$abi"
  out="$SRC/android/out/$abi"

  echo "=== building $abi ($cc) ==="
  rm -rf "$build" "$out"
  mkdir -p "$build" "$out"
  # Build from a copy so the source tree stays clean.
  (cd "$SRC" && tar --exclude=./tmp --exclude=./android/out -cf - .) |
    (cd "$build" && tar -xf -)

  make -C "$build" -f unix/Makefile zips \
    CC="$cc" \
    CFLAGS="-O2 -I. -DUNIX -DLARGE_FILE_SUPPORT -D_FILE_OFFSET_BITS=64" \
    CPP="$cc -E" \
    >"$out/build.log" 2>&1 ||
    { echo "error: build failed for $abi, see $out/build.log" >&2; exit 1; }

  cp "$build/zip" "$build/zipnote" "$build/zipcloak" "$build/zipsplit" "$out/"
  rm -rf "$build"
  echo "  -> $out"
done

echo "done."
