From: "Charles Polk" <Charles.Polk@vion.com>
Subject: IHAQ
Date: Wed, 30 Aug 2006 13:30:21 -0400
Message-ID: <7221D0B8D5D73A4F81D21DFE8332D12C7AC50A@condor.www.vionnet.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0521102030=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0521102030==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6CC59.F8722D53"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6CC59.F8722D53
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I am currently running KERNEL 2.6.9-22.0.2.EL #1 SMP on a FUJITSU
PRIMEQUEST.(IA64)

=20

I have installed;
device-mapper-1.02.07-4.0.RHEL.ia64.rpm

=20
device-mapper-multipath-0.4.5-16.1.RHEL4

=20

I ran the required scripts:           modprobe dm-multipath

                                                modprobe dm-round-robin

                                                service multipathd start

                                                multipath -v2

=20

Result:  For some reason the disks do not multi-path and I keep getting =
the
following errors and the multi-pathing will not work.  Is there anyone =
that
has an idea why?  Any help is appreciated.

=20

COMMAND:  #dmesg (at the bottom)

OUTPUT:       =20

FAT: Directory bread(block 275) failed

scsi22 (0:0): rejecting I/O to dead device

FAT: Directory bread(block 276) failed

scsi22 (0:0): rejecting I/O to dead device

FAT: Directory bread(block 277) failed

scsi22 (0:0): rejecting I/O to dead device

FAT: Directory bread(block 278) failed

=20

COMMAND: #lsmod

Module                  Size  Used by

nls_utf8               11360  1=20

dm_round_robin         14376  0=20

dm_multipath           51976  1 dm_round_robin

md5                    17624  1=20

ipv6                  654916  70=20

autofs4                51552  0=20

sunrpc                347144  1=20

ipmi_watchdog          39305  1=20

mptctl                 71868  0=20

ipmi_devintf           23888  2=20

ipmi_si                82376  2=20

ipmi_msghandler        73832  3 ipmi_watchdog,ipmi_devintf,ipmi_si

ds                     43016  0=20

yenta_socket           49300  0=20

pcmcia_core           142856  2 ds,yenta_socket

lpfcdfc               402644  0=20

vfat                   37894  2=20

fat                    99480  1 vfat

dm_mod                142824  2 dm_multipath

button                 21176  0=20

joydev                 28432  0=20

sr_mod                 48040  1=20

usb_storage           148104  2=20

uhci_hcd               78296  0=20

ehci_hcd               82044  0=20

e1000                 260700  0=20

tg3                   216160  0=20

e100                   84326  0=20

mii                    18296  1 e100

sg                     90320  0=20

ext3                  290232  5=20

jbd                   147880  1 ext3

lpfc                  358584  21=20

scsi_transport_fc      25128  2 lpfcdfc,lpfc

mptscsih               93828  0=20

mptbase               133440  2 mptctl,mptscsih

sd_mod                 43580  27=20

scsi_mod              242888  8

=20

COMMAND: fdisk -l

OUTPUT:

Disk /dev/sda: 73.4 GB, 73497833472 bytes

154 heads, 42 sectors/track, 22193 cylinders

Units =3D cylinders of 6468 * 512 =3D 3311616 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sda1               1       22194    71775227+  ee  EFI GPT

=20

Disk /dev/sdb: 73.4 GB, 73497833472 bytes

154 heads, 42 sectors/track, 22193 cylinders

Units =3D cylinders of 6468 * 512 =3D 3311616 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdb1               1       22194    71775227+  ee  EFI GPT

=20

Disk /dev/sdc: 73.4 GB, 73497833472 bytes

255 heads, 63 sectors/track, 8935 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdc1               1        8936    71775227+  ee  EFI GPT

=20

Disk /dev/sdd: 73.4 GB, 73497833472 bytes

255 heads, 63 sectors/track, 8935 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdd1               1        8936    71775227+  ee  EFI GPT

=20

Disk /dev/sde: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sde1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdf: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdf1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdg: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdg1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdh: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdh1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdi: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdi1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdj: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdj1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdk: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdk1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdl: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdl1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdm: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdm1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdn: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdn1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdo: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdo1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdp: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdp1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdq: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdq1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdr: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdr1               1      262175  2105920656   83  Linux

=20

