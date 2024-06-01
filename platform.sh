#!/bin/bash
case $TARGETPLATFORM in

    "linux/amd64")
        echo "x86_64-unknown-linux-musl" > /.target
        echo "/usr/lib/x86_64-linux-gnu" > /.libdir
        ;;
    "linux/arm64")
        echo "aarch64-unknown-linux-musl" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    "linux/arm64/v8")
        echo "aarch64-unknown-linux-musl" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    "linux/arm/v7")
        echo "armv7-unknown-linux-musleabihf" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    "linux/arm/v6")
        echo "arm-unknown-linux-musleabihf" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    "darwin/arm64")
        echo "aarch64-apple-darwin" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    "darwin/amd64")
        echo "x86_64-apple-darwin" > /.target
        echo "/usr/lib/x86_64-linux-gnu" > /.libdir
        ;;
    "windows/arm64")
        echo "aarch64-pc-windows-msvc" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    "windows/amd64")
        echo "x86_64-pc-windows-msvc" > /.target
        echo "/usr/lib/aarch64-linux-gnu" > /.libdir
        ;;
    *)
        echo "x86_64-unknown-linux-musl" > /.target
        echo "/usr/lib/x86_64-linux-gnu" > /.libdir
esac

