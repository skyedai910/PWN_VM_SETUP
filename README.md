# PWN_1804 环境配置（含arm）

## 前言

最近虚拟机有点问题，gdb-multiarch 和 pwndbg 总是装得不兼容，由于原来虚拟机 gdb 换成了 8.3 （pwndbg 能正常使用）， `sudo apt install gdb-multiarch ` 版本是 8.1.1 ，没有找到 gdb-multiarch ubuntu 更高版本的安装方法（debian有），决定重装一台。重装后用 Ubuntu18 8.1.1 gdb-multiarch 也出现各种问题：

* `gdb-multiarch Exception: Cannot override non-whitelisted built-in command "heap"`
* ```
    /build/gdb-veKdC1/gdb-8.1.1/gdb/regcache.c:122: internal-error: void* init_regcache_descr(gdbarch*): Assertion `MAX_REGISTER_SIZE >= descr->sizeof_register[i]' failed. A problem internal to GDB has been detected, further debugging may prove unreliable.  This is a bug, please report it.  For instructions, see: <http://www.gnu.org/software/gdb/bugs/>.
    ```

## 安装说明

* 使用纯净系统安装，非纯净自行调整命令如：pip 换源文件已存在问题……
* 安装镜像：ubuntu18.04 ，安装完成 libc 为新版 2.27 ，即带 double free tcachebin 检查。
* gdb、gdb-multiarch 使用 8.1.1 版本，pwndbg 是 2021.01.20（4d213a1f90dd1b2f285947cf959f617f85ca5d98）
* 安装内容含自用的软件、文件如：密码学库 gmy2…… 
* gdb-multiarch 经过数次重新按照才能正常调试，测试方法：1.pwndbg各条指令正常加载；2.可以调试 aarch64 ；


## 开启32位支持
```shell
sudo dpkg --add-architecture i386
```

## 安装库环境
```shell
sudo apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    libffi-dev \
    libssl-dev \
    build-essential 
```

## 基础工具
```shell
sudo apt install -y \
    wget \
    curl \
    git \
    gdb-multiarch \
    python \
    python-pip \
    python3 \
    python3-pip \
    patchelf \
    ruby \
    ruby-dev \
    netcat \
    socat \
    iputils-ping \
    net-tools \
    strace \
    ltrace \
    nasm \
    file \
    gawk \
    bison \
    rpm2cpio cpio \
    zstd \
    tzdata \
    binwalk \
    --fix-missing
```

## pip换源
```shell
mkdir ~/.pip
echo "[global]" > ~/.pip/pip.conf
echo "index-url = https://mirrors.aliyun.com/pypi/simple/" >> ~/.pip/pip.conf
echo "[install]" >> ~/.pip/pip.conf
echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf
```

## python2库
```shell
pip install --no-cache-dir \
    pwntools \
    z3-solver \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    ropgadget \
    LibcSearcher3
```

## python3库
```shell
pip3 install --no-cache-dir \
    pwntools \
    LibcSearcher3 \
    capstone
```

## 换gem源
```shell
gem sources --remove https://rubygems.org/
gem sources -a https://mirrors.aliyun.com/rubygems/
gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*
```

## gdb插件pwndbg
```shell
git clone --depth 1 https://github.com/pwndbg/pwndbg && \
cd pwndbg && sudo ./setup.sh && cd ~
```

## 算main_arena偏移工具
```shell
git clone --depth 1 https://github.com/bash-c/main_arena_offset.git
```

## 算地址库
```shell
git clone --depth 1 https://github.com/lieanu/LibcSearcher.git
cd LibcSearcher
sudo python setup.py develop && sudo python3 setup.py develop && cd ~
```

## 装个编辑器防止眼瞎了
```shell
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text
```

## gmpy

> 先安装一下依赖的4个软件：m4、GMP、MPFR、MPC

```shell
mkdir -p $HOME/src
mkdir -p $HOME/static

cd $HOME/src
wget http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz
tar xf m4-1.4.18.tar.gz && rm m4-1.4.18.tar.gz && cd m4-1.4.18
sudo ./configure && sudo make -j4 && sudo make check && sudo make install && sudo make clean

v=4.1.0
cd $HOME/src
wget http://www.mpfr.org/mpfr-current/mpfr-${v}.tar.bz2
tar -jxvf mpfr-${v}.tar.bz2 && cd mpfr-${v}
./configure --prefix=$HOME/static --enable-static --disable-shared --with-pic --with-gmp=$HOME/static
make && make check && make install

v=1.2.1
cd $HOME/src
wget ftp://ftp.gnu.org/gnu/mpc/mpc-${v}.tar.gz
tar -zxvf mpc-${v}.tar.gz && cd mpc-${v}
./configure --prefix=$HOME/static --enable-static --disable-shared --with-pic --with-gmp=$HOME/static --with-mpfr=$HOME/static
make && make check && make install

v=2-2.1.0b5
cd $HOME/src
wget https://github.com/aleaxit/gmpy/releases/download/gmpy${v}/gmpy${v}.tar.gz
tar xf gmpy${v}.tar.gz && cd gmpy${v}
sudo python setup.py build_ext --static-dir=$HOME/static install
sudo python3 setup.py build_ext --static-dir=$HOME/static install
```

## 编译安装qemu
```shell
wget https://download.qemu.org/qemu-5.2.0.tar.xz
tar xvJf qemu-5.2.0.tar.xz
rm qemu-5.2.0.tar.xz
cd qemu-5.2.0
sudo apt-get install -y re2c ninja-build pkg-config libglib2.0-dev libpixman-1-dev
sudo ./configure && sudo make -j4 && sudo make install && sudo make clean
```

## arm&mips运行库
```shell
sudo apt-get install -y \
    libc6-arm64-cross \
    libc6-armel-cross \
    libc6-armhf-cross \
    libc6-mips-cross \
    libc6-mips32-mips64-cross \
    libc6-mips32-mips64el-cross \
    libc6-mips64-cross \
    libc6-mips64-mips-cross \
    libc6-mips64-mipsel-cross \
    libc6-mips64el-cross \
    libc6-mipsel-cross \
    libc6-mipsn32-mips-cross \
    libc6-mipsn32-mips64-cross \
    libc6-mipsn32-mips64el-cross \
    libc6-mipsn32-mipsel-cross
```

## binutils
```shell
sudo apt-get install -y \
    binutils-mips-linux-gnu-dbg/bionic-security \
    binutils-mips64-linux-gnuabi64-dbg/bionic-security \
    binutils-mips64el-linux-gnuabi64-dbg/bionic-security \
    binutils-mipsel-linux-gnu-dbg/bionic-security \
    binutils-arm-linux-gnueabi-dbg/bionic-security
```