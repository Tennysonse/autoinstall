#!/bin/bash
systemctl stop tftpd-hpa
systemctl stop systemd-resolved
apt install selinux-utils -y
setenforce 0 && getenforce
setenforce 0 && getenforce
unzip tftp.zip
systemctl stop tftpd-hpa
systemctl stop systemd-resolved
real_name='ub'
#passwd 加密方法
user_passwd=`mkpasswd -m sha-512 '123456'`

cat > /etc/apache2/conf-available/tftp.conf <<EOF
<Directory /var/autoinstall/tftpboot>
        Options +FollowSymLinks +Indexes
        Require all granted
</Directory>
Alias /tftp /var/autoinstall/tftpboot
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
#dhcp-option=option:router,10.0.0.2
#dhcp-range=10.0.0.156,10.0.0.200,255.255.255.0,12h



enable-tftp
tftp-root=/root/autoinstall/tftpboot
dhcp-boot=/pxelinux.0,pxeserver,10.0.0.150
dhcp-match=set:efi-x86_64,option:client-arch,7 
dhcp-boot=tag:efi-x86_64,grub/pxelinux.0
EOF
#a2enconf tftp
systemctl restart apache2 dnsmasq
