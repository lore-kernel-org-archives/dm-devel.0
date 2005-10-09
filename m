From: "Kin Yip" <kinyip@bnl.gov>
Subject: /dev/mapper/nvidia_bafieldbg screws up my harddisk mount
Date: Sun, 9 Oct 2005 09:20:33 -0400
Message-ID: <034a01c5ccd4$3a742370$2f01a8c0@cad.bnl.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1684032376=="
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1684032376==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0346_01C5CCB2.B3255360"

This is a multi-part message in MIME format.

------=_NextPart_000_0346_01C5CCB2.B3255360
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

I have a new DELL Precision n470 and I used the RedHat WS4 Linux (kernel =
2.6.9-22ELsmp).

I've just found that I can't mount my 2nd harddisk /dev/sdb1.  Somehow, =
your dev-mapper
would pick up whatever label that I make with the harddisk --- I have =
changed the disk=20
label with e2label a couple times and reboot.

If I do,
mount -L /mnt/disk2

I'd get the message:
mount: the label /mnt/disk2 occurs on both /dev/sdb1 and =
/dev/mapper/nvidia_bafiedbg1 - not mounted
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This is the case even if I "e2label" the harddisk to something and =
reboot.

Under /dev/mapper, do a "ls -l", I see :

total 0
crw-------  1 root root  10, 63 Oct  9 08:47 control
brw-rw----  1 root disk 253,  0 Oct  9 08:47 nvidia_bafiedbg
brw-rw----  1 root disk 253,  1 Oct  9 08:47 nvidia_bafiedbg1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

If I do "umount -v /mnt/disk2", I see the message:

Could not find /mnt/disk2 in mtab
umount: /mnt/disk2: not mounted
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D


My /etc/fstab looks like :
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D my =
/etc/fstab =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
# This file is edited by fstab-sync - see 'man fstab-sync' for details
LABEL=3D/                 /                       ext3    defaults       =
 1 1
LABEL=3D/boot             /boot                   ext3    defaults       =
 1 2
none                    /dev/pts                devpts  =
gid=3D5,mode=3D620  0 0
#none                    /proc                   proc    defaults        =
0 0
#none                    /sys                    sysfs   defaults        =
0 0
none                    /dev/shm                tmpfs   defaults        =
0 0
LABEL=3DSWAP-sda6         swap                    swap    defaults       =
 0 0
/dev/sdb1               /mnt/disk2                  ext3    defaults     =
   1 2
/dev/hdc                /media/cdrecorder       auto    =
pamconsole,fscontext=3Dsystem_u:object_r:removable_t,exec,noauto,managed =
0 0
/dev/fd0                /media/floppy           auto    =
pamconsole,fscontext=3Dsystem_u:object_r:removable_t,exec,noauto,managed =
0 0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Can you offer some advice or suggestion to fix this problem ?

Kin
------=_NextPart_000_0346_01C5CCB2.B3255360
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2900.2722" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT size=3D2>Hi,</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I have a new DELL Precision n470 and I used the =
RedHat=20
WS4&nbsp;Linux (kernel 2.6.9-22ELsmp).</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I've just found that I can't mount my 2nd harddisk=20
/dev/sdb1.&nbsp; Somehow, your dev-mapper</FONT></DIV>
<DIV><FONT size=3D2>would pick up whatever label that I make with the =
harddisk ---=20
I have&nbsp;changed&nbsp;the disk&nbsp;</FONT></DIV>
<DIV><FONT size=3D2>label&nbsp;with e2label a couple times and=20
reboot.</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>If I do,</FONT></DIV>
<DIV><FONT size=3D2>mount -L /mnt/disk2</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I'd get the message:</FONT></DIV>
<DIV><FONT size=3D2>mount: the label /mnt/disk2 occurs on both /dev/sdb1 =
and=20
/dev/mapper/nvidia_bafiedbg1 - not mounted</FONT></DIV>
<DIV><FONT=20
size=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>This is the case even if I "e2label" the harddisk to =
something=20
and reboot.</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>Under /dev/mapper, do a "ls -l", I see =
:</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>total 0<BR>crw-------&nbsp; 1 root root&nbsp; 10, 63 =
Oct&nbsp;=20
9 08:47 control<BR>brw-rw----&nbsp; 1 root disk 253,&nbsp; 0 Oct&nbsp; 9 =
08:47=20
nvidia_bafiedbg<BR>brw-rw----&nbsp; 1 root disk 253,&nbsp; 1 Oct&nbsp; 9 =
08:47=20
nvidia_bafiedbg1<BR>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>If I do "umount -v /mnt/disk2", I see the=20
message:</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>Could not find /mnt/disk2 in mtab<BR>umount: =
/mnt/disk2: not=20
mounted<BR>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D</DIV></FONT>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>My /etc/fstab looks like :</FONT></DIV>
<DIV><FONT =
size=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
my /etc/fstab=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D</DIV></FONT>
<DIV><FONT size=3D2># This file is edited by fstab-sync - see 'man =
fstab-sync' for=20
details<BR>LABEL=3D/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
ext3&nbsp;&nbsp;&nbsp; =
defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1=20
1<BR>LABEL=3D/boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;=20
/boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
ext3&nbsp;&nbsp;&nbsp; =
defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1=20
2<BR>none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/dev/pts&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
devpts&nbsp; gid=3D5,mode=3D620&nbsp; 0=20
0<BR>#none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/proc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
proc&nbsp;&nbsp;&nbsp; =
defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0=20
0<BR>#none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/sys&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
sysfs&nbsp;&nbsp; defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0=20
0<BR>none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/dev/shm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
tmpfs&nbsp;&nbsp; defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0=20
0<BR>LABEL=3DSWAP-sda6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
swap&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
swap&nbsp;&nbsp;&nbsp; =
defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0=20
0<BR>/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
/mnt/disk2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
ext3&nbsp;&nbsp;&nbsp; =
defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1=20
2<BR>/dev/hdc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/media/cdrecorder&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
auto&nbsp;&nbsp;&nbsp;=20
pamconsole,fscontext=3Dsystem_u:object_r:removable_t,exec,noauto,managed =
0=20
0<BR>/dev/fd0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/media/floppy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
=20
auto&nbsp;&nbsp;&nbsp;=20
pamconsole,fscontext=3Dsystem_u:object_r:removable_t,exec,noauto,managed =
0=20
0<BR>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>Can you offer some advice or suggestion to fix this =
problem=20
?</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>Kin</FONT></DIV></BODY></HTML>

------=_NextPart_000_0346_01C5CCB2.B3255360--


--===============1684032376==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1684032376==--
