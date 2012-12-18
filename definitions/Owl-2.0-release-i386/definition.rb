Veewee::Definition.declare({
  :cpu_count => '1', :memory_size=> '256',
  :disk_size => '10140', :disk_format => 'VDI', :hostiocache => 'off',
  :use_sata => false,
  :use_pae => 'on',
  :os_type_id => 'Linux26',
  :iso_file => "Owl-2.0-release-i386.iso", :iso_src => "",
  :iso_md5 => "2c261739f8c28f0b8ce59604e2d44041", :iso_download_timeout => 1000,
  :iso_download_instructions => "The Owl 2 iso is gzipped at several mirrors linked from Owl's homepage.  On such mirror location is: ftp://mirrors.kernel.org/openwall/Owl/2.0-release/iso/Owl-2.0-release-i386.iso.gz",
  :boot_wait => "10",
  :boot_cmd_sequence => [ 
    '<Down><Down><Enter>',			# Start boot
    '<Wait>' * 20,
    'settle<Enter>',				# Start installation wizard
    '<Enter><Enter>',				# Enter fdisk
    'n<Enter>p<Enter>1<Enter><Enter>+256M<Enter>t<Enter>82<Enter>',	# Partition harddrive swap space
    'n<Enter>p<Enter>2<Enter><Enter><Enter>',	# Create root partition
    'w<Enter>',					# Write table
    '<Wait>' * 10 + 'q',			# Wait for write
    '<Enter><Enter><Enter><Left><Enter>' + '<Wait>' * 10,	# Format and mount root partition 
    't<Enter>q',				# Setup tmpfs
    's<Enter><Enter><Left><Enter>q',		# Activate Swap
    'i' + '<Wait>' * 120,			# Install packages (Wait 2 minutes for install)
    'k' + '<Down>' * 123 + '<Wait><Enter><Enter><Left><Enter><Enter>',	# Setup keyboard
    "!sed -i 's/enforce=everyone/enforce=none/g' /owl/etc/pam.d/system-auth<Enter>",	# Turn off strong password enforement
    'exit<Enter>',
    'p' + 'vagrant<Enter>' * 2,		# Configure temporary root passwd
    't<Enter>q',				# Configure /etc/fstab
    'z<Down><Enter>' + '<Down>' * 84 + '<Wait><Enter><Enter>',	# Configure /etc/fstab
    'nh' + '<Delete>' * 9 + 'vagrant-owl2.com<Enter>',	# Set hostname
    'ia<Enter>10.0.2.15<Enter>/24<Enter>q',	# Add eth0 interface
    'g<Delete>2<Enter>',			# Set gateway
    'na10.0.2.3<Enter>q',			# Set nameserver
    's<Enter>',					# Save network settings
    '!tar -jxvf /usr/src/kernel/linux-2.4.32.tar.bz2 -C /owl/usr/src<Enter>',	# Copy kernel source for building Guest Additions
    '<Wait>' * 10,
    'mv /owl/usr/src/linux-2.4.32 /owl/usr/src/linux<Enter>',
    'rm -rf /owl/usr/src/linux/include<Enter>',
    'exit<Enter>',
    'h' + '<Wait>' * 10 + '<Enter>',			# Install kernel headers
    'b/dev/hda<Enter>',				# kernel and bootloader
    'r<Left><Enter>', # + '<Wait>' * 30,		# Reboot
    #'root<Enter>vagrant<Enter>',		# Login
  ],
  :virtualbox => { :vm_options => [{:natdnsproxy1 => 'on'}] },
  :kickstart_port => "7122", :kickstart_timeout => 10000, :kickstart_file => "",
  :ssh_login_timeout => "10000", :ssh_user => "root", :ssh_password => "vagrant", :ssh_key => "",
  :ssh_host_port => "7222", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "poweroff",
  :postinstall_files => [ "postinstall.sh"], :postinstall_timeout => 10000
})
