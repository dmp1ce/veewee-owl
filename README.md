veewee-owl
==========

My attempt to define a Vagrant compatible Openwall Linux veewee template.  Unfortunately, it fails to build the VirtualBox Guest Additions.

If you use this template, be aware that several \<Wait\>'s are embedded into the initial boot/install process. On your computer, these <Wait>s may not be sufficent and you will get errors.  Openwall does not supply a kickstart or preseed file, so scripting the install process was the easiest way I could come up with to install Owl.
