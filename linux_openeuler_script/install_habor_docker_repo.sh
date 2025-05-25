#!/bin/bash

# 设置变量
RED='\033[0;31m'
GRE='\033[0;32m'
NC='\033[0m' # 无颜色

echo " "
echo -e "${GRE}-------------------------${NC}"
echo " "



# 列出 /tmp 目录下的所有 .tgz 包
ls /tmp

echo " "
echo -e "${GRE}-------------------------${NC}"
echo "主要用于局域网内的私有Docker仓库部署(无https)"
echo " "

# 提示用户输入包名称
echo "需要解压部署的包："
read -p "请输入需要解压的安装包名称（包括扩展名）： " PACKAGE_NAME

# 检查包是否存在
if [ ! -f "/tmp/${PACKAGE_NAME}" ]; then
    echo -e "${RED}Error: 包 ${PACKAGE_NAME} 不存在于 /tmp 目录下。${NC}"
    exit 1
fi

# 检查 /opt/harbor 目录是否存在
if [ -d "/opt/harbor" ]; then
    echo -e "${GRE}/opt/harbor 目录已存在，跳过解压步骤。${NC}"
else
    # 解压Harbor包
    tar -zxvf /tmp/${PACKAGE_NAME} -C /opt
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to extract Harbor package.${NC}"
        echo "包的路径请放置在：/tmp 目录下"
        exit 1
    fi
fi

echo " "
echo -e "${GRE}-------------------------${NC}"
echo " "

# 进入Harbor目录
cd /opt/harbor

# 复制配置文件模板
cp harbor.yml.tmpl harbor.yml

# 获取主机IP地址
HOST_IP=$(hostname -I | awk '{print $1}')

# 修改配置文件
sed -i "s/hostname: reg.mydomain.com/hostname: ${HOST_IP}/" harbor.yml
sed -i 's/port: 80/port: 5000/' harbor.yml
sed -i 's/harbor_admin_password: Harbor12345/harbor_admin_password: harbor12345/' harbor.yml
sed -i 's/^https:/# https:/' harbor.yml
sed -i 's/^  port: 443/#   port: 443/' harbor.yml
sed -i 's/^  certificate: /#   certificate: /' harbor.yml
sed -i 's/^  private_key: /#   private_key: /' harbor.yml

# 安装并启动Harbor
./install.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Harbor installation failed.${NC}"
    exit 1
fi

echo -e "${GRE}Harbor has been successfully installed and started.${NC}"

echo "User: admin"
echo "Password: harbor12345"
echo -e "${GRE}登录地址：http://${HOST_IP}:5000${NC}"

# docker compose -f /opt/harbor/docker-compose.yml ps
# docker compose -f /opt/harbor/docker-compose.yml down
# docker compose -f /opt/harbor/docker-compose.yml up -d