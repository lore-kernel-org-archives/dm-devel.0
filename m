From: "Ronei Kliemann" <Ronei@tscom.com.br>
Subject: Problem with HP - ML 110 G5
Date: Wed, 3 Feb 2010 17:12:38 -0200
Message-ID: <766AD601A3F2BC4BB5C12D5CC0678B0614679E@tecsystem.TecSystem.local>
Reply-To: Ronei@tscom.com.br, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2836302064690810858=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============2836302064690810858==
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CAA504.E04BB7CB"
Content-class: urn:content-classes:message

This is a multi-part message in MIME format.

------_=_NextPart_001_01CAA504.E04BB7CB
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi

=20

I am with one problem that I couldn't find solution at the intenet.=20

=20

My server is HP ML 110 G5 with Embedded Raid. By lspci , I can see that  =
it's a  "RAID bus controller: Intel Corporation 82801 SATA RAID =
Controller (rev 02)". I am using centos 5

=20

I can see that RAID is not working because there isn=B4t volume at =
/dev/mapper/, just "control".

=20

"[Backup_DrClin ~]# cd /dev/mapper/

[Backup_DrClin mapper]# ls

control

[Backup_DrClin mapper]#"

=20

=20

The device mapper was load at boot:

=20

=20

[Backup_DrClin log]# grep device-mapper dmesg

device-mapper: uevent: version 1.0.3

device-mapper: ioctl: 4.11.5-ioctl (2007-12-12) initialised: =
dm-devel@redhat.com

device-mapper: multipath: version 1.0.5 loaded

[Backup_DrClin log]#

=20

=20

I Try to activate dmraid, but no work:

=20

[Backup_DrClin mapper]# dmraid -ay

RAID set "ddf1_Raid_1_Mirror" was not activated

ERROR: device "ddf1_Raid_1_Mirror" could not be found

[Backup_DrClin mapper]#

=20

