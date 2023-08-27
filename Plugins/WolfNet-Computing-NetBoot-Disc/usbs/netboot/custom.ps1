<#
.SYNOPSIS
	This script downloads files from the internet and sets up the netboot files...

.NOTES
    Author: John Wolfe
    Last Edit: 24-08-2023 22:50
#>

#----------------[ Declarations ]----------------

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$file_list = @(
	# Individual files.
	("iPXE", "https://wolfnet-computing.com/pxe/ipxe.lkrn", "kernels\ipxe.lkrn", $False),
	# ISO images.
	("DSL Linux", "http://distro.ibiblio.org/damnsmall/dslcore/dslcore_20080717.iso", (("boot\dslcore.gz", "kernels\dsl"), ("boot\bzimage", "kernels\dsl")), $True),
	("SliTaz Linux", "http://mirror.slitaz.org/iso/rolling/slitaz-rolling-core-5in1.iso", (("BOOT\BZIMAGE", "kernels\slitaz"), ("BOOT\BZIMAGE6", "kernels\slitaz"), ("BOOT\ROOTFS1.GZ", "kernels\slitaz"), ("BOOT\ROOTFS1.GZ6", "kernels\slitaz"), ("BOOT\ROOTFS2.GZ", "kernels\slitaz"), ("BOOT\ROOTFS3.GZ", "kernels\slitaz"), ("BOOT\ROOTFS4.GZ", "kernels\slitaz"), ("BOOT\ROOTFS5.GZ", "kernels\slitaz")), $True),
	("TinyCore Linux", "http://tinycorelinux.net/14.x/x86/release/CorePlus-current.iso", (("boot\core.gz", "kernels\tinycore"), ("boot\vmlinuz", "kernels\tinycore"), ("cde\installer.instlist", "tinycore"), ("cde\kmaps.instlist", "tinycore"), ("cde\onboot.lst", "tinycore"), ("cde\remaster.instlist", "tinycore"), ("cde\wifi.instlist", "tinycore"), ("cde\wififirmware.instlist", "tinycore"), ("cde\xbase.lst", "tinycore"), ("cde\xfbase.lst", "tinycore"), ("cde\xibase.lst", "tinycore"), ("cde\xwbase.lst", "tinycore"), ("cde\optional\advcomp.tcz", "tinycore\optional"), ("cde\optional\advcomp.tcz.dep", "tinycore\optional"), ("cde\optional\advcomp.tcz.md5.txt", "tinycore\optional"), ("cde\optional\aterm.tcz", "tinycore\optional"), ("cde\optional\aterm.tcz.dep", "tinycore\optional"), ("cde\optional\aterm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\atk.tcz", "tinycore\optional"), ("cde\optional\atk.tcz.dep", "tinycore\optional"), ("cde\optional\atk.tcz.md5.txt", "tinycore\optional"), ("cde\optional\bzip2-lib.tcz", "tinycore\optional"), ("cde\optional\bzip2-lib.tcz.md5.txt", "tinycore\optional"), ("cde\optional\cairo.tcz", "tinycore\optional"), ("cde\optional\cairo.tcz.dep", "tinycore\optional"), ("cde\optional\cairo.tcz.md5.txt", "tinycore\optional"), ("cde\optional\dbus.tcz", "tinycore\optional"), ("cde\optional\dbus.tcz.dep", "tinycore\optional"), ("cde\optional\dbus.tcz.md5.txt", "tinycore\optional"), ("cde\optional\dosfstools.tcz", "tinycore\optional"), ("cde\optional\dosfstools.tcz.md5.txt", "tinycore\optional"), ("cde\optional\expat2.tcz", "tinycore\optional"), ("cde\optional\expat2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\ezremaster.tcz", "tinycore\optional"), ("cde\optional\ezremaster.tcz.dep", "tinycore\optional"), ("cde\optional\ezremaster.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-amd-ucode.tcz", "tinycore\optional"), ("cde\optional\firmware-amd-ucode.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-atheros.tcz", "tinycore\optional"), ("cde\optional\firmware-atheros.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-chelsio.tcz", "tinycore\optional"), ("cde\optional\firmware-chelsio.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-intel_e100.tcz", "tinycore\optional"), ("cde\optional\firmware-intel_e100.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-ipw2100.tcz", "tinycore\optional"), ("cde\optional\firmware-ipw2100.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-ipw2200.tcz", "tinycore\optional"), ("cde\optional\firmware-ipw2200.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-iwimax.tcz", "tinycore\optional"), ("cde\optional\firmware-iwimax.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-iwl8000.tcz", "tinycore\optional"), ("cde\optional\firmware-iwl8000.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-iwl9000.tcz", "tinycore\optional"), ("cde\optional\firmware-iwl9000.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-iwlwifi.tcz", "tinycore\optional"), ("cde\optional\firmware-iwlwifi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-marvel.tcz", "tinycore\optional"), ("cde\optional\firmware-marvel.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-myri10ge.tcz", "tinycore\optional"), ("cde\optional\firmware-myri10ge.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-netxen.tcz", "tinycore\optional"), ("cde\optional\firmware-netxen.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-openfwwf.tcz", "tinycore\optional"), ("cde\optional\firmware-openfwwf.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-ralinkwifi.tcz", "tinycore\optional"), ("cde\optional\firmware-ralinkwifi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-rtl_nic.tcz", "tinycore\optional"), ("cde\optional\firmware-rtl_nic.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-rtlwifi.tcz", "tinycore\optional"), ("cde\optional\firmware-rtlwifi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-ti-connectivity.tcz", "tinycore\optional"), ("cde\optional\firmware-ti-connectivity.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-tigon.tcz", "tinycore\optional"), ("cde\optional\firmware-tigon.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-ueagle-atm.tcz", "tinycore\optional"), ("cde\optional\firmware-ueagle-atm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-vxge.tcz", "tinycore\optional"), ("cde\optional\firmware-vxge.tcz.md5.txt", "tinycore\optional"), ("cde\optional\firmware-zd1211.tcz", "tinycore\optional"), ("cde\optional\firmware-zd1211.tcz.dep", "tinycore\optional"), ("cde\optional\firmware-zd1211.tcz.md5.txt", "tinycore\optional"), ("cde\optional\fltk-1.3.tcz", "tinycore\optional"), ("cde\optional\fltk-1.3.tcz.dep", "tinycore\optional"), ("cde\optional\fltk-1.3.tcz.md5.txt", "tinycore\optional"), ("cde\optional\fluxbox.tcz", "tinycore\optional"), ("cde\optional\fluxbox.tcz.dep", "tinycore\optional"), ("cde\optional\fluxbox.tcz.md5.txt", "tinycore\optional"), ("cde\optional\flwm.tcz", "tinycore\optional"), ("cde\optional\flwm.tcz.dep", "tinycore\optional"), ("cde\optional\flwm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\flwm_topside.tcz", "tinycore\optional"), ("cde\optional\flwm_topside.tcz.dep", "tinycore\optional"), ("cde\optional\flwm_topside.tcz.md5.txt", "tinycore\optional"), ("cde\optional\fontconfig.tcz", "tinycore\optional"), ("cde\optional\fontconfig.tcz.dep", "tinycore\optional"), ("cde\optional\fontconfig.tcz.md5.txt", "tinycore\optional"), ("cde\optional\freetype.tcz", "tinycore\optional"), ("cde\optional\freetype.tcz.dep", "tinycore\optional"), ("cde\optional\freetype.tcz.md5.txt", "tinycore\optional"), ("cde\optional\fribidi.tcz", "tinycore\optional"), ("cde\optional\fribidi.tcz.dep", "tinycore\optional"), ("cde\optional\fribidi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\gdk-pixbuf2.tcz", "tinycore\optional"), ("cde\optional\gdk-pixbuf2.tcz.dep", "tinycore\optional"), ("cde\optional\gdk-pixbuf2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\glib2.tcz", "tinycore\optional"), ("cde\optional\glib2.tcz.dep", "tinycore\optional"), ("cde\optional\glib2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\glibc_gconv.tcz", "tinycore\optional"), ("cde\optional\glibc_gconv.tcz.md5.txt", "tinycore\optional"), ("cde\optional\graphite2.tcz", "tinycore\optional"), ("cde\optional\graphite2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\gtk2.tcz", "tinycore\optional"), ("cde\optional\gtk2.tcz.dep", "tinycore\optional"), ("cde\optional\gtk2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\gzip.tcz", "tinycore\optional"), ("cde\optional\gzip.tcz.md5.txt", "tinycore\optional"), ("cde\optional\hackedbox.tcz", "tinycore\optional"), ("cde\optional\hackedbox.tcz.dep", "tinycore\optional"), ("cde\optional\hackedbox.tcz.md5.txt", "tinycore\optional"), ("cde\optional\harfbuzz.tcz", "tinycore\optional"), ("cde\optional\harfbuzz.tcz.dep", "tinycore\optional"), ("cde\optional\harfbuzz.tcz.md5.txt", "tinycore\optional"), ("cde\optional\icewm.tcz", "tinycore\optional"), ("cde\optional\icewm.tcz.dep", "tinycore\optional"), ("cde\optional\icewm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\imlib2.tcz", "tinycore\optional"), ("cde\optional\imlib2.tcz.dep", "tinycore\optional"), ("cde\optional\imlib2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\imlib2-bin.tcz", "tinycore\optional"), ("cde\optional\imlib2-bin.tcz.dep", "tinycore\optional"), ("cde\optional\imlib2-bin.tcz.md5.txt", "tinycore\optional"), ("cde\optional\iw.tcz", "tinycore\optional"), ("cde\optional\iw.tcz.dep", "tinycore\optional"), ("cde\optional\iw.tcz.md5.txt", "tinycore\optional"), ("cde\optional\jwm.tcz", "tinycore\optional"), ("cde\optional\jwm.tcz.dep", "tinycore\optional"), ("cde\optional\jwm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\kmaps.tcz", "tinycore\optional"), ("cde\optional\kmaps.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libcroco.tcz", "tinycore\optional"), ("cde\optional\libcroco.tcz.dep", "tinycore\optional"), ("cde\optional\libcroco.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libdrm.tcz", "tinycore\optional"), ("cde\optional\libdrm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libEGL.tcz", "tinycore\optional"), ("cde\optional\libEGL.tcz.dep", "tinycore\optional"), ("cde\optional\libEGL.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libffi.tcz", "tinycore\optional"), ("cde\optional\libffi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libfontenc.tcz", "tinycore\optional"), ("cde\optional\libfontenc.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libFS.tcz", "tinycore\optional"), ("cde\optional\libFS.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libGL.tcz", "tinycore\optional"), ("cde\optional\libGL.tcz.dep", "tinycore\optional"), ("cde\optional\libGL.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libglade.tcz", "tinycore\optional"), ("cde\optional\libglade.tcz.dep", "tinycore\optional"), ("cde\optional\libglade.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libGLESv2.tcz", "tinycore\optional"), ("cde\optional\libGLESv2.tcz.dep", "tinycore\optional"), ("cde\optional\libGLESv2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libICE.tcz", "tinycore\optional"), ("cde\optional\libICE.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libiw.tcz", "tinycore\optional"), ("cde\optional\libiw.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libjpeg-turbo.tcz", "tinycore\optional"), ("cde\optional\libjpeg-turbo.tcz.md5.txt", "tinycore\optional"), ("cde\optional\liblzma.tcz", "tinycore\optional"), ("cde\optional\liblzma.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libnl.tcz", "tinycore\optional"), ("cde\optional\libnl.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libpci.tcz", "tinycore\optional"), ("cde\optional\libpci.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libpciaccess.tcz", "tinycore\optional"), ("cde\optional\libpciaccess.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libpng.tcz", "tinycore\optional"), ("cde\optional\libpng.tcz.md5.txt", "tinycore\optional"), ("cde\optional\librsvg.tcz", "tinycore\optional"), ("cde\optional\librsvg.tcz.dep", "tinycore\optional"), ("cde\optional\librsvg.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libSM.tcz", "tinycore\optional"), ("cde\optional\libSM.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libstartup-notification.tcz", "tinycore\optional"), ("cde\optional\libstartup-notification.tcz.dep", "tinycore\optional"), ("cde\optional\libstartup-notification.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libtiff.tcz", "tinycore\optional"), ("cde\optional\libtiff.tcz.dep", "tinycore\optional"), ("cde\optional\libtiff.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libX11.tcz", "tinycore\optional"), ("cde\optional\libX11.tcz.dep", "tinycore\optional"), ("cde\optional\libX11.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXau.tcz", "tinycore\optional"), ("cde\optional\libXau.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXaw.tcz", "tinycore\optional"), ("cde\optional\libXaw.tcz.dep", "tinycore\optional"), ("cde\optional\libXaw.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libxcb.tcz", "tinycore\optional"), ("cde\optional\libxcb.tcz.dep", "tinycore\optional"), ("cde\optional\libxcb.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXcomposite.tcz", "tinycore\optional"), ("cde\optional\libXcomposite.tcz.dep", "tinycore\optional"), ("cde\optional\libXcomposite.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXcursor.tcz", "tinycore\optional"), ("cde\optional\libXcursor.tcz.dep", "tinycore\optional"), ("cde\optional\libXcursor.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXdamage.tcz", "tinycore\optional"), ("cde\optional\libXdamage.tcz.dep", "tinycore\optional"), ("cde\optional\libXdamage.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXdmcp.tcz", "tinycore\optional"), ("cde\optional\libXdmcp.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXext.tcz", "tinycore\optional"), ("cde\optional\libXext.tcz.dep", "tinycore\optional"), ("cde\optional\libXext.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXfixes.tcz", "tinycore\optional"), ("cde\optional\libXfixes.tcz.dep", "tinycore\optional"), ("cde\optional\libXfixes.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXfont.tcz", "tinycore\optional"), ("cde\optional\libXfont.tcz.dep", "tinycore\optional"), ("cde\optional\libXfont.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXfont2.tcz", "tinycore\optional"), ("cde\optional\libXfont2.tcz.dep", "tinycore\optional"), ("cde\optional\libXfont2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXft.tcz", "tinycore\optional"), ("cde\optional\libXft.tcz.dep", "tinycore\optional"), ("cde\optional\libXft.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXi.tcz", "tinycore\optional"), ("cde\optional\libXi.tcz.dep", "tinycore\optional"), ("cde\optional\libXi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXinerama.tcz", "tinycore\optional"), ("cde\optional\libXinerama.tcz.dep", "tinycore\optional"), ("cde\optional\libXinerama.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libxkbfile.tcz", "tinycore\optional"), ("cde\optional\libxkbfile.tcz.dep", "tinycore\optional"), ("cde\optional\libxkbfile.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libxml2.tcz", "tinycore\optional"), ("cde\optional\libxml2.tcz.dep", "tinycore\optional"), ("cde\optional\libxml2.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXmu.tcz", "tinycore\optional"), ("cde\optional\libXmu.tcz.dep", "tinycore\optional"), ("cde\optional\libXmu.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXpm.tcz", "tinycore\optional"), ("cde\optional\libXpm.tcz.dep", "tinycore\optional"), ("cde\optional\libXpm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXrandr.tcz", "tinycore\optional"), ("cde\optional\libXrandr.tcz.dep", "tinycore\optional"), ("cde\optional\libXrandr.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXrender.tcz", "tinycore\optional"), ("cde\optional\libXrender.tcz.dep", "tinycore\optional"), ("cde\optional\libXrender.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXres.tcz", "tinycore\optional"), ("cde\optional\libXres.tcz.dep", "tinycore\optional"), ("cde\optional\libXres.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libxshmfence.tcz", "tinycore\optional"), ("cde\optional\libxshmfence.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXss.tcz", "tinycore\optional"), ("cde\optional\libXss.tcz.dep", "tinycore\optional"), ("cde\optional\libXss.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXt.tcz", "tinycore\optional"), ("cde\optional\libXt.tcz.dep", "tinycore\optional"), ("cde\optional\libXt.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXtst.tcz", "tinycore\optional"), ("cde\optional\libXtst.tcz.dep", "tinycore\optional"), ("cde\optional\libXtst.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXv.tcz", "tinycore\optional"), ("cde\optional\libXv.tcz.dep", "tinycore\optional"), ("cde\optional\libXv.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXvmc.tcz", "tinycore\optional"), ("cde\optional\libXvmc.tcz.dep", "tinycore\optional"), ("cde\optional\libXvmc.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXxf86dga.tcz", "tinycore\optional"), ("cde\optional\libXxf86dga.tcz.dep", "tinycore\optional"), ("cde\optional\libXxf86dga.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libXxf86vm.tcz", "tinycore\optional"), ("cde\optional\libXxf86vm.tcz.dep", "tinycore\optional"), ("cde\optional\libXxf86vm.tcz.md5.txt", "tinycore\optional"), ("cde\optional\libzstd.tcz", "tinycore\optional"), ("cde\optional\libzstd.tcz.md5.txt", "tinycore\optional"), ("cde\optional\mkisofs-tools.tcz", "tinycore\optional"), ("cde\optional\mkisofs-tools.tcz.md5.txt", "tinycore\optional"), ("cde\optional\mtools.tcz", "tinycore\optional"), ("cde\optional\mtools.tcz.dep", "tinycore\optional"), ("cde\optional\mtools.tcz.md5.txt", "tinycore\optional"), ("cde\optional\ncursesw.tcz", "tinycore\optional"), ("cde\optional\ncursesw.tcz.md5.txt", "tinycore\optional"), ("cde\optional\openbox.tcz", "tinycore\optional"), ("cde\optional\openbox.tcz.dep", "tinycore\optional"), ("cde\optional\openbox.tcz.md5.txt", "tinycore\optional"), ("cde\optional\openssl-1.1.1.tcz", "tinycore\optional"), ("cde\optional\openssl-1.1.1.tcz.md5.txt", "tinycore\optional"), ("cde\optional\pango.tcz", "tinycore\optional"), ("cde\optional\pango.tcz.dep", "tinycore\optional"), ("cde\optional\pango.tcz.md5.txt", "tinycore\optional"), ("cde\optional\pci-utils.tcz", "tinycore\optional"), ("cde\optional\pci-utils.tcz.dep", "tinycore\optional"), ("cde\optional\pci-utils.tcz.md5.txt", "tinycore\optional"), ("cde\optional\pcre.tcz", "tinycore\optional"), ("cde\optional\pcre.tcz.dep", "tinycore\optional"), ("cde\optional\pcre.tcz.md5.txt", "tinycore\optional"), ("cde\optional\perl5.tcz", "tinycore\optional"), ("cde\optional\perl5.tcz.dep", "tinycore\optional"), ("cde\optional\perl5.tcz.md5.txt", "tinycore\optional"), ("cde\optional\pixman.tcz", "tinycore\optional"), ("cde\optional\pixman.tcz.md5.txt", "tinycore\optional"), ("cde\optional\readline.tcz", "tinycore\optional"), ("cde\optional\readline.tcz.dep", "tinycore\optional"), ("cde\optional\readline.tcz.md5.txt", "tinycore\optional"), ("cde\optional\syslinux.tcz", "tinycore\optional"), ("cde\optional\syslinux.tcz.md5.txt", "tinycore\optional"), ("cde\optional\tar.tcz", "tinycore\optional"), ("cde\optional\tar.tcz.md5.txt", "tinycore\optional"), ("cde\optional\tc-install.tcz", "tinycore\optional"), ("cde\optional\tc-install.tcz.dep", "tinycore\optional"), ("cde\optional\tc-install.tcz.md5.txt", "tinycore\optional"), ("cde\optional\tc-install-GUI.tcz", "tinycore\optional"), ("cde\optional\tc-install-GUI.tcz.dep", "tinycore\optional"), ("cde\optional\tc-install-GUI.tcz.md5.txt", "tinycore\optional"), ("cde\optional\udev-lib.tcz", "tinycore\optional"), ("cde\optional\udev-lib.tcz.dep", "tinycore\optional"), ("cde\optional\udev-lib.tcz.md5.txt", "tinycore\optional"), ("cde\optional\wbar.tcz", "tinycore\optional"), ("cde\optional\wbar.tcz.dep", "tinycore\optional"), ("cde\optional\wbar.tcz.md5.txt", "tinycore\optional"), ("cde\optional\wifi.tcz", "tinycore\optional"), ("cde\optional\wifi.tcz.dep", "tinycore\optional"), ("cde\optional\wifi.tcz.md5.txt", "tinycore\optional"), ("cde\optional\wireless_tools.tcz", "tinycore\optional"), ("cde\optional\wireless_tools.tcz.dep", "tinycore\optional"), ("cde\optional\wireless_tools.tcz.md5.txt", "tinycore\optional"), ("cde\optional\wireless-6.1.2-tinycore.tcz", "tinycore\optional"), ("cde\optional\wireless-6.1.2-tinycore.tcz.md5.txt", "tinycore\optional"), ("cde\optional\wpa_supplicant-dbus.tcz", "tinycore\optional"), ("cde\optional\wpa_supplicant-dbus.tcz.dep", "tinycore\optional"), ("cde\optional\wpa_supplicant-dbus.tcz.md5.txt", "tinycore\optional"), ("cde\optional\Xlibs.tcz", "tinycore\optional"), ("cde\optional\Xlibs.tcz.dep", "tinycore\optional"), ("cde\optional\Xlibs.tcz.md5.txt", "tinycore\optional"), ("cde\optional\Xorg-7.7-lib.tcz", "tinycore\optional"), ("cde\optional\Xorg-7.7-lib.tcz.dep", "tinycore\optional"), ("cde\optional\Xorg-7.7-lib.tcz.md5.txt", "tinycore\optional"), ("cde\optional\Xprogs.tcz", "tinycore\optional"), ("cde\optional\Xprogs.tcz.dep", "tinycore\optional"), ("cde\optional\Xprogs.tcz.md5.txt", "tinycore\optional"), ("cde\optional\Xvesa.tcz", "tinycore\optional"), ("cde\optional\Xvesa.tcz.dep", "tinycore\optional"), ("cde\optional\Xvesa.tcz.md5.txt", "tinycore\optional")), $True),
	("SystemRescue", "https://fastly-cdn.system-rescue.org/releases/10.01/systemrescue-10.01-amd64.iso", (("SYSRESCCD\BOOT\X86_64\vmlinuz", "kernels\systemrescue"), ("SYSRESCCD\BOOT\X86_64\SYSRESCCD.IMG", "kernels\systemrescue"), ("SYSRESCCD\BOOT\AMD_UCODE.IMG", "systemrescue\BOOT"), ("SYSRESCCD\BOOT\INTEL_UCODE.IMG", "systemrescue\BOOT"), ("SYSRESCCD\X86_64\AIROOTFS.SFS", "systemrescue\X86_64"), ("SYSRESCCD\X86_64\AIROOTFS.SHA512", "systemrescue\X86_64"), ("SYSRESCCD\PKGLIST_X86_64.TXT", "systemrescue")), $True),
	("Fedora Linux 38", "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-38-1.6.iso", (("images\pxeboot\vmlinuz", "kernels\fedora\38"), ("images\pxeboot\initrd.img", "kernels\fedora\38"), ("images\eltorito.img", "fedora\38\images"), ("images\install.img", "fedora\38\images"), (".discinfo", "fedora\38")), $True),
	("Fedora Linux 38 Silverblue", "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Silverblue/x86_64/iso/Fedora-Silverblue-ostree-x86_64-38-1.6.iso", (("images\pxeboot\vmlinuz", "kernels\fedora\silverblue"), ("images\pxeboot\initrd.img", "kernels\fedora\silverblue"), ("images\eltorito.img", "fedora\silverblue\images"), ("images\install.img", "fedora\silverblue\images"), (".discinfo", "fedora\silverblue")), $True),
	#("Kali Linux 2023.3", "https://cdimage.kali.org/kali-2023.3/kali-linux-2023.3-installer-netinst-amd64.iso", (()), $True),
	("Tails Linux", "https://download.tails.net/tails/stable/tails-amd64-5.16.1/tails-amd64-5.16.1.iso", (("live\vmlinuz", "kernels\tails"), ("live\Tails.module", "tails"), ("live\initrd.img", "tails"), ("live\filesystem.packages", "tails"), ("live\filesystem.squashfs", "tails")), $True),
	# ZIP archives.
	("CHNTPW", "http://pogostick.net/~pnh/ntpasswd/usb140201.zip", (("initrd.cgz", "kernels\chntpw\initrd.cgz"), ("scsi.cgz", "kernels\chntpw\scsi.cgz"), ("vmlinuz", "kernels\chntpw\vmlinuz")), $True)
)

