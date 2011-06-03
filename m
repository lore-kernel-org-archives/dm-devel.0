From: "Sandra Escandor" <sescandor@evertz.com>
Subject: Trouble with registering a raid volume with dmeventd
Date: Fri, 3 Jun 2011 12:15:11 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFACBAF26@otis.burlington.evertz.tv>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2256075178190522746=="
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

--===============2256075178190522746==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CC2208.F2605816"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC2208.F2605816
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I notice that when I initially have the raid0+1 volumes registered with
dm_dso_reg_tool, and then simulate a disk failure by pulling a member
disk during an i/o operation, then reconnecting the disk, and then
rebooting, I see that the output of dmsetup status shows that all of the
member disks are active for each raid volume.=20

=20

When I check out the output of dm_dso_reg_tool -m to show the list of
monitored devices, it shows that the raid volumes are not registered
with dmeventd. That's fine, so I try registering all of the raid
volumes, but only two out of the three volumes only ever get registered
with dmeventd. Whenever I register the third volume, all three volumes
become listed as not currently registered with dmeventd.

=20

What step am I missing?

=20

Thanks for clarifying,

Sandra


------_=_NextPart_001_01CC2208.F2605816
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
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I notice that when I initially have the raid0+1 =
volumes
registered with dm_dso_reg_tool, and then simulate a disk failure by =
pulling a
member disk during an i/o operation, then reconnecting the disk, and =
then
rebooting, I see that the output of dmsetup status shows that all of the =
member
disks are active for each raid volume. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>When I check out the output of dm_dso_reg_tool =
&#8211;m to
show the list of monitored devices, it shows that the raid volumes are =
not
registered with dmeventd. That&#8217;s fine, so I try registering all of =
the
raid volumes, but only two out of the three volumes only ever get =
registered
with dmeventd. Whenever I register the third volume, all three volumes =
become
listed as not currently registered with =
dmeventd.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>What step am I missing?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks for clarifying,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Sandra<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01CC2208.F2605816--


--===============2256075178190522746==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2256075178190522746==--
