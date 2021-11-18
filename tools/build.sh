#!/bin/bash

set -euo pipefail

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_ROOT}/.." && pwd)"

sudo apt update -qq
DEBIAN_FRONTEND="noninteractive" sudo apt install -qqy --no-install-recommends \
  doxygen zip build-essential curl git cmake zlib1g-dev libpng-dev libxml2-dev \
  gobjc python vim-tiny ca-certificates ninja-build patchelf

mkdir -p out/lib out/bin

git clone https://github.com/apple-cross-toolchain/xcbuild.git
pushd xcbuild
git checkout 5d2947b1db0a6ea77db6e5c90da0256400230343
bazel build //Libraries:xcbuild
tar -xf bazel-bin/Libraries/xcbuild.tar.xz -C "$PROJECT_ROOT/out/bin"
popd
rm -rf xcbuild

curl -L https://sourceforge.net/projects/pmt/files/pngcrush/1.8.13/pngcrush-1.8.13.tar.gz/download -o pngcrush.tar.gz
tar -xf pngcrush.tar.gz
rm -rf pngcrush.tar.gz
pushd pngcrush-1.8.13
make -j$(nproc)
mv pngcrush "$PROJECT_ROOT/out/bin"
popd
rm -rf pngcrush-1.8.13

# We only need sw_vers from this
git clone https://github.com/tpoechtrager/osxcross.git
pushd osxcross/wrapper
git checkout 9a2c6e344fdc06e1e46726e19956fbdb7f3ccd61
make -j$(nproc) wrapper
cp -a wrapper "$PROJECT_ROOT/out/bin/sw_vers"
popd
rm -rf osxcross

git clone https://github.com/tpoechtrager/apple-libtapi.git
pushd apple-libtapi
git checkout 664b8414f89612f2dfd35a9b679c345aa5389026
INSTALLPREFIX="$PROJECT_ROOT/out" ./build.sh
./install.sh
popd
rm -rf apple-libtapi

git clone https://github.com/tpoechtrager/cctools-port.git
pushd cctools-port/cctools
git checkout faa1f24cb7e31be132f98f503cc447c90ce2fd87
./configure --prefix="$PROJECT_ROOT/out" --with-libtapi="$PROJECT_ROOT/out"
make -j$(nproc)
make -j$(nproc) install
# Add '../lib' to ld's rpath to make it portable
patchelf --set-rpath '$ORIGIN/../lib' "$PROJECT_ROOT/out/bin/ld"
# Remove cctools' dsymutil and nm; we use llvm-dsymutil and llvm-nm
rm -f "$PROJECT_ROOT/out/bin/dsymutil"
rm -f "$PROJECT_ROOT/out/bin/nm"
popd
rm -rf cctools-port

# Unported tools
cp tools/dummy_tool out/bin/codesign
cp tools/dummy_tool out/bin/ibtool
cp tools/dummy_tool out/bin/swift-stdlib-tool

cd out
archive_filename="ported-tools-"$(uname | tr '[:upper:]' '[:lower:]')"-"$(arch)".tar.xz"
tar -Jcf "$archive_filename" bin lib
sha256sum "$archive_filename" > "$archive_filename.sha256"