I can see at logs : (/var/log/messages

=20

Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: table: 253:0: =
mirror: Device lookup failure

Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: error adding =
target to table

Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: device =
doesn't appear to be in the dev hash table.

=20

=20

=20

More info:

=20

[Backup_DrClin log]# dmraid -s

*** Group superset .ddf1_disks

--> Subset

name   : ddf1_Raid_1_Mirror

size   : 312237824

stride : 128

type   : mirror

status : ok

subsets: 0

devs   : 2

spares : 0

[Backup_DrClin log]#

=20

[Backup_DrClin log]# dmraid -r

/dev/sda: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

/dev/sdb: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

[Backup_DrClin log]#

=20

=20

[Backup_DrClin mapper]# dmraid -rD -d -d -d -v -v -v

WARN: locking /var/lock/dmraid/.lock

NOTICE: /dev/sda: asr     discovering

NOTICE: /dev/sda: ddf1    discovering

NOTICE: creating directory dmraid.ddf1

NOTICE: writing metadata file "sda.dat"

NOTICE: writing offset to file "sda.offset"

NOTICE: writing size to file "sda.size"

NOTICE: /dev/sda: ddf1 metadata discovered

NOTICE: /dev/sda: hpt37x  discovering

NOTICE: /dev/sda: hpt45x  discovering

NOTICE: /dev/sda: isw     discovering

NOTICE: /dev/sda: jmicron discovering

NOTICE: /dev/sda: lsi     discovering

NOTICE: /dev/sda: nvidia  discovering

NOTICE: /dev/sda: pdc     discovering

NOTICE: /dev/sda: sil     discovering

NOTICE: /dev/sda: via     discovering

NOTICE: /dev/sdb: asr     discovering

NOTICE: /dev/sdb: ddf1    discovering

NOTICE: writing metadata file "sdb.dat"

NOTICE: writing offset to file "sdb.offset"

NOTICE: writing size to file "sdb.size"

NOTICE: /dev/sdb: ddf1 metadata discovered

NOTICE: /dev/sdb: hpt37x  discovering

NOTICE: /dev/sdb: hpt45x  discovering

NOTICE: /dev/sdb: isw     discovering

NOTICE: /dev/sdb: jmicron discovering

NOTICE: /dev/sdb: lsi     discovering

NOTICE: /dev/sdb: nvidia  discovering

NOTICE: /dev/sdb: pdc     discovering

NOTICE: /dev/sdb: sil     discovering

NOTICE: /dev/sdb: via     discovering

NOTICE: /dev/sdc: asr     discovering

NOTICE: /dev/sdc: ddf1    discovering

NOTICE: /dev/sdc: hpt37x  discovering

NOTICE: /dev/sdc: hpt45x  discovering

NOTICE: /dev/sdc: isw     discovering

NOTICE: /dev/sdc: jmicron discovering

NOTICE: /dev/sdc: lsi     discovering

NOTICE: /dev/sdc: nvidia  discovering

NOTICE: /dev/sdc: pdc     discovering

NOTICE: /dev/sdc: sil     discovering

NOTICE: /dev/sdc: via     discovering

INFO: RAID devices discovered:

=20

/dev/sda: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

/dev/sdb: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

WARN: unlocking /var/lock/dmraid/.lock

[Backup_DrClin mapper]#

=20

[Backup_DrClin /]# yum list dmraid*

Loading "installonlyn" plugin

Setting up repositories

Reading repository metadata in from local files

Excluding Packages from CentOS-5 - Base

Finished

Excluding Packages from CentOS-5 - Updates

Finished

Excluding Packages from CentOS-5 - Addons

Finished

Excluding Packages from CentOS-5 - Extras

Finished

Installed Packages

dmraid.i386                              1.0.0.rc13-53.el5      =
installed

dmraid-events.i386                       1.0.0.rc13-53.el5      =
installed

Available Packages

dmraid-devel.i386                        1.0.0.rc13-53.el5      base

dmraid-events-logwatch.i386              1.0.0.rc13-53.el5      base

[Backup_DrClin /]#

=20

Could someone help me? I guess that must be a Bug !

=20

Thank=B4s

=20

=20

Ronei Kliemann

Tec System Sistemas Eletronicos LTDA

Fone/Fax: 55 51 3599 1191 (Ramal 23) / Fone: 55 51 2108 0721 / Fone: 55 =
51 9259 5361

Celular:. 55 51 9127 3588=20

VoIP Tellfree: 782 1191 / DDR - 780 3191

E-mail: ronei@tscom.com.br

Site: www.tscom.com.br=20

Msn: kronei@hotmail.com (apenas para - Chat)

=20

=20


------_=_NextPart_001_01CAA504.E04BB7CB
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" =
xmlns:p=3D"urn:schemas-microsoft-com:office:powerpoint" =
xmlns:a=3D"urn:schemas-microsoft-com:office:access" =
xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" =
xmlns:s=3D"uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" =
xmlns:rs=3D"urn:schemas-microsoft-com:rowset" xmlns:z=3D"#RowsetSchema" =
xmlns:b=3D"urn:schemas-microsoft-com:office:publisher" =
xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadsheet" =
xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" =
xmlns:odc=3D"urn:schemas-microsoft-com:office:odc" =
xmlns:oa=3D"urn:schemas-microsoft-com:office:activation" =
xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" =
xmlns:rtc=3D"http://microsoft.com/officenet/conferencing" =
xmlns:D=3D"DAV:" xmlns:Repl=3D"http://schemas.microsoft.com/repl/" =
xmlns:mt=3D"http://schemas.microsoft.com/sharepoint/soap/meetings/" =
xmlns:x2=3D"http://schemas.microsoft.com/office/excel/2003/xml" =
xmlns:ppda=3D"http://www.passport.com/NameSpace.xsd" =
xmlns:ois=3D"http://schemas.microsoft.com/sharepoint/soap/ois/" =
xmlns:dir=3D"http://schemas.microsoft.com/sharepoint/soap/directory/" =
xmlns:ds=3D"http://www.w3.org/2000/09/xmldsig#" =
xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint/dsp" =
xmlns:udc=3D"http://schemas.microsoft.com/data/udc" =
xmlns:xsd=3D"http://www.w3.org/2001/XMLSchema" =
xmlns:sub=3D"http://schemas.microsoft.com/sharepoint/soap/2002/1/alerts/"=
 xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#" =
xmlns:sp=3D"http://schemas.microsoft.com/sharepoint/" =
xmlns:sps=3D"http://schemas.microsoft.com/sharepoint/soap/" =
xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-instance" =
xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/soap" =
xmlns:udcxf=3D"http://schemas.microsoft.com/data/udc/xmlfile" =
xmlns:udcp2p=3D"http://schemas.microsoft.com/data/udc/parttopart" =
xmlns:wf=3D"http://schemas.microsoft.com/sharepoint/soap/workflow/" =
xmlns:dsss=3D"http://schemas.microsoft.com/office/2006/digsig-setup" =
xmlns:dssi=3D"http://schemas.microsoft.com/office/2006/digsig" =
xmlns:mdssi=3D"http://schemas.openxmlformats.org/package/2006/digital-sig=
nature" =
xmlns:mver=3D"http://schemas.openxmlformats.org/markup-compatibility/2006=
" xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns:mrels=3D"http://schemas.openxmlformats.org/package/2006/relationshi=
ps" xmlns:spwp=3D"http://microsoft.com/sharepoint/webpartpages" =
xmlns:ex12t=3D"http://schemas.microsoft.com/exchange/services/2006/types"=
 =
xmlns:ex12m=3D"http://schemas.microsoft.com/exchange/services/2006/messag=
es" =
xmlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/=
" =
xmlns:spsl=3D"http://microsoft.com/webservices/SharePointPortalServer/Pub=
lishedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" =
xmlns:st=3D"&#1;" xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>

<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EstiloDeEmail17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:70.85pt 3.0cm 70.85pt 3.0cm;}
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

