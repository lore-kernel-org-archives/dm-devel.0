From: =?big5?B?TWljaGFlbCBZYW8gLavAp9O/sg==?= <Michael.Yao@zyxel.com.tw>
Subject: RE: [EVMS][XFS][DM] We cannot create XFS file system on
	theevms volume larger than 1TB
Date: Fri, 28 Apr 2006 18:03:26 +0800
Message-ID: <F83807D84DBD9B4B81E807D7A58250FA0F157C@zytwbe01.ZyXEL.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1762295350=="
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

--===============1762295350==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C66AAA.FE392A9F"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C66AAA.FE392A9F
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

HI

Can anyone help me with this ?

mkfs.xfs uses the BLKGETSIZE64 ioctl to get the device size;=20

        error =3D ioctl(fd, BLKGETSIZE64, &size);

returns "size" in bytes.

=20

This looks like a devicemapper bug, in dm_blk_ioctl() they're assigning =
a full unsigned 32 bits of device size to a signed 32 bit size, and =
start running into trouble with sign extension when they cast it up.

http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D646

=20

--

Best regards, Michael Yao

=20

=20

________________________________

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Michael Yao -=AB=C0=A7=D3=BF=B2
Sent: Thursday, April 13, 2006 5:06 PM
To: dm-devel@redhat.com
Cc: Chia Chao -=BB=AF=B9=C5=B1j; Alex Cheng -=BEG=B4=BC=A4=AF
Subject: [dm-devel] [EVMS][XFS][DM] We cannot create XFS file system on =
theevms volume larger than 1TB

=20

=20

Hi, I have FOUR 500GB SATA hard disks.

I created a 1.4TB evms volume, and it failed when I want to make XFS =
filesystem on it.=20

These are the snapshots:

root@2TB:~# mkfs.xfs -f -L volume1 /dev/evms/volume1

meta-data=3D/dev/evms/volume1      isize=3D256    agcount=3D4294967134, =
agsize=3D1048576 blks

         =3D                       sectsz=3D512

data     =3D                       bsize=3D4096   =
blocks=3D4503599456772095, imaxpct=3D25

         =3D                       sunit=3D0      swidth=3D0 blks, =
unwritten=3D1

naming   =3Dversion 2              bsize=3D4096

log      =3Dinternal log           bsize=3D4096   blocks=3D32768, =
version=3D1

         =3D                       sectsz=3D512   sunit=3D0 blks

realtime =3Dnone                   extsz=3D65536  blocks=3D0, =
rtextents=3D0

mkfs.xfs: pwrite64 failed: Invalid argument

root@2TB:~# mkfs.xfs -f -L volume1 -d size=3D100m /dev/evms/volume1

meta-data=3D/dev/evms/volume1      isize=3D256    agcount=3D6, =
agsize=3D4267 blks

         =3D                       sectsz=3D512

data     =3D                       bsize=3D4096   blocks=3D25600, =
imaxpct=3D25

         =3D                       sunit=3D0      swidth=3D0 blks, =
unwritten=3D1

naming   =3Dversion 2              bsize=3D4096

log      =3Dinternal log           bsize=3D4096   blocks=3D1200, =
version=3D1

         =3D                       sectsz=3D512   sunit=3D0 blks

realtime =3Dnone                   extsz=3D65536  blocks=3D0, =
rtextents=3D0

mkfs.xfs: pwrite64 failed: Invalid argument

=20

4503599456772095 probably isn't correct, it should be 357687.

It seems to have a disconnection between what evms is reporting for the =
size of the partition and what mkfs is getting.=20

And it won=A1=A6t happen in non-EVMS/DM devices.

As described in http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D267=20

=20

Setup: device-mapper 1.01.05/Driver version 4.1.1, evms2.5.5, linux =
2.4.31

=20

And these are the evms commands:

asm:DosSegMgr=3D{}, sda

asm:DosSegMgr=3D{}, sdb

asm:DosSegMgr=3D{}, sdc

asm:DosSegMgr=3D{}, sdd

create: Segment, sda_freespace1, primary=3Dfalse

create: Segment, sdb_freespace1, primary=3Dfalse

create: Segment, sdc_freespace1, primary=3Dfalse

create: Segment, sdd_freespace1, primary=3Dfalse

create: Region, MDRaid5RegMgr=3D{}, sda5, sdb5, sdc5, sdd5

