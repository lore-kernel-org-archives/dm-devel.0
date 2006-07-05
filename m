From: "Srinivas, Vidya" <vidya.srinivas@intel.com>
Subject: Booting Linux from a RAID volume
Date: Wed, 5 Jul 2006 17:03:16 +0530
Message-ID: <A6A77F954AFACF42928F5E931ABDB18F6DC3A2@bgsmsx411.gar.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0241548821=="
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

--===============0241548821==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6A026.CF273E3B"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6A026.CF273E3B
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi

=20

I am using dmraid to activate the RAID5 volume (Intel software raid).
Can someone let me know the best way to install Linux on the volume?

=20

I observed that, each time the machine reboots, the dmraid activated
RAID volume name changes. So how can I achieve bootable Linux volume
using grub or something else?

=20

Thanks

Vidya

=20


------_=_NextPart_001_01C6A026.CF273E3B
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<title>RE: [dm-devel] Issue in Root partition from SAN as
device-mapper-multipath device</title>
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
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Times New Roman";
	color:blue;
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

<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'>Hi<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'><o:p>&nbsp;</o:p></span></font></p>=


<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'>I am using dmraid to activate the =
RAID5
volume (Intel software raid). Can someone let me know the best way to =
install Linux
on the volume?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'><o:p>&nbsp;</o:p></span></font></p>=


<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'>I observed that, each time the =
machine
reboots, the dmraid activated RAID volume name changes. So how can I =
achieve
bootable Linux volume using grub or something =
else?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'><o:p>&nbsp;</o:p></span></font></p>=


<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'>Thanks<o:p></o:p></span></font></p>=


<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'>Vidya<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblue face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:blue'><o:p>&nbsp;</o:p></span></font></p>=


</div>

</body>

</html>

------_=_NextPart_001_01C6A026.CF273E3B--


--===============0241548821==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0241548821==--
