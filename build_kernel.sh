#!/bin/sh

set -e -x

# custom toolchain preparation
cd ${GITHUB_WORKSPACE}
ls
export PATH="${PWD}/toolchain2/gcc/bin:${PATH}"

# export PATH="${PWD}/toolchain/clang/bin:${PWD}/toolchain/gcc/bin:${PATH}"
export ARCH=arm
export CROSS_COMPILE=arm-linux-androideabi-
export KCFLAGS=-w
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y
rm -rf out
mkdir -p out

make O=out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ARCH=arm CROSS_COMPILE=arm-linux-androidkernel- defconfig
make O=out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ARCH=arm CROSS_COMPILE=arm-linux-androidkernel- KCONFIG_ALLCONFIG=.config allnoconfig
make O=out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ARCH=arm CROSS_COMPILE=arm-linux-androidkernel- -j$(nproc --all)
make O=out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ARCH=arm CROSS_COMPILE=arm-linux-androidkernel- modules_install

cp out/arch/arm/boot/zImage ${PWD}/zImage
mv zImage boot.img-kernel

# git config user.name "rdbckp"
# git config user.email "ardibackup@gmail.com"
# git add boot.img-kernel
# git commit -m "kernel ready"
# git push