<body lang=3DPT-BR link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><span lang=3DEN-US>Hi<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>I am with one problem that I =
couldn&#8217;t
find solution at the intenet. <o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>My server is HP ML 110 G5 with =
Embedded
Raid. By lspci , I can see that &nbsp;it&#8217;s a &nbsp;&#8220;RAID bus
controller: Intel Corporation 82801 SATA RAID Controller (rev =
02)&#8221;. I am
using centos 5<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>I can see that RAID is not =
working because
there isn&acute;t volume at /dev/mapper/, just =
&#8220;control&#8221;.<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>&#8220;[Backup_DrClin ~]# cd =
/dev/mapper/<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin mapper]# =
ls<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>control<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
mapper]#&#8221;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>The device mapper was load at =
boot:<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin log]# grep =
device-mapper
dmesg<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>device-mapper: uevent: version =
1.0.3<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>device-mapper: ioctl: =
4.11.5-ioctl
(2007-12-12) initialised: <a =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><o:p></o:p></s=
pan></p>

<p class=3DMsoNormal><span lang=3DEN-US>device-mapper: multipath: =
version 1.0.5
loaded<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
log]#<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>I Try to activate dmraid, but no =
work:<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin mapper]# dmraid =
-ay<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>RAID set =
&quot;ddf1_Raid_1_Mirror&quot; was
not activated<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>ERROR: device
&quot;ddf1_Raid_1_Mirror&quot; could not be found<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
mapper]#<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>I can see at logs : =
(/var/log/messages<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Feb&nbsp; 3 08:31:35 =
Backup_DrClin kernel:
device-mapper: table: 253:0: mirror: Device lookup =
failure<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Feb&nbsp; 3 08:31:35 =
Backup_DrClin kernel:
device-mapper: ioctl: error adding target to table<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Feb&nbsp; 3 08:31:35 =
Backup_DrClin kernel:
device-mapper: ioctl: device doesn't appear to be in the dev hash =
table.<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>More info:<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin log]# dmraid =
-s<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>*** Group superset =
.ddf1_disks<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>--&gt; =
Subset<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>name&nbsp;&nbsp; : =
ddf1_Raid_1_Mirror<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>size&nbsp;&nbsp; : =
312237824<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>stride : =
128<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>type&nbsp;&nbsp; : =
mirror<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>status : =
ok<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>subsets: 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>devs&nbsp;&nbsp; : =
2<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>spares : 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
log]#<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin log]# dmraid =
-r<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>/dev/sda: ddf1, =
&quot;.ddf1_disks&quot;,
GROUP, ok, 312237856 sectors, data@ 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>/dev/sdb: ddf1, =
&quot;.ddf1_disks&quot;,
GROUP, ok, 312237856 sectors, data@ 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
log]#<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin mapper]# dmraid =
-rD -d -d -d
-v -v -v<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>WARN: locking =
/var/lock/dmraid/.lock<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda:
asr&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda: =
ddf1&nbsp;&nbsp;&nbsp;
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: creating directory =
dmraid.ddf1<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: writing metadata file
&quot;sda.dat&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: writing offset to file
&quot;sda.offset&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: writing size to file
&quot;sda.size&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda: ddf1 metadata =
discovered<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda: hpt37x&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda: hpt45x&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda:
isw&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda: jmicron =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda:
lsi&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda: nvidia&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda:
pdc&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda:
sil&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sda:
via&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb:
asr&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb: =
ddf1&nbsp;&nbsp;&nbsp;
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: writing metadata file
&quot;sdb.dat&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: writing offset to file
&quot;sdb.offset&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: writing size to file
&quot;sdb.size&quot;<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb: ddf1 metadata =
discovered<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb: hpt37x&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb: hpt45x&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb:
isw&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb: jmicron =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb:
lsi&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb: nvidia&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb:
pdc&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb:
sil&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdb:
via&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc:
asr&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc: =
ddf1&nbsp;&nbsp;&nbsp;
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc: hpt37x&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc: hpt45x&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc:
isw&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc: jmicron =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc:
lsi&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc: nvidia&nbsp; =
discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc:
pdc&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc:
sil&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>NOTICE: /dev/sdc:
via&nbsp;&nbsp;&nbsp;&nbsp; discovering<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>INFO: RAID devices =
discovered:<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>/dev/sda: ddf1, =
&quot;.ddf1_disks&quot;,
GROUP, ok, 312237856 sectors, data@ 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>/dev/sdb: ddf1, =
&quot;.ddf1_disks&quot;,
GROUP, ok, 312237856 sectors, data@ 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>WARN: unlocking =
/var/lock/dmraid/.lock<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
mapper]#<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin /]# yum list =
dmraid*<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Loading &quot;installonlyn&quot; =
plugin<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Setting up =
repositories<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Reading repository metadata in =
from local
files<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Excluding Packages from CentOS-5 =
- Base<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Finished<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Excluding Packages from CentOS-5 =
- Updates<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Finished<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Excluding Packages from CentOS-5 =
- Addons<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Finished<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Excluding Packages from CentOS-5 =
- Extras<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Finished<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Installed =
Packages<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
lang=3DEN-US>dmraid.i386&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
1.0.0.rc13-53.el5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
installed<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
lang=3DEN-US>dmraid-events.i386&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
1.0.0.rc13-53.el5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
installed<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Available =
Packages<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
lang=3DEN-US>dmraid-devel.i386&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;
1.0.0.rc13-53.el5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
base<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
lang=3DEN-US>dmraid-events-logwatch.i386&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
1.0.0.rc13-53.el5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
base<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>[Backup_DrClin =
/]#<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Could someone help me? I guess =
that must be
a Bug !<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal>Thank&acute;s<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>Ronei
Kliemann<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>Tec
System Sistemas Eletronicos LTDA<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>Fone/Fax:
55 51 3599 1191 (Ramal 23) / Fone: 55 51 2108 0721 / Fone: 55 51 9259 =
5361<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>Celular:.
55 51 9127 3588 <o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>VoIP
Tellfree: 782 1191 / DDR - 780 3191<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>E-mail: <a
href=3D"mailto:ronei@tscom.com.br">ronei@tscom.com.br</a><o:p></o:p></spa=
n></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>Site: <a
href=3D"http://www.tscom.com.br">www.tscom.com.br</a> =
<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>Msn: <a
href=3D"mailto:kronei@hotmail.com">kronei@hotmail.com</a> (apenas para - =
Chat)<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'font-size:10.5pt;font-family:Consolas'>&nbsp;<o:p></o:p></span><=
/p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

------_=_NextPart_001_01CAA504.E04BB7CB--


--===============2836302064690810858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2836302064690810858==--