Disk /dev/sds: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sds1               1      262175  2105920656   83  Linux

=20

Disk /dev/sdt: 2156.4 GB, 2156467322880 bytes

255 heads, 63 sectors/track, 262175 cylinders

Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=20

   Device Boot      Start         End      Blocks   Id  System

/dev/sdt1               1      262175  2105920656   83  Linux

=20

COMMAND: cat /var/log/messages

OUTPUT

=20

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O to dead =
device

Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block 273) =
failed

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O to dead =
device

Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block 274) =
failed

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O to dead =
device

Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block 275) =
failed

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O to dead =
device

Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block 276) =
failed

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O to dead =
device

Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block 277) =
failed

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O to dead =
device

Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block 278) =
failed

Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:46 primequest logger: Waiting for filesystem containing
/oracle1/app/oracle/product/10.1.0/bin/crsctl.

Aug 29 15:46:46 primequest FJSVpsa: W 14078 Software scsi: Software =
error
(rejecting I/O to dead device)

Aug 29 15:46:46 primequest last message repeated 3 times

Aug 29 15:46:51 primequest logger: Waiting for filesystem containing
/oracle1/app/oracle/product/10.1.0/bin/crsctl.

=20

=20

=20

=20

=20


------_=_NextPart_001_01C6CC59.F8722D53
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
pre
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I am currently running KERNEL 2.6.9-22.0.2.EL #1 SMP =
on a
FUJITSU PRIMEQUEST.(IA64)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I have installed; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
device-mapper-1.02.07-4.0.RHEL.ia64.rpm<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
device-mapper-multipath-0.4.5-16.1.RHEL4<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>I ran the required =
scripts:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
modprobe
dm-multipath<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
modprobe
dm-round-robin<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
service
multipathd start<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
multipath
-v2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>Result:&nbsp; For some reason the disks do not multi-path and I =
keep
getting the following errors and the multi-pathing will not work.&nbsp; =
Is
there anyone that has an idea why?&nbsp; Any help is =
appreciated.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>COMMAND:<b><span style=3D'font-weight:bold'>&nbsp; #dmesg (at =
the bottom)<o:p></o:p></span></b></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>OUTPUT:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>FAT: Directory bread(block 275) =
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>scsi22 (0:0): rejecting I/O to dead =
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>FAT: Directory bread(block 276) =
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>scsi22 (0:0): rejecting I/O to dead =
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>FAT: Directory bread(block 277) =
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>scsi22 (0:0): rejecting I/O to dead =
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>FAT: Directory bread(block 278) =
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D4 face=3D"Courier New"><span =
style=3D'font-size:
14.0pt'>COMMAND: #lsmod<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>Module&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Size&nbsp; Used by<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>nls_utf8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;
11360&nbsp; 1 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>dm_round_robin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
14376&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>dm_multipath&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;
51976&nbsp; 1 dm_round_robin<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>md5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
17624&nbsp; 1 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ipv6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
654916&nbsp; 70 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>autofs4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
51552&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>sunrpc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
347144&nbsp; 1 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ipmi_watchdog&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;
39305&nbsp; 1 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>mptctl&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
71868&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ipmi_devintf&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;
23888&nbsp; 2 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ipmi_si&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
82376&nbsp; 2 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ipmi_msghandler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
73832&nbsp; 3
ipmi_watchdog,ipmi_devintf,ipmi_si<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ds&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
43016 &nbsp;0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>yenta_socket&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;
49300&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>pcmcia_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
142856&nbsp; 2 ds,yenta_socket<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>lpfcdfc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
402644&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>vfat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
37894&nbsp; 2 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>fat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
99480&nbsp; 1 vfat<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
142824&nbsp; 2 dm_multipath<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>button&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
21176&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>joydev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
28432&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>sr_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
48040&nbsp; 1 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>usb_storage&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
148104&nbsp; 2 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>uhci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;
78296&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ehci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;
82044&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>e1000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
260700&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>tg3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
216160&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>e100&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
84326&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>mii&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
18296&nbsp; 1 e100<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
90320&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>ext3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
290232&nbsp; 5 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>jbd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
147880&nbsp; 1 ext3<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>lpfc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
358584&nbsp; 21 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>scsi_transport_fc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25128&nbsp; 2
lpfcdfc,lpfc<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>mptscsih&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;
93828&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>mptbase&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
133440&nbsp; 2 mptctl,mptscsih<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>sd_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
43580&nbsp; 27 <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'>scsi_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;
242888&nbsp; 8<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><b><font size=3D3 face=3D"Courier New"><span
style=3D'font-size:12.0pt;font-weight:bold'>COMMAND: fdisk =
&#8211;l<o:p></o:p></span></font></b></p>

