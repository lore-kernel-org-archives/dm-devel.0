From: "Kumar, Vijay (STSD)" <vijay.kumar7@hp.com>
Subject: Boot from SAN with device-mapper-multipath device
Date: Wed, 28 Jun 2006 20:35:12 +0530
Message-ID: <58FE8766C9D3FE4E8AF6B6B75A74AF8F061F01A6@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0040306710=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0040306710==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C69AC4.4198EA5E"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C69AC4.4198EA5E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I am trying boot from SAN with DM-multipath devices as a root device. My
initrd images  contains following files :
./etc/multipath.conf
./etc/scsi_id.config
./etc/udev
./etc/udev/devices
./etc/udev/scripts
./etc/udev/scripts/ide-media.sh
./etc/udev/scripts/check-cdrom.sh
./etc/udev/scripts/MAKEDEV.dev
./etc/udev/scripts/pam_console.dev
./etc/udev/scripts/hotplug.dev
./etc/udev/permissions.d
./etc/udev/permissions.d/50-udev.permissions
./etc/udev/rules.d
./etc/udev/rules.d/40-multipath.rules
./etc/udev/rules.d/50-udev.rules
./init
./sys
./proc
./sysroot
./cpio
./loopfs
./dev
./dev/tty2
./dev/console
./dev/tty4
./dev/tty1
./dev/ram
./dev/tty3
./dev/null
./dev/systty
./sbin
/bin
./bin/insmod
./bin/multipath
./bin/modprobe
./bin/udevstart
./bin/hotplug
./bin/dmsetup
./bin/scsi_id
./bin/nash
./bin/udev
./bin/kpartx
./lib
./lib/dm-multipath.ko
./lib/qla2300.ko
./lib/scsi_mod.ko
./lib/multipath.ko
./lib/scsi_transport_fc.ko
./lib/dm-round-robin.ko
./lib/ext3.ko
./lib/dm-zero.ko
./lib/jbd.ko
./lib/qla2xxx.ko
./lib/sd_mod.ko
./lib/dm-mod.ko

My /boot/grub/menu.lst looks like
title RHEL4 U4 -SANBOOT=20
        root (hd0,0)
        kernel /vmlinuz ro
root=3D/dev/mapper/3600508b400102be10000100023750000p2  rhgb quiet
        initrd /initrdsb

But during the boot time I am getting "kernel panic" with message as
"mount: error  mounting ext3 ".  Please let me know if Device-Mapper
multipath can claim the system disk for creating  dm device ?=20

Thanks and Regards,
Vijay

------_=_NextPart_001_01C69AC4.4198EA5E
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7651.16">
<TITLE>[dm-devel] Boot from SAN with device-mapper-multipath =
device</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I am trying boot from SAN with =
DM-multipath devices as a root device. My initrd images&nbsp; contains =
following files :</FONT>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/multipath.conf</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/scsi_id.config</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/udev</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/udev/devices</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/udev/scripts</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/scripts/ide-media.sh</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/scripts/check-cdrom.sh</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/scripts/MAKEDEV.dev</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/scripts/pam_console.dev</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/scripts/hotplug.dev</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/udev/permissions.d</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/permissions.d/50-udev.permissions</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./etc/udev/rules.d</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/rules.d/40-multipath.rules</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./etc/udev/rules.d/50-udev.rules</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./init</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./sys</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./proc</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./sysroot</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./cpio</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./loopfs</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/tty2</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/console</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/tty4</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/tty1</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/ram</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/tty3</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/null</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./dev/systty</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./sbin</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">/bin</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/insmod</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/multipath</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/modprobe</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/udevstart</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/hotplug</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/dmsetup</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/scsi_id</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/nash</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/udev</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./bin/kpartx</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/dm-multipath.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/qla2300.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/scsi_mod.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/multipath.ko</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">./lib/scsi_transport_fc.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/dm-round-robin.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/ext3.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/dm-zero.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/jbd.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/qla2xxx.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/sd_mod.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">./lib/dm-mod.ko</FONT></I>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">My /boot/grub/menu.lst looks =
like</FONT>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">title RHEL4 U4 -SANBOOT </FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; root =
(hd0,0)</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kernel =
/vmlinuz ro root=3D/dev/mapper/3600508b400102be10000100023750000p2&nbsp; =
rhgb quiet</FONT></I>

<BR><I><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; initrd =
/initrdsb</FONT></I>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">But during the boot time I am getting =
&quot;kernel panic&quot; with message as &quot;mount: error&nbsp; =
mounting ext3 &quot;.&nbsp; Please let me know if Device-Mapper =
multipath can claim the system disk for creating&nbsp; dm device ? =
</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Thanks and Regards,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Vijay</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C69AC4.4198EA5E--


--===============0040306710==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0040306710==--
