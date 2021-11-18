FROM ubuntu:20.04

WORKDIR /work

RUN apt-get update -qq \
  && DEBIAN_FRONTEND="noninteractive" apt-get install -qqy --no-install-recommends \
  doxygen zip build-essential curl git cmake libpng-dev libxml2-dev \
  gobjc python vim-tiny ca-certificates ninja-build patchelf python3 unzip \
  binutils gnupg2 libc6-dev libcurl4 libedit2 libgcc-9-dev libpython2.7 \
  libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config tzdata zlib1g-dev \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/apple-cross-toolchain/apple-sdks/releases/download/0.5.0/apple-sdks-xcode-13.1.tar.xz \
  && tar -xf apple-sdks-xcode-13.1.tar.xz \
  && mkdir -p /Applications \
  && mv Xcode.app /Applications \
  && rm -rf apple-sdks-xcode-13.1.tar.xz

RUN curl -LO https://github.com/apple-cross-toolchain/ci/releases/download/0.0.15/clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz \
  && tar -xf clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz \
  && mv clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04/bin/* /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ \
  && rm -rf clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04-stripped.tar.xz clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04

RUN curl -LO https://github.com/apple-cross-toolchain/ci/releases/download/0.0.15/swift-5.5.1-RELEASE-ubuntu20.04-stripped.tar.xz \
  && tar -xf swift-5.5.1-RELEASE-ubuntu20.04-stripped.tar.xz \
  && mv swift-5.5.1-RELEASE-ubuntu20.04/usr/bin/* /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ \
  && rm -rf swift-5.5.1-RELEASE-ubuntu20.04-stripped.tar.xz swift-5.5.1-RELEASE-ubuntu20.04

RUN curl -LO https://github.com/apple-cross-toolchain/ci/releases/download/0.0.15/ported-tools-linux-x86_64.tar.xz \
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