#----------------[ Functions ]------------------

Function Download-File {
	<#
	.SYNOPSIS
		This advanced function downloads a file from the internet.

	.PARAMETER url
		The parameter url is used to define the URI to be downloaded from.

	.PARAMETER filename
		The parameter filename is used to define the file to download to.

	.NOTES
		Author: John Wolfe
	#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, Position=0)]
        [string]$url,

        [Parameter(Mandatory=$True)]
        [string]$filename
    )
	Write-Host "CUSTOM: Downloading '$filename' from '$url'."
	Invoke-WebRequest -Uri $url -OutFile $filename
}

function Abort {
	Write-Host "CUSTOM: Aborted..."
	Set-Variable -Name rv -Value 1
	End2
}

function End1 {
	Set-Variable -Name rv -Value 0
	End2
}

function End2 {
	Write-Host "CUSTOM: Exiting with return value $rv"
	Exit $rv
}

#----------------[ Main Execution ]---------------

# Create the form to select the components to be added to the USB.
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select the OSes."
$form.AutoSize = $True
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Text = "Select the Operating Systems/Tools to add to the disk."
$label.Location  = New-Object System.Drawing.Point(10,10)
$label.AutoSize = $True
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.CheckedListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(265,260)
$listBox.CheckOnClick = $True
$form.Controls.Add($listBox)

