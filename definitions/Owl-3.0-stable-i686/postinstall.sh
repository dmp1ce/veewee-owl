#!/bin/bash
#kernel source is needed for vbox additions

date > /etc/vagrant_box_build_time

# Get wget
# http://cross-lfs.org/view/svn/alpha/the-end/downloadclient.html
echo "Get wget"
wget_rpm="wget-1.10.2-g1.i386.rpm"
lftp -e "set net:timeout 10; get /pub/linux/Owl/RPMS.i386/$wget_rpm; bye" ftp.gremlin.people.openwall.com
rpm -ivh $wget_rpm
rm $wget_rpm

echo "Get sudo from gremlin"
sudo_rpm=sudo-1.6.8p12-g1.i386.rpm
wget ftp://ftp.gremlin.people.openwall.com/pub/linux/Owl/RPMS.i386/$sudo_rpm
rpm -ivh $sudo_rpm
rm $sudo_rpm

echo "Enable sudo for Vagrant user."
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Create vagrant user.
echo "Create vagrant user"
/usr/sbin/useradd -m -r vagrant -d /home/vagrant
/usr/sbin/usermod -G root,wheel vagrant 
echo -e "vagrant\nvagrant" | passwd vagrant

#Installing vagrant keys
echo "Getting vagrant keys"
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh
rm authorized_keys

#Installing the virtualbox guest additions
# TODO: Get guest additions to install.  Won't install even with headers copied from Owl install
echo "Install virtualbox guest additions"
cd /usr/src/
unxz patch-274.3.1.el5.028stab094.3-combined.xz
patch -p0 <patch-274.3.1.el5.028stab094.3-combined
mv linux-2.6.18 linux
cd /usr/src/linux
yes "" | make oldconfig 
yes "" | make prepare
yes "" | make modules_prepare
cd ~
mount -o loop VBoxGuestAdditions_4.1.22.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

#rm VBoxGuestAdditions_4.1.22.iso