<p class=3DMsoPlainText><b><font size=3D3 face=3D"Courier New"><span
style=3D'font-size:12.0pt;font-weight:bold'>OUTPUT:<o:p></o:p></span></fo=
nt></b></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sda: 73.4 GB, 73497833472 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>154 heads, 42 sectors/track, 22193 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 6468 * 512 =3D 3311616 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22194&nbsp;&nbsp;&nbsp; =
71775227+&nbsp;
ee &nbsp;EFI GPT<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdb: 73.4 GB, 73497833472 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>154 heads, 42 sectors/track, 22193 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 6468 * 512 =3D 3311616 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22194&nbsp;&nbsp;&nbsp; =
71775227+&nbsp;
ee&nbsp; EFI GPT<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdc: 73.4 GB, 73497833472 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 8935 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id =
&nbsp;System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdc1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8936&nbsp;&nbsp;&nbsp;
71775227+&nbsp; ee&nbsp; EFI GPT<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdd: 73.4 GB, 73497833472 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 8935 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdd1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8936&nbsp;&nbsp;&nbsp;
71775227+&nbsp; ee&nbsp; EFI GPT<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sde: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Blocks&nbsp;&nbsp; Id&nbsp; System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sde1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdf: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdf1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdg: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdg1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdh: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdh1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdi: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdi1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdj: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdj1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdk: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdk1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdl: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdl1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdm: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdm1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdn: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdn1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdo: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdo1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdp: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdp1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdq: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdq1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdr: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdr1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sds: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp; &nbsp;Id&nbsp; =
System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sds1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Disk /dev/sdt: 2156.4 GB, 2156467322880 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>255 heads, 63 sectors/track, 262175 =
cylinders<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>&nbsp;&nbsp; Device Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; End&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;Blocks&nbsp;&nbsp;
Id&nbsp; System<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>/dev/sdt1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 262175&nbsp; 2105920656&nbsp;&nbsp; =
83&nbsp;
Linux<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><b><font size=3D3 face=3D"Courier New"><span
style=3D'font-size:12.0pt;font-weight:bold'><o:p>&nbsp;</o:p></span></fon=
t></b></p>

<p class=3DMsoPlainText><b><font size=3D3 face=3D"Courier New"><span
style=3D'font-size:12.0pt;font-weight:bold'>COMMAND: cat =
/var/log/messages<o:p></o:p></span></font></b></p>

<p class=3DMsoPlainText><b><font size=3D3 face=3D"Courier New"><span
style=3D'font-size:12.0pt;font-weight:bold'>OUTPUT<o:p></o:p></span></fon=
t></b></p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O =
to dead
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block =
273)
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O =
to dead
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block =
274)
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O =
to dead
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block =
275)
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O =
to dead device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block =
276)
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O =
to dead
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block =
277)
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: scsi22 (0:0): rejecting I/O =
to dead
device<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest kernel: FAT: Directory bread(block =
278)
failed<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:45 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:46 primequest logger: Waiting for filesystem =
containing
/oracle1/app/oracle/product/10.1.0/bin/crsctl.<o:p></o:p></span></font></=
p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:46 primequest FJSVpsa: W 14078 Software scsi: =
Software
error (rejecting I/O to dead device)<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:46 primequest last message repeated 3 =
times<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Aug 29 15:46:51 primequest logger: Waiting for filesystem =
containing
/oracle1/app/oracle/product/10.1.0/bin/crsctl.<o:p></o:p></span></font></=
p>

<p class=3DMsoPlainText><font size=3D1 face=3D"Courier New"><span =
style=3D'font-size:
9.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D4 face=3D"Courier New"><span =
style=3D'font-size:
14.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D4 face=3D"Courier New"><span =
style=3D'font-size:
14.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C6CC59.F8722D53--


--===============0521102030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0521102030==--
