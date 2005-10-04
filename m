From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: regarding handling IO aborts
Date: Tue, 4 Oct 2005 15:20:22 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA002C73DEE@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1404613003=="
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

--===============1404613003==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C5C8C9.09C173CC"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5C8C9.09C173CC
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Can someone tell how the IO aborts handled in DM? Does the aborted IO
from the SCSI subsystem for a given path is retried on other paths to
the same device?  Does DM have the capability of issuing IO abort to
SCSI subsystem for the requests sent to below?

=20

Thanks!!

-Murthy


------_=_NextPart_001_01C5C8C9.09C173CC
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
10.0pt;font-family:"MS Sans Serif"'>Can someone tell how the IO aborts =
handled
in DM? Does the aborted IO from the SCSI subsystem for a given path is =
retried
on other paths to the same device? &nbsp;Does DM have the capability of =
issuing
IO abort to SCSI subsystem for the requests sent to =
below?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>Thanks!!<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>-Murthy<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C5C8C9.09C173CC--


--===============1404613003==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1404613003==--
