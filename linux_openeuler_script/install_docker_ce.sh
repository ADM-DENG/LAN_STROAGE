#!/bin/bash

# 更新系统
sudo dnf update -y

# 安装必要的依赖
sudo dnf install -y device-mapper-persistent-data lvm2

# 检查是否存在 docker-ce.repo 文件
if [ -f /etc/yum.repos.d/docker-ce.repo ]; then
    echo -e "\033[32m已存在 docker-ce.repo 文件。\033[0m"
else
    # 添加 Docker 的官方仓库
    sudo dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

    # 使用阿里云的 Docker 镜像源
    sudo sed -i 's@$releasever@8@g' /etc/yum.repos.d/docker-ce.repo
    sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/docker-ce.repo
fi
# 安装 Docker
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 启动 Docker 并设置开机自启
sudo systemctl start docker
sudo systemctl enable docker

if [ -f /etc/docker/daemon.json ]; then
    echo -e "\033[32m已存在 daemon.json 源文件。\033[0m"
else
    # 配置 Docker 使用阿里云的镜像加速器
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "dns": ["223.5.5.5","8.8.4.4"],
    "registry-mirrors": [
        "https://docker.1ms.run",
        "https://cjie.eu.org",
        "https://dytt.online",
        "https://docker.1panel.dev"
    ]
}
EOF
fi

# 重新加载配置并重启 Docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# 验证 Docker 安装
sudo docker version

echo -e "\033[32mDocker 安装&配置完成！\033[0m"
