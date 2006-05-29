From: "Gil" <gils@fe.up.pt>
Subject: IBM DS4300
Date: Mon, 29 May 2006 18:42:27 +0100
Message-ID: <200605291742.k4THgWWZ016415@relay2.fe.up.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0872189041=="
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

--===============0872189041==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0016_01C6834F.A5794100"

This is a multi-part message in MIME format.

------=_NextPart_000_0016_01C6834F.A5794100
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi list,

 

I have the following SAN hardware, and would be very grateful for any help:

 

SAN:

IBM DS4300 Storage Server with Turbo Option

 

HBA:

Fast Host Bus Adapter FC-2

 

Switch:

2 IBM TotalStorage SAN Switch H08 (8-portas)

 

Does multipath-tools support this hardware? How should I configure it?

 

I have tried to use multipath with it, using default configuration, but I am
having performance problems. What I would like to figure out is if
multipath-tools has anything to do with it.

 

Best regards,

    Gil


------=_NextPart_000_0016_01C6834F.A5794100
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
span.EstiloCorreioElectrnico17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 3.0cm 70.85pt 3.0cm;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DPT link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Hi list,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>I have the following SAN hardware, and would =
be very
grateful for any help:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>SAN:<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>IBM DS4300 =
Storage Server
with Turbo Option</span></font><font size=3D1 color=3D"#304965" =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:8.0pt;font-family:Arial;color:#304965'><o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>HBA:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Fast Host Bus Adapter =
FC-2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Switch:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>2 IBM =
TotalStorage SAN
Switch H08 (8-portas)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'><o:p>&nbsp;</o:p>=
</span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>Does =
multipath-tools
support this hardware? How should I configure =
it?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'><o:p>&nbsp;</o:p>=
</span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>I have tried to =
use
multipath with it, using default configuration, but I am having =
performance
problems. What I would like to figure out is if multipath-tools has =
anything to
do with it.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'><o:p>&nbsp;</o:p>=
</span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>Best =
regards,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:9.0pt;font-family:Arial;color:black'>&nbsp;&nbsp;&nbsp=
; Gil<o:p></o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_0016_01C6834F.A5794100--


--===============0872189041==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0872189041==--