For ($i=0; $i -lt $file_list.Length; $i++) {
	$listBox.Items.Add($file_list[$i][0], $False) | Out-Null
}

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(125,310)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(200,310)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$result = $form.ShowDialog()
If ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
	Write-Error "User cancelled the dialog."
	Abort
}

# Create the temporary directory for the downloaded files...
If (Test-Path -Path "$env:temp\_netboot_") { Remove-Item -Path "$env:temp\_netboot_" -recurse }
New-Item -Name "_netboot_" -Path $env:temp -itemType Directory | Out-Null

# Download any OSes that have been selected...
ForEach ($item in $listBox.CheckedItems) {
	ForEach ($file in $file_list) {
		If ($($file[0]) -eq [string]$item) {
			Download-File -url $file[1] -filename "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])"
			If (-not (Test-Path -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])")) {
				Write-Error "CUSTOM: Couldn't download file '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])'."
				Abort
			}
			If ($($file[3])) {
				If ($(([uri]$file[1]).Segments[-1].EndsWith(".iso"))) {
					$_mount_point = ((Mount-DiskImage "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -PassThru | Get-Volume).DriveLetter) + ":"
					Write-Host "CUSTOM: Mounted image '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])' at '$_mount_point\'."
					ForEach ($location in $file[2]) {
						If (-not (Test-Path -Path "$PSScriptRoot\files\$($location[1])")) {
							Write-Host "CUSTOM: Creating Directory '$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)' in '$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)'."
							New-Item -Name "$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)" -Path "$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)" -itemType Directory -Force | Out-Null
						}
						Write-Host "CUSTOM: Copying file '$_mount_point\$($location[0])' to '$PSScriptRoot\files\$($location[1])'."
						Copy-Item -Path "$_mount_point\$($location[0])" -Destination "$PSScriptRoot\files\$($location[1])\$(Split-Path $location[0] -leaf)" -Force | Out-Null
					}
					Dismount-DiskImage -ImagePath "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" | Out-Null
				}
				ElseIf ($(([uri]$file[1]).Segments[-1].EndsWith(".zip"))) {
					Write-Host "CUSTOM: Extracting archive '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])'."
					New-Item -Name "$($file[0])" -Path "$env:temp\_netboot_" -itemType Directory | Out-Null
					Expand-Archive -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -DestinationPath "$env:temp\_netboot_\$($file[0])"
					ForEach ($location in $file[2]) {
						If (-not (Test-Path -Path "$PSScriptRoot\files\$($location[1])")) {
							Write-Host "CUSTOM: Creating Directory '$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)' in '$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)'."
							New-Item -Name "$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)" -Path "$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)" -itemType Directory -Force | Out-Null
						}
						Write-Host "CUSTOM: Moving file '$env:temp\_netboot_\$($file[0])\$($location[0])' to '$PSScriptRoot\files\$($location[1])'."
						Move-Item -Path "$env:temp\_netboot_\$($file[0])\$($location[0])" -Destination "$PSScriptRoot\files\$($location[1])" -Force | Out-Null
					}
				}
			}
			Else {
				Write-Host "CUSTOM: Moving file '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])' to '$PSScriptRoot\files\$($file[2])'."
				Move-Item -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -Destination "$PSScriptRoot\files\$($file[2])" | Out-Null
			}
			Break
		}
	}
}

# Remove the temporary directory.
Remove-Item -Path "$env:temp\_netboot_" -recurse
End1