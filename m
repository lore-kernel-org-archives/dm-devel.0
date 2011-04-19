From: "Sandra Escandor" <sescandor@evertz.com>
Subject: RAID status, CSMI, and dmRAID
Date: Tue, 19 Apr 2011 09:56:11 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFABC2006@otis.burlington.evertz.tv>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6507291935461695293=="
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

--===============6507291935461695293==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBFE99.5A6C2B7F"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBFE99.5A6C2B7F
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

=20

I've recently been researching the issue of obtaining RAID status on
Linux (using a library or API, not through scripts). I've read that CSMI
codes can be issued (using ioctl() calls) to get RAID status, and from
my understanding (please correct me if I'm wrong), dmraid doesn't use
CSMI at all, and the status is obtained using the metadata on the member
drives. Does this mean that using CSMI and ioctl is not possible on
Linux, or does this mean that using CSMI and ioctl is a bad idea on
Linux?

=20

Thanks for the clarification,

Sandra  =20


------_=_NextPart_001_01CBFE99.5A6C2B7F
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
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:1872723260;
	mso-list-type:hybrid;
	mso-list-template-ids:477267538 67698703 67698713 67698715 67698703 =
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

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Hello,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I&#8217;ve recently been researching the issue of =
obtaining
RAID status on Linux (using a library or API, not through scripts). =
I&#8217;ve
read that CSMI codes can be issued (using ioctl() calls) to get RAID =
status,
and from my understanding (please correct me if I&#8217;m wrong), dmraid =
doesn&#8217;t
use CSMI at all, and the status is obtained using the metadata on the =
member
drives. Does this mean that using CSMI and ioctl is not possible on =
Linux, or
does this mean that using CSMI and ioctl is a bad idea on =
Linux?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks for the =
clarification,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Sandra &nbsp;&nbsp;<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01CBFE99.5A6C2B7F--


--===============6507291935461695293==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6507291935461695293==--