create: Container, LvmRegMgr=3D{name=3D"Con_volume1", pe_size=3D32MB}, =
md/md0

create: Region, LvmRegMgr=3D{name=3D"Reg_volume1", size=3D1.4TB}, =
"lvm/Con_volume1/Freespace"

create: Volume, "lvm/Con_volume1/Reg_volume1", Name=3D"volume1=A1=A7

mkfs: XFS=3D{vollabel=3Dvolume1}, /dev/evms/volume1

=20

--

Best regards, Michael Yao

=20


------_=_NextPart_001_01C66AAA.FE392A9F
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:p=3D"urn:schemas-microsoft-com:office:powerpoint" =
xmlns:oa=3D"urn:schemas-microsoft-com:office:activation" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dbig5">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]--><o:SmartTagType
 namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags" =
name=3D"chsdate"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"chmetcnv"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:=B7s=B2=D3=A9=FA=C5=E9;
	panose-1:2 2 3 0 0 0 0 0 0 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"\@=B7s=B2=D3=A9=FA=C5=E9";
	panose-1:2 2 3 0 0 0 0 0 0 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal;
	font-family:Arial;
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:18.0pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DZH-TW link=3Dblue vlink=3Dpurple =
style=3D'text-justify-trim:punctuation'>

<div class=3DSection1 style=3D'layout-grid:18.0pt'>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>HI<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>Can anyone help =
me with
this ?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>mkfs.xfs uses the
BLKGETSIZE64 ioctl to get the device size; <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;
error =3D ioctl(fd, BLKGETSIZE64, =
&amp;size);<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>returns =
&quot;size&quot;
in bytes.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>This looks like a
devicemapper bug, in dm_blk_ioctl() they're assigning a full unsigned 32 =
bits
of device size to a signed 32 bit size, and start running into trouble =
with
sign extension when they cast it up.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'><a
href=3D"http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D646">http://oss.sgi=
.com/bugzilla/show_bug.cgi?id=3D646</a><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>--<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'>Best regards, =
Michael Yao<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dnavy face=3DArial><span =
lang=3DEN-US
style=3D'font-size:9.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p><=
/span></font></p>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D=B7s=B2=D3=A9=FA=C5=E9><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:=B7s=B2=D3=A9=FA=C5=E9'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span lang=3DEN-US
style=3D'font-size:10.0pt;font-family:Tahoma;font-weight:bold'>From:</spa=
n></font></b><font
size=3D2 face=3DTahoma><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
<b><span
style=3D'font-weight:bold'>On Behalf Of </span></b><st1:PersonName =
w:st=3D"on">Michael
 Yao -<font face=3D=B7s=B2=D3=A9=FA=C5=E9><span lang=3DEN-US =
style=3D'font-family:=B7s=B2=D3=A9=FA=C5=E9'><span
 =
lang=3DEN-US>=AB=C0=A7=D3=BF=B2</span></span></font></st1:PersonName><br>=

<b><span style=3D'font-weight:bold'>Sent:</span></b> Thursday, April 13, =
2006
5:06 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> =
dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Cc:</span></b> Chia Chao =
-</span></font><font
size=3D2 face=3D=B7s=B2=D3=A9=FA=C5=E9><span =
style=3D'font-size:10.0pt;font-family:=B7s=B2=D3=A9=FA=C5=E9'>=BB=AF=B9=C5=
=B1j</span></font><font
size=3D2 face=3DTahoma><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:Tahoma'>;
<st1:PersonName w:st=3D"on">Alex Cheng -<font =
face=3D=B7s=B2=D3=A9=FA=C5=E9><span lang=3DEN-US
 style=3D'font-family:=B7s=B2=D3=A9=FA=C5=E9'><span =
