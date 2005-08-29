From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: Online addition/deletion of devices/partitions
Date: Mon, 29 Aug 2005 15:21:18 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA002915AD1@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0105254879=="
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
Cc: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0105254879==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C5AC7F.341A40E6"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5AC7F.341A40E6
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

With RHEL4  kernel-smp-2.6.9-17.EL.i686.rpm
<http://people.redhat.com/jbaron/rhel4/RPMS.kernel/kernel-smp-2.6.9-17.E
L.i686.rpm>   and  device-mapper-multipath-0.4.5-5.2.RHEL4.i386.rpm
<http://people.redhat.com/agk/miscrpms/device-mapper-multipath-0.4.5-5.2
.RHEL4.i386.rpm>  there is no SCSI subsystem specific agents in
/etc/hotplug/<name>.agent for handling the addition/deletion of SCSI
devices.  There is file /etc/dev.d/block/multipath.dev which has to be
used for online addition/deletion of devices. Can some one explain me on
how the new SCSI device gets added/deleted using hotplug  and who calls
"/etc/dev.d/block/multipath.dev" for refreshing the multipathing maps?

=20

Also if the device is partitioned, the new device node (/dev/dm-*) for
partitioned segment is not created until "kpartx -a <whole device-name>
is issued from the command line.  Will the /sbin/hotplug  be called when
the device is partitioned (using fdisk)? And how to configure hotplug to
call "kpartx " whenever a partition is added/deleted?

=20

Thanks and regards

-Murthy


------_=_NextPart_001_01C5AC7F.341A40E6
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"MS Sans Serif";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
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
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"MS Sans Serif";
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>With RHEL4 </span></font>&nbsp;<a
href=3D"http://people.redhat.com/jbaron/rhel4/RPMS.kernel/kernel-smp-2.6.=
9-17.EL.i686.rpm">kernel-smp-2.6.9-17.EL.i686.rpm</a>
&nbsp;and &nbsp;<a
href=3D"http://people.redhat.com/agk/miscrpms/device-mapper-multipath-0.4=
.5-5.2.RHEL4.i386.rpm">device-mapper-multipath-0.4.5-5.2.RHEL4.i386.rpm</=
a>
t<font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:
"MS Sans Serif"'>here is no SCSI subsystem specific agents in
/etc/hotplug/&lt;name&gt;.agent for handling the addition/deletion of =
SCSI
devices. &nbsp;There is file /etc/dev.d/block/multipath.dev which has to =
be
used for online addition/deletion of devices. Can some one explain me on =
how the
new SCSI device gets added/deleted using <i><span =
style=3D'font-style:italic'>hotplug
</span></i>&nbsp;and who calls =
&#8220;/etc/dev.d/block/multipath.dev&#8221; for
refreshing the multipathing maps?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Also if the device is partitioned, =
the new device
node (/dev/dm-*) for partitioned segment is not created until =
&#8220;kpartx &#8211;a
&lt;<i><span style=3D'font-style:italic'>whole =
device-name</span></i>&gt; is
issued from the command line. &nbsp;Will the <i><span =
style=3D'font-style:italic'>/sbin/hotplug</span></i>
&nbsp;be called when the device is partitioned (using fdisk)? And how to =
configure
hotplug to call &#8220;<i><span style=3D'font-style:italic'>kpartx<u> =
</u></span></i>&#8220;
whenever a partition is added/deleted?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Thanks and =
regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>-Murthy<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C5AC7F.341A40E6--


--===============0105254879==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0105254879==--
