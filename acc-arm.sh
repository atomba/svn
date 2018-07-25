export TOOLCHAIN_BIN=$ANDROID_TOOLCHAINS/arm/bin

target_host=$TOOLCHAIN_BIN/arm-linux-android
export AR=$target_host-ar
export AS=$target_host-clang
# export CC=$target_host-clang
# export CXX=$target_host-clang++
export CC=$target_host-gcc
export CXX=$target_host-g++
export LD=$target_host-ld
export STRIP=$target_host-strip

# Tell configure what flags Android requires.
export CFLAGS="-fPIE -fPIC"
export LDFLAGS="-pie"
