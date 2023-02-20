#!/bin/bash
systemctl stop tftpd-hpa
systemctl stop systemd-resolved
apt install selinux-utils -y
setenforce 0 && getenforce
setenforce 0 && getenforce
cd /root/autoinstall
unzip tftp.zip
systemctl stop tftpd-hpa
systemctl stop systemd-resolved
apt-get -y install dnsmasq apache2 whois
pxe_default_server='10.0.0.150'
real_name='ub'
#passwd 加密方法
user_passwd=`mkpasswd -m sha-512 '123456'`

cat > /etc/apache2/conf-available/tftp.conf <<EOF
<Directory /var/lib/tftpboot>
        Options +FollowSymLinks +Indexes
        Require all granted
</Directory>
Alias /tftp /root/autoinstall/tftpboot
EOF

cat >> /etc/dnsmasq.conf <<EOF
#绑定网口
interface=ens33,lo
# 绑定端口
bind-interfaces

domain=c-nergy.local
#--------------------------
#DHCP Settings
#--------------------------
#-- Set dhcp scope
dhcp-option=option:router,10.0.0.2
dhcp-range=10.0.0.156,10.0.0.200,255.255.255.0,12h



#-- 设置tftp根路径
enable-tftp
tftp-root=/root/autoinstall/tftpboot
enable-tftp
#--设置引导程序相对tftp根目录的路径
dhcp-boot=/pxelinux.0,pxeserver,10.0.0.150
#--检测架构并发送正确的引导加载程序文件 
dhcp-match=set:efi-x86_64,option:client-arch,7 
dhcp-boot=tag:efi-x86_64,grub/pxelinux.0

a2enconf tftp
EOF
mkdir -p /mnt
cp ubuntu-20.04.2-live-server-amd64.iso /root/autoinstall/tftpboot
mount /root/autoinstall/tftpboot/ubuntu-20.04.2-live-server-amd64.iso /mnt/
cp /mnt/casper/vmlinuz /root/autoinstall/tftpboot
cp /mnt/casper/initrd /root/autoinstall/tftpboot
umoun -l /mnt

systemctl restart apache2 dnsmasq