#! /bin/bash
# export https_proxy=http://192.168.211.1:7890 http_proxy=http://192.168.211.1:7890 all_proxy=socks5://192.168.211.1:7890


red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'


# Root权限检测
[[ $(id -u) != 0 ]] && echo -e " 哎呀……请使用 ${red}root ${none}用户运行 ${yellow}~(^_^) ${none}" && exit 1

# 系统检测
if [ ! -f /usr/bin/apt-get ]; then
	echo -e " 哈哈……这个 ${red}辣鸡脚本${none} 不支持你的系统。 ${yellow}(-_-) ${none}" && exit 1
fi

# 更换apt源
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" > /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y

# 开启32位支持
sudo dpkg --add-architecture i386
# 安装一些环境
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

# 基础工具
sudo apt install -y \
    wget \
    curl \
    git \
    gdb \
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

# 装个编辑器防止眼瞎了
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text


# 换pip源
if [ -f ~/.pip/pip.conf ]; then
    echo -e " 应该你换 ${red}pip源${none} 了就帮你换了。 ${yellow}(-_-) ${none}"
else
    mkdir ~/.pip
    echo "[global]" > ~/.pip/pip.conf
    echo "index-url = https://mirrors.aliyun.com/pypi/simple/" >> ~/.pip/pip.conf
    echo "[install]" >> ~/.pip/pip.conf
    echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf
fi

# 升级一下pip&pip3
python -m pip install -U pip
python3 -m pip install -U pip 

python -m pip install --no-cache-dir \
    pwntools \
    z3-solver \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    ropgadget 
# 主要是用py2，py3的库就装一小部分吧
python3 -m pip install --no-cache-dir \
    pwntools
#     ropgadget \
#     z3-solver \
#     ropper \
#     unicorn \
#     keystone-engine \
#     capstone \
#     angr \

# 换gem源
gem sources --remove https://rubygems.org/
gem sources -a https://mirrors.aliyun.com/rubygems/
gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

git clone --depth 1 https://github.com/pwndbg/pwndbg && \
cd pwndbg && chmod +x setup.sh && ./setup.sh && cd ~

# 算main_arena偏移工具
git clone --depth 1 https://github.com/bash-c/main_arena_offset.git

# 算libc偏移工具
git clone https://github.com/lieanu/LibcSearcher.git
cd LibcSearcher && python setup.py develop && cd ~



# 可能用到的密码学工具
# 先安装一下依赖的4个软件：m4、GMP、MPFR、MPC
# 准备一下文件夹，都是要编译安装的QAQ
mkdir -p $HOME/src
mkdir -p $HOME/static

cd $HOME/gmpy2/env
wget http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz
tar xf m4-1.4.18.tar.gz && rm m4-1.4.18.tar.gz && cd m4-1.4.18
sudo ./configure && sudo make -j4 && sudo make check && sudo make install && sudo make clean

# cd $HOME/gmpy2/env
# wget https://gmplib.org/download/gmp/gmp-6.2.1.tar.bz2
# tar -jxvf gmp-6.2.1.tar.bz2 && rm gmp-6.2.1.tar.bz2 && cd gmp-6.2.1
# sudo ./configure --enable-static --disable-shared --with-pic
# sudo make -j4 && sudo make check && sudo make install && sudo make clean

# cd $HOME/gmpy2/env
# wget http://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.bz2
# tar -jxvf mpfr-4.1.0.tar.bz2 && rm mpfr-4.1.0.tar.bz2 && cd mpfr-4.1.0
# ./configure --enable-static --disable-shared --with-pic 
# sudo make -j4 && sudo make check && sudo make install && sudo make clean
v=4.1.0
cd $HOME/src
wget http://www.mpfr.org/mpfr-current/mpfr-${v}.tar.bz2
tar -jxvf mpfr-${v}.tar.bz2 && cd mpfr-${v}
./configure --prefix=$HOME/static --enable-static --disable-shared --with-pic --with-gmp=$HOME/static
make && make check && make install

# cd $HOME/gmpy2/env
# wget ftp://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz
# tar -zxvf mpc-1.2.1.tar.gz && rm mpc-1.2.1.tar.gz && cd mpc-1.2.1
# sudo ./configure --enable-static --disable-shared --with-pic
# sudo make -j4 && sudo make check && sudo make install && sudo make clean
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
python setup.py build_ext --static-dir=$HOME/static install



# 编译安装qemu
wget https://download.qemu.org/qemu-5.2.0.tar.xz
tar xvJf qemu-5.2.0.tar.xz
rm qemu-5.2.0.tar.xz
cd qemu-5.2.0
sudo apt-get install -y re2c ninja-build pkg-config libglib2.0-dev libpixman-1-dev
sudo ./configure && sudo make -j4 && sudo make install && sudo make clean

# arm&mips运行库
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

# binutils
sudo apt-get install -y \
    binutils-mips-linux-gnu-dbg/bionic-security \
    binutils-mips64-linux-gnuabi64-dbg/bionic-security \
    binutils-mips64el-linux-gnuabi64-dbg/bionic-security \
    binutils-mipsel-linux-gnu-dbg/bionic-security \
    binutils-arm-linux-gnueabi-dbg/bionic-security
