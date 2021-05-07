FROM ubuntu:20.04

WORKDIR /work

RUN apt-get update -qq \
  && DEBIAN_FRONTEND="noninteractive" apt-get install -qqy --no-install-recommends \
  curl ca-certificates python python3 xz-utils \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/apple-cross-toolchain/apple-sdks/releases/download/0.0.4/apple-sdks-xcode-12.4.tar.xz \
  && tar -xf apple-sdks-xcode-12.4.tar.xz \
  && mkdir -p /Applications \
  && mv Xcode.app /Applications \
  && rm -rf apple-sdks-xcode-12.4.tar.xz

RUN curl -LO https://github.com/apple-cross-toolchain/ci/releases/download/0.0.6/clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz \
  && tar -xf clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz \
  && mv clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04/bin/* /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ \
  && rm -rf clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04

RUN curl -LO https://github.com/apple-cross-toolchain/ci/releases/download/0.0.6/swift-5.3.3-RELEASE-ubuntu20.04-stripped.tar.xz \
  && tar -xf swift-5.3.3-RELEASE-ubuntu20.04-stripped.tar.xz \
  && mv swift-5.3.3-RELEASE-ubuntu20.04/usr/bin/* /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ \
  && rm -rf swift-5.3.3-RELEASE-ubuntu20.04-stripped.tar.xz swift-5.3.3-RELEASE-ubuntu20.04

RUN curl -LO https://github.com/apple-cross-toolchain/ci/releases/download/0.0.4/ported-tools-linux-x86_64.tar.xz \
  && tar -xf ported-tools-linux-x86_64.tar.xz \
  && cd bin \
  && install codesign plutil sw_vers xcrun xcodebuild xcode-select /usr/bin/ \
  && mkdir -p /usr/libexec \
  && install PlistBuddy /usr/libexec \
  && cd .. \
  && mv bin/* /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ \
  && mv lib/* /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/ \
  && rm -rf ported-tools-linux-x86_64.tar.xz bin lib

RUN xcode-select -s /Applications/Xcode.app
