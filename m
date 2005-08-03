From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: regarding DM device for a single path.
Date: Wed, 3 Aug 2005 19:50:59 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA00268AD6A@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1388166319=="
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1388166319==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C59836.925CC430"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C59836.925CC430
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Kindly clarify on the following,

=20

1.	I tested your latest user space tools with 2.6.9-11.41 kernel.
Used the default created devices for multipathing. The path status is
getting updated appropriately for HSV200 arrays.  However the failback
functionality is not working for me. I have configure value for
"failback" variable in /etc/multipath.conf as zero for immediate
failback, but when the failed path in the original path group comes back
online, the IO is not failed back the old pathgroup.

=20

=20

2.	In yesterday's discussion, you mentioned that DM device nodes
will not be created for the physical devices which are having single
path.  Assuming one particular device had 2 paths and DM device was
created and used by the applications. While the system is rebooted for
some reasons, and if one of the paths for this device is lost, then the
subsequent reboot will not create the DM device as it sees only one path
for this device. And the DM device might be created only if the other
path comes back online and the HBA driver is rescanned for new devices.
This may not be desired multipathing behaviour, as the DM device does
not exist if we one path for the device.

=20

Thanks and regards

-Murthy

=20


------_=_NextPart_001_01C59836.925CC430
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
 /* List Definitions */
 @list l0
	{mso-list-id:235896059;
	mso-list-type:hybrid;
	mso-list-template-ids:509359278 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Hi =
Alasdair,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Kindly clarify on the =
following,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<ol style=3D'margin-top:0in' start=3D1 type=3D1>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2
     face=3D"MS Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"MS Sans Serif"'>I
     tested your latest user space tools with 2.6.9-11.41 kernel. Used =
the
     default created devices for multipathing. The path status is =
getting
     updated appropriately for HSV200 arrays. &nbsp;However the failback
     functionality is not working for me. I have configure value for =
&#8220;failback&#8221;
     variable in /etc/multipath.conf as zero for immediate failback, but =
when
     the failed path in the original path group comes back online, the =
IO is
     not failed back the old pathgroup.<o:p></o:p></span></font></li>
</ol>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<ol style=3D'margin-top:0in' start=3D2 type=3D1>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2
     face=3D"MS Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"MS Sans Serif"'>In
     yesterday&#8217;s discussion, you mentioned that DM device nodes =
will not
     be created for the physical devices which are having single path. =
&nbsp;Assuming
     one particular device had 2 paths and DM device was created and =
used by
     the applications. While the system is rebooted for some reasons, =
and if
     one of the paths for this device is lost, then the subsequent =
reboot will
     not create the DM device as it sees only one path for this device. =
And the
     DM device might be created only if the other path comes back online =
and
     the HBA driver is rescanned for new devices. &nbsp;This may not be =
desired
     multipathing behaviour, as the DM device does not exist if we one =
path for
     the device.<o:p></o:p></span></font></li>
</ol>

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

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C59836.925CC430--


--===============1388166319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1388166319==--
