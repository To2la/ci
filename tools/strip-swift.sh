#!/bin/bash
#
# Strip swift tarball to include only what we need to speed up the
# decompression at toolchain resolution.

set -euo pipefail

curl -LO https://swift.org/builds/swift-5.3.3-release/ubuntu2004/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu20.04.tar.gz
tar -xf swift-5.3.3-RELEASE-ubuntu20.04.tar.gz
pushd swift-5.3.3-RELEASE-ubuntu20.04/usr
mkdir bin-new
mv \
  bin/swift \
  bin/swiftc \
  bin/swift-build \
  bin-new
rm -rf bin lib libexec include share
mv bin-new bin
popd
tar -Jcf swift-5.3.3-RELEASE-ubuntu20.04-stripped.tar.xz swift-5.3.3-RELEASE-ubuntu20.04
sha256sum swift-5.3.3-RELEASE-ubuntu20.04-stripped.tar.xz > swift-5.3.3-RELEASE-ubuntu20.04-stripped.tar.xz.sha256
