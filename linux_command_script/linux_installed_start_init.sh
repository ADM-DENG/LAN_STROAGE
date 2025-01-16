#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GRE='\033[0;32m'
NC='\033[0m' # 无颜色

HOST_IP=$(hostname -I | awk '{print $1}')
# 一、系统详情
echo -e "${RED}-------------------------${NC}"
echo -e "${GRE}System Initialization Verification——openEuler! For learning environments${NC}"

echo -e "System/Host ip: ${HOST_IP}"
echo -e "Informations:
echo -e "hostnamectl status

# 二、rsa免密快速登陆
echo -e " "
echo -e "rsa/Login host without password: ( Windows cmd command!)"
echo -e "1、Add text directly: \n type \$env:USERPROFILE\\.ssh\\id_rsa.pub | ssh root@${HOST_IP} \"cat >> .ssh/authorized_keys\""
echo -e "2、Need create authorized_keys file: \n type \$env:USERPROFILE\\.ssh\\id_rsa.pub | ssh root@${HOST_IP} \"mkdir .ssh;touch .ssh/authorized_keys;cat >> .ssh/authorized_keys\""
echo -e "${GRE}${NC}"   
echo -e "${GRE}-------------------------${NC}"
# 三、选择操作类型
echo "1、Modify HostName/修改主机名"
echo "2、Modify Host IP/修改主机网络配置"
echo "3、Modify Repo URL/修改主机仓库源"
echo "4、Install packages/安装&更新软件包"
echo "5、Remove kernel/移除多余内核"
echo "6、Run All Commands/运行所有流程"
read -p "Input Number: " nu
# 四、函数定义
modify_hostname() {
    echo -e "${GRE}-------------------------${NC}"
    read -p "HostName/Name: " hostname1
    hostnamectl set-hostname ${hostname1}
    echo -e "HostName: $(hostname)"
    echo -e "${GRE}hostname modify successfully.${NC}" 
}
modify_net() {
    echo -e "${GRE}-------------------------${NC}"
    nmcli device status
    echo "确认所有网络接口，并确认是否继续向下执行！& 删除原接口/修改新建的网络接口名称！"
    read -p "IPADDR: " IP1
    read -p "GATEWAY: " GATEWAY1
    read -p "DNS1 DNS2: " DNS
    echo -e "nmcli connection add type ethernet con-name ens33 ifname ens33 ip4 ${IP1}/24 gw4 ${GATEWAY1} ipv4.dns '${DNS}'"
    echo "是否继续执行？否则直接终止"
    read -p "回车即可！" test
    nmcli connection add type ethernet con-name ens33 ifname ens33 ip4 ${IP1}/24 gw4 ${GATEWAY1} ipv4.dns "${DNS}"
    nmcli connection reload; nmcli connection up ens33
    echo -e "${GRE}ok!${NC}"
    read -p "是否继续执行查看结果？回车即可！"
    nmcli device status
    ip address
    echo -e "${GRE}$(cat /etc/resolv.conf)${NC}"
    echo -e "$(ping -c 4 baidu.com)"
}
Modify_Repo() {
    echo -e "${GRE}-------------------------${NC}"
    echo "sudo ls /etc/yum.repos.d :"
    sudo ls /etc/yum.repos.d
    read -p "移除原repo文件, 回车确认! " test
    sudo rm /etc/yum.repos.d/openEuler.repo
    echo -e "依据版本选择repo配置参数 (openeuler):
            https://forum.openeuler.org/t/topic/768"
    sudo touch /etc/yum.repos.d/openeuler.repo
    sudo vim /etc/yum.repos.d/openeuler.repo
    read -p "继续查看新建repo源, 回车确认! " test
    sudo cat /etc/yum.repos.d/openeuler.repo
}
Install_packages(){
    echo -e "${GRE}-------------------------${NC}"
    echo "默认推荐: vim NetworkManager openssh"
    read -p "输入需要安装的包：" packages
    sudo dnf install ${packages} -y
    read -p "是否继续执行整系统更新？回车即确认！"
    sudo dnf update -y
    echo -e "${GRE}Update Successfully!${NC}"
}
Remove_kernel(){
    echo -e "${GRE}-------------------------${NC}"
    echo "已安装的内核版本: ( rpm -qa | grep kernel )"
    rpm -qa | grep kernel
    echo "正在使用的内核版本: ( uname -r )"
    uname -r
    read -p "输入需要删除的多余内核版本: " kernel1
    sudo dnf remove ${kernel1}
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
}

# 五、函数调用/判断选择
if [ "${nu}" = "1" ]; then
    modify_hostname
elif [ "${nu}" = "2" ]; then
    modify_net
elif [ "${nu}" = "3" ]; then
    Modify_Repo
elif [ "${nu}" = "4" ]; then
    Install_packages
elif [ "${nu}" = "5" ]; then
    Remove_kernel
elif [ "${nu}" = "6" ]; then
    modify_hostname;modify_net;Modify_Repo;Install_packages;Remove_kernel;
    echo "流程结束！流程结束后建议重启。"
    echo "Command/命令:  sudo reboot   /   init 6"
else
    echo -e "${RED}输入指定/正确的编号/结束运行${NC}"
    exit 1
fi