lang=3DEN-US>=BEG=B4=BC=A4=AF</span></span></font></st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel]
[EVMS][XFS][DM] We cannot create XFS file system on theevms volume =
larger than
1TB</span></font><font face=3D=B7s=B2=D3=A9=FA=C5=E9><span lang=3DEN-US =
style=3D'font-family:=B7s=B2=D3=A9=FA=C5=E9'><o:p></o:p></span></font></p=
>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>Hi, I have FOUR 500GB SATA hard =
disks.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>I created a 1.4TB evms volume, and it failed =
when I
want to make XFS filesystem on it. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>These are the =
snapshots:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>root@2TB:~# mkfs.xfs -f -L volume1 =
/dev/evms/volume1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>meta-data=3D/dev/evms/volume1&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;
isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D4294967134, agsize=3D1048576 =
blks<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
sectsz=3D512<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>data&nbsp;&nbsp;&nbsp;&nbsp;
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
bsize=3D4096&nbsp;&nbsp; blocks=3D4503599456772095, =
imaxpct=3D25<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
sunit=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=3D0 blks, =
unwritten=3D1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>naming&nbsp;&nbsp; =3Dversion
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;
bsize=3D4096<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3Dinternal
log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
bsize=3D4096&nbsp;&nbsp; blocks=3D32768, =
version=3D1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
sectsz=3D512&nbsp;&nbsp; sunit=3D0 blks<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>realtime
=3Dnone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
extsz=3D65536&nbsp; blocks=3D0, =
rtextents=3D0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>mkfs.xfs: pwrite64 failed: Invalid =
argument<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>root@2TB:~# mkfs.xfs -f -L volume1 -d =
size=3D<st1:chmetcnv
TCSC=3D"0" NumberType=3D"1" Negative=3D"False" HasSpace=3D"False" =
SourceValue=3D"100"
UnitName=3D"m" w:st=3D"on">100m</st1:chmetcnv> =
/dev/evms/volume1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>meta-data=3D/dev/evms/volume1&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;
isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D6, agsize=3D4267 =
blks<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
sectsz=3D512<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>data&nbsp;&nbsp;&nbsp;&nbsp;
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
bsize=3D4096&nbsp;&nbsp; blocks=3D25600, =
imaxpct=3D25<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
sunit=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=3D0 blks, =
unwritten=3D1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>naming&nbsp;&nbsp; =3Dversion
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;
bsize=3D4096<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3Dinternal
log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
bsize=3D4096&nbsp;&nbsp; blocks=3D1200, =
version=3D1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
sectsz=3D512&nbsp;&nbsp; sunit=3D0 blks<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>realtime
=3Dnone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
extsz=3D65536&nbsp; blocks=3D0, =
rtextents=3D0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>mkfs.xfs: pwrite64 failed: Invalid =
argument<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>4503599456772095 probably isn't correct, it =
should be
357687.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>It seems to have a disconnection between what =
evms is
reporting for the size of the partition and what mkfs is getting. =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>And it won=A1=A6t happen in non-EVMS/DM =
devices.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>As described in <a
href=3D"http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D267">http://oss.sgi=
.com/bugzilla/show_bug.cgi?id=3D267</a>
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>Setup: device-mapper <st1:chsdate =
IsROCDate=3D"False"
IsLunarDate=3D"False" Day=3D"30" Month=3D"12" Year=3D"1899" =
w:st=3D"on">1.01.05</st1:chsdate>/Driver
version 4.1.1, evms2.5.5, linux 2.4.31<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>And these are the evms =
commands:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>asm:DosSegMgr=3D{}, =
sda<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>asm:DosSegMgr=3D{}, =
sdb<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>asm:DosSegMgr=3D{}, =
sdc<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>asm:DosSegMgr=3D{}, =
sdd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Segment, sda_freespace1, =
primary=3Dfalse<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Segment, sdb_freespace1, =
primary=3Dfalse<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Segment, sdc_freespace1, =
primary=3Dfalse<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Segment, sdd_freespace1, =
primary=3Dfalse<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Region, MDRaid5RegMgr=3D{}, sda5, sdb5, =
sdc5,
sdd5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Container,
LvmRegMgr=3D{name=3D&quot;Con_volume1&quot;, pe_size=3D32MB}, =
md/md0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Region, =
LvmRegMgr=3D{name=3D&quot;Reg_volume1&quot;,
size=3D1.4TB}, =
&quot;lvm/Con_volume1/Freespace&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>create: Volume,
&quot;lvm/Con_volume1/Reg_volume1&quot;, =
Name=3D&quot;volume1=A1=A7<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'>mkfs: XFS=3D{vollabel=3Dvolume1}, =
/dev/evms/volume1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.0pt'>--</span></font><span =
lang=3DEN-US><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.0pt'>Best regards, Michael Yao</span></font><span
lang=3DEN-US><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C66AAA.FE392A9F--


--===============1762295350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1762295350==--
