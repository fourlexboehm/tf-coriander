#!/bin/bash

#command fails, the shell immediately shall exit
set -e
#The shell shall write to standard error a trace for each command after it expands the command and before it executes it. It is unspecified whether the command that turns tracing off is traced.
set -x

SUDO=sudo
if [[ ! $(cat /proc/1/sched | head -n 1 | grep '[init|systemd]') ]]; then {
    # running in docker
    echo running in docker
    SUDO=
} fi

${SUDO} pacman -Syu --needed --quiet \
    cmake git gcc base-devel \
    wget unzip zip rsync \
    bash-completion bazel\
    python python-virtualenv swig \
    jdk8-openjdk \
    ocl-icd clinfo opencl-headers

if [[ ! -d soft ]]; then {
    mkdir soft
} fi
pushd soft

if [[ ! -d llvm-4.0 ]]; then {
    wget http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -O clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
    if [[ -d clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04 ]]; then {
        rm -R clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04
    } fi
    tar -xf clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
    mv clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04 llvm-4.0
} fi

popd

if [[ ! -d env3 ]]; then {
    python -m virtualenv -p python env3
} fi

. env3/bin/activate
pip install -r util/requirements.txt
