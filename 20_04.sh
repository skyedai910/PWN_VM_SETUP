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

# 更换apt源
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
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
    ruby \
    ruby-dev \
    netcat \
    socat \
    iputils-ping \
    net-tools \
    strace \
    ltrace \
    --fix-missing
# python env
sudo add-apt-repository universe
sudo apt update
sudo apt install -y \
    python \
    python3 \
    python3-pip 
curl https://bootstrap.pypa.io/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
rm get-pip.py

# 装个编辑器防止眼瞎了
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

