From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: problem with creating DM nodes for partitions.
Date: Wed, 1 Mar 2006 17:11:39 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA003922D4C@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0903153726=="
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
To: Alasdair G Kergon <agk@redhat.com>, Christophe Varoqui <christophe.varoqui@free.fr>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0903153726==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C63D25.1AABC077"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C63D25.1AABC077
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I have created the following number LUNs and presented to the hosts.

=20

Qlogic - FCA2214, A6826A, A7538A, driver 8.01.03

EVA GL3 - 4 luns

EVA XL - 11 luns

EVA GL4 - 10 luns

XP12k - 24 luns

XP128 - 14 luns

=20

=20

On my SLES9 SP3 hosts, the OS see all the above luns.  multipath.conf
blacklisted the 4 GL3 luns.  If starting of with blank /dev/mapper
directory and boot up the server, 59 dm mapping will be created in the
/dev/mapper and this is all good.  Let say I created 2 partitions on
each above luns (except the GL3 luns) and reboot the host, the host will
hang during boot in middle of mapping or shortly after mapping.
Disconnect the host from SAN and let it reboot again.  Noticed dm
mapping is also created for partitions.  Delete partitions on some luns,
clean out /dev/mapper directory and repeat the boot up process.
Somewhere around 95 or less mapping, the host will boot up fine.

=20

Let me know if there are any limitations on number of DM devnodes
created for LUNS and partitions?  If not any other thoughts will be
greatly helpful.

=20

PS: I need to still validate the same on RHEL4 host.

Thanks and regards
-Murthy


------_=_NextPart_001_01C63D25.1AABC077
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
 /* Font Definitions */
 @font-face
	{font-family:"MS Sans Serif";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Microsoft Sans Serif";
	panose-1:2 11 6 4 2 2 2 2 2 4;}
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
10.0pt;font-family:"MS Sans Serif"'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>I have created the following number =
LUNs
and presented to the hosts.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Qlogic - FCA2214, A6826A, A7538A, driver =
8.01.03</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>EVA GL3 - 4 luns</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>EVA XL - 11 luns</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>EVA GL4 - 10 luns</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>XP12k - 24 luns</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>XP128 - 14 luns</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>On my SLES9 SP3 hosts, the OS see all the above =
luns.&nbsp;
multipath.conf blacklisted the 4 GL3 luns.&nbsp; If starting of =
with&nbsp;blank
/dev/mapper directory and boot up the server, 59 dm mapping will be =
created in
the /dev/mapper and this is all good.&nbsp; Let say I created 2 =
partitions on
each above luns (except the GL3 luns) and reboot the host, the host will =
hang
during boot in middle of mapping or shortly after mapping.&nbsp; =
Disconnect the
host from SAN and let it reboot again.&nbsp; Noticed dm mapping is also =
created
for partitions.&nbsp; Delete partitions on some luns, clean out =
/dev/mapper
directory and repeat the boot up process.&nbsp; Somewhere around 95 or =
less
mapping, the host will boot up fine.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Let me know if there are any limitations on number of =
DM
devnodes created for LUNS and partitions?&nbsp; If not any other =
thoughts will
be greatly helpful.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>PS: I need to still validate the =
same on
RHEL4 host.<o:p></o:p></span></font></p>

<p><font size=3D2 face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;
font-family:"Microsoft Sans Serif"'>Thanks and regards<br>
-Murthy<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C63D25.1AABC077--


--===============0903153726==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0903153726==--
