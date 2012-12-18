#!/bin/bash
#kernel source is needed for vbox additions

date > /etc/vagrant_box_build_time

# Get wget
# http://cross-lfs.org/view/svn/alpha/the-end/downloadclient.html
echo "Get wget"
wget_rpm="wget-1.10.2-owl_add1.i386.rpm"
gawk 'BEGIN {
  NetService = "/inet/tcp/0/mirrors.kernel.org/80"
  print "GET /openwall/Owl/contrib/2.0/i386/RPMS/'$wget_rpm'" |& NetService
  while ((NetService |& getline) > 0)
    print $0
  close(NetService)
}' > binary

gawk '{q=p;p=$0}NR>1{print q}END{ORS = ""; print p}' binary > $wget_rpm
rm binary
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
cd ~
mount -o loop VBoxGuestAdditions_4.1.22.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
#
#rm VBoxGuestAdditions_4.1.22.iso
