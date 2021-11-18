#!/bin/bash
#
# Strip clang tarball to include only what we need to speed up the
# decompression at toolchain resolution.

set -euo pipefail

curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
tar -xf clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
pushd clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04
mkdir bin-new
mv \
  bin/clang \
  bin/clang++ \
  bin/clang-12 \
  bin/ld.lld \
  bin/ld64.lld \
  bin/ld64.lld.darwinnew \
  bin/lld \
  bin/llvm-nm \
  bin-new
rm -rf bin lib libexec include share
mv bin-new bin popd
tar -Jcf clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04
sha256sum clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz > clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz.sha256
