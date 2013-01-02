Veewee::Definition.declare({
  :cpu_count => '1', :memory_size=> '256',
  :disk_size => '10140', :disk_format => 'VDI', :hostiocache => 'off',
  :use_pae => 'on',
  :os_type_id => 'Linux26',
  :iso_file => "Owl-current-20120818-i686.iso", :iso_src => "",
  :iso_md5 => "70391c152f0e3b3e46e2d8fc3f3e18a8", :iso_download_timeout => 1000,
  :iso_download_instructions => "The Owl current iso is gzipped at several mirrors linked from Owl's homepage.  On such mirror location is: ftp://ftp.fr.openwall.com/pub/Owl/current/iso/Owl-current-20120818-i686.iso.gz", 
  :boot_wait => "10",
  :boot_cmd_sequence => [ 
    '<Wait>' * 20,
    'settle -d<Enter>',				# Start installation wizard
    'f<Enter>sda<Enter>',				# Enter fdisk
    'n<Enter>p<Enter>1<Enter><Enter>+256M<Enter>t<Enter>82<Enter>',	# Partition harddrive swap space
    'n<Enter>p<Enter>2<Enter><Enter><Enter>',	# Create root partition
    'w<Enter>',					# Write table
    '<Wait>' * 10 + 'q<Enter>',			# Wait for write
    'm<Enter><Enter><Enter>yes<Enter>' + '<Wait>' * 10 + '<Enter>',	# Format and mount root partition 
    's<Enter><Enter><Enter>yes<Enter><Enter>',		# Activate Swap
    '<Enter>' + '<Wait>' * 240 + '<Enter>',			# Install packages (Wait 2 minutes for install)
    "!<Enter>sed -i 's/enforce=everyone/enforce=none/g' /owl/etc/passwdqc.conf<Enter>",	# Turn off strong password enforement
    'exit<Enter>',
    'p<Enter>' + 'vagrant<Enter><Enter>vagrant<Enter>',		# Configure temporary root passwd
    't<Enter><Enter>q<Enter>',				# Configure /etc/fstab
    'z<Enter>[America]<Enter>New_York<Enter><Enter>',	# Select timezone
    'n<Enter>h<Enter>vagrant-owl3.com<Enter>',	# Set hostname
    'i<Enter>a<Enter><Enter>10.0.2.15<Enter>/24<Enter>q<Enter>',	# Add eth0 interface
    'g<Enter>10.0.2.2<Enter>',			# Set gateway
    'n<Enter>a<Enter>10.0.2.3<Enter>q<Enter>',			# Set nameserver
    's<Enter><Enter>',					# Save network settings
    # Copy kernel source for building Guest Additions
    '!<Enter>tar -Jxvf /rom/world/sources/Owl/packages/kernel/linux-2.6.18.tar.xz -C /owl/usr/src<Enter>',
    '<Wait>' * 50,
    # Copy kernel patch
    'cp /rom/world/sources/Owl/packages/kernel/p<Tab> /owl/usr/src<Enter>',
    'cp /rom/world/native/Owl/packages/kernel/lin<Tab> /owl/usr/src<Enter>',
    'cp /rom/world/native/Owl/packages/kernel/dot-config-i686 /owl/usr/src<Enter>',
    'exit<Enter>',
    'b<Enter><Enter>',				# Install kernel and bootloader
    'r<Enter>yes<Enter>', # + '<Wait>' * 30,		# Reboot
    #'root<Enter>vagrant<Enter>',		# Login
  ],
  :virtualbox => { :vm_options => [:natdnsproxy1 => 'on', :ioapic => 'on'] },
  :kickstart_port => "7122", :kickstart_timeout => 10000, :kickstart_file => "",
  :ssh_login_timeout => "10000", :ssh_user => "root", :ssh_password => "vagrant", :ssh_key => "",
  :ssh_host_port => "7222", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "poweroff",
  :postinstall_files => [ "postinstall.sh"], :postinstall_timeout => 10000
})
