From: "Arumugam, Anburaja (STSD)" <anburaja.arumugam@hp.com>
Subject: RE: Issue in Root partition from SAN as
	device-mapper-multipath device
Date: Thu, 29 Jun 2006 21:00:06 +0530
Message-ID: <7EB526165496DF4ABE1A64C5CE0BB59B02F3D435@bgeexc01.asiapacific.cpqcorp.net>
References: <58FE8766C9D3FE4E8AF6B6B75A74AF8F061F0749@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0278446879=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <58FE8766C9D3FE4E8AF6B6B75A74AF8F061F0749@BGEEXC02.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0278446879==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C69B90.E630D0B0"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C69B90.E630D0B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Hi,
>=20
We are trying to get the root partition in a multipath device from a
SAN, in RHEL 4 U4 Beta. For this we have done the following things:

1. We set up a boot from SAN environment, with 3 partitions(/boot, /,
swap respectively) from a LUN on the SAN.
2. Without DM multipath, in GRUB.conf we had the parameter as
root=3D/dev/sda2, and it worked fine as expected
3. We want to set the / partition as a DM multipath device, and we
repackaged the initrd with the following as we felt these are required
by DM multipath to work at boot time:
3.1 modules in lib: dm-multipath.ko, multipath.ko, dm-round-robin.ko,
dm-zero.ko, dm-mod.ko
3.2 binaries in sbin (all static binaries): dmsetup, multipath, kpartx
3.2 config files in etc: multipath.conf, scsi_id.config,
40-multipath.rules
4. Our modified  init script in initrd looks as ;
.........
echo "Loading jbd.ko module"
insmod /lib/jbd.ko
echo "Loading ext3.ko module"
insmod /lib/ext3.ko
/sbin/udevstart
echo "Loading DM Module"
insmod /lib/dm-mod.ko
echo "Loading DM Multipath Module"
insmod /lib/dm-multipath.ko
echo "Execution multipath binary with v0"
/sbin/multipath -v 0
echo "Execution dmsetup"
/sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a"
echo Creating root device
mkrootdev /dev/root
umount /sys
echo Mounting root filesystem
mount -o defaults --ro -t ext3 /dev/root /sysroot
mount -t tmpfs --bind /dev /sysroot/dev
echo Switching to new root
switchroot /sysroot
umount /initrd/dev
5. Having the UUID returned by scsi_id for the root Lun is,
3600508b400102be10000100023750000, in GRUB.conf, we changed the
parameter as root=3D/dev/mapper/3600508b400102be10000100023750000p2=20
6. rebooted the host, and it gave the following error.
"No devices found"
"mount: error  mounting ext3"

The reason behind this is as you know, No DM multipath device has been
created under /dev/mapper/ for root partition from the Lun, its unable
to mount the root '/' file system.

Can anyone help us by letting us know that, what are we missing in our
approach to create the DM multipath mapped devices for the root
partition diuring boot?

Thanks for your valuable inputs.

Regards,
Anbu

------_=_NextPart_001_01C69B90.E630D0B0
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
<TITLE>RE: [dm-devel] Issue in Root partition from SAN as =
device-mapper-multipath device</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi,</FONT>
</P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">We are trying to get =
the root partition in a multipath device from a SAN, in RHEL 4 U4 Beta. =
For this we have done the following things:</FONT></P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">1. We set up a boot =
from SAN environment, with 3 partitions(/boot, /, swap respectively) =
from a LUN on the SAN.</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">2. Without DM =
multipath, in GRUB.conf we had the parameter as root=3D/dev/sda2, and it =
worked fine as expected</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">3. We want to set =
the / partition as a DM multipath device, and we repackaged the initrd =
with the following as we felt these are required by DM multipath to work =
at boot time:</FONT></P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">3.1 modules in =
lib:</FONT><I> <FONT SIZE=3D2 FACE=3D"Arial">dm-multipath.ko, =
multipath.ko, dm-round-robin.ko, dm-zero.ko, dm-mod.ko</FONT></I>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">3.2 binaries in sbin =
(all static binaries):</FONT><I> <FONT SIZE=3D2 FACE=3D"Arial">dmsetup, =
multipath, kpartx</FONT></I>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">3.2 config files in =
etc:</FONT><I> <FONT SIZE=3D2 FACE=3D"Arial">multipath.conf, =
scsi_id.config, 40-multipath.rules</FONT></I>

<BR><FONT SIZE=3D2 FACE=3D"Arial">4. Our modified&nbsp; init script in =
initrd looks as ;</FONT><I></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">&#8230;&#8230;&#8230;</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo &quot;Loading jbd.ko =
module&quot;</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">insmod /lib/jbd.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo &quot;Loading ext3.ko =
module&quot;</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">insmod /lib/ext3.ko</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">/sbin/udevstart</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo &quot;Loading DM =
Module&quot;</FONT></I>

<BR><I><B><FONT SIZE=3D2 FACE=3D"Arial">insmod =
/lib/dm-mod.ko</FONT></B></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo &quot;Loading DM Multipath =
Module&quot;</FONT></I>

<BR><I><B><FONT SIZE=3D2 FACE=3D"Arial">insmod =
/lib/dm-multipath.ko</FONT></B></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo &quot;Execution multipath =
binary with v0&quot;</FONT></I>

<BR><I><B><FONT SIZE=3D2 FACE=3D"Arial">/sbin/multipath -v =
0</FONT></B></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo &quot;Execution =
dmsetup&quot;</FONT></I>

<BR><I><B><FONT SIZE=3D2 FACE=3D"Arial">/sbin/dmsetup ls --target =
multipath --exec &quot;/sbin/kpartx -a&quot;</FONT></B></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo Creating root =
device</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">mkrootdev /dev/root</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">umount /sys</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo Mounting root =
filesystem</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">mount -o defaults --ro -t ext3 =
/dev/root /sysroot</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">mount -t tmpfs --bind /dev =
/sysroot/dev</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">echo Switching to new =
root</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">switchroot /sysroot</FONT></I>

<BR><I><FONT SIZE=3D2 FACE=3D"Arial">umount /initrd/dev</FONT></I>

<BR><FONT SIZE=3D2 FACE=3D"Arial">5. Having the UUID returned by scsi_id =
for the root Lun is,</FONT><I> <FONT SIZE=3D2 =
FACE=3D"Arial">3600508b400102be10000100023750000,</FONT></I> <FONT =
COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">in GRUB.conf, we changed the =
parameter as root=3D/dev/mapper/</FONT><I><FONT SIZE=3D2 =
FACE=3D"Arial">3600508b400102be10000100023750000p2</FONT></I><FONT =
COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial"></FONT> </P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">6. rebooted the host, =
and it gave the following error.</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">&quot;No devices =
found&quot;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&quot;mount: error&nbsp; mounting =
ext3&quot;</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">The reason behind this is as you know, =
No DM multipath device has been created under /dev/mapper/ for root =
partition from the Lun, its unable to mount the root '/' file =
system.</FONT></P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">Can anyone help us by =
letting us know that, what are we missing in our approach to create the =
DM multipath mapped devices for the root partition diuring =
boot?</FONT></P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">Thanks for your =
valuable inputs.</FONT>
</P>

<P><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">Regards,</FONT>

<BR><FONT COLOR=3D"#0000FF" SIZE=3D2 FACE=3D"Arial">Anbu</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C69B90.E630D0B0--


--===============0278446879==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0278446879==--
