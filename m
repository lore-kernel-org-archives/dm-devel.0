From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: query on device alias/black listing
Date: Fri, 28 Oct 2005 14:35:53 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA002E39FA5@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0475138238=="
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

--===============0475138238==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C5DB9E.CCEC3778"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5DB9E.CCEC3778
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

1. In RHEL4 U2, when a device alias is created by modifying
/etc/multipath.conf file, the new DM device is created along with the
existing DM device for which the alias is created. Both devices exist in
/dev/mapper/ directory. When "multipath -ll" is executed, both original
device and the device with alias name are displayed. We can have
different device policies like path grouping etc for both of these
devices.  User need to either reboot or run "multipath -f <wwid> to
remove the existing device for which alias was created. I think we
should have only one device when alias is created. Any suggestions? This
is not a problem as user can go and delete/flush the original device.

=20

2. Blacklisting of the device is possible using "wwid <wwn>" in
blacklist block in /etc/multipath.conf. Is there any way to blacklist
the device created with alias? Giving an alias name in devnode or wwid
doesn't seem to work.

=20

3. As it is not encouraged dmsetup utility to be used for multipathing
devices, features like suspend and resume will be useful in bringing
down the device for maintenance purposes. Any thoughts?

=20

Thanks!!
-Murthy

=20


------_=_NextPart_001_01C5DB9E.CCEC3778
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
10.0pt;font-family:"MS Sans Serif"'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>1. In RHEL4 U2, when a device alias =
is
created by modifying /etc/multipath.conf file, the new DM device is =
created
along with the existing DM device for which the alias is created. Both =
devices exist
in /dev/mapper/ directory. When &#8220;multipath &#8211;ll&#8221; is =
executed,
both original device and the device with alias name are displayed. We =
can have
different device policies like path grouping etc for both of these =
devices. &nbsp;User
need to either reboot or run &#8220;multipath &#8211;f &lt;wwid&gt; to =
remove
the existing device for which alias was created. I think we should have =
only
one device when alias is created. Any suggestions? This is not a problem =
as
user can go and delete/flush the original =
device.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>2. Blacklisting of the device is =
possible using
&#8220;wwid &lt;wwn&gt;&#8221; in blacklist block in =
/etc/multipath.conf. Is
there any way to blacklist the device created with alias? Giving an =
alias name
in devnode or wwid doesn&#8217;t seem to =
work.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>3. As it is not encouraged dmsetup =
utility to
be used for multipathing devices, features like suspend and resume will =
be
useful in bringing down the device for maintenance purposes. Any =
thoughts?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>Thanks!!<br>
-Murthy<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C5DB9E.CCEC3778--


--===============0475138238==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0475138238==--
