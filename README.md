# svn
The script for ignoring the files in .svnignore rather than setting "propset svn:ignore" for it


## Create Stand Alone Compiler for Android

```bash
#ARM
make-standalone-toolchain.sh --platform=android-21 --install-dir=/data/android/toolchains/arm  --arch=arm --stl=libc++

#ARM64
make-standalone-toolchain.sh --platform=android-21 --install-dir=/data/android/toolchains/arm64  --arch=arm64 --stl=libc++

#x86
make-standalone-toolchain.sh --platform=android-21 --install-dir=/data/android/toolchains/x86  --arch=x86 --stl=libc++

#86-64
make-standalone-toolchain.sh --platform=android-21 --install-dir=/data/android/toolchains/x86_64  --arch=x86_64 --stl=libc++

```