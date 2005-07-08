From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: path notification not working using on Suse SP2
Date: Fri, 8 Jul 2005 17:45:20 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA0023F847F@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0316030978=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0316030978==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C583B6.B6488634"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C583B6.B6488634
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

In Suse SP2,

=20

We had 0.4.4 version of the multipath tools installed from Lars website
along with the kernel 2.6.5-7.183 kernel. The path status is never
getting updated when the path is made unavailable or available. Then we
used OS sg tools to check if we are able to get "test unit ready (tur)"
responses proper as the path checker we used is "tur". The response of
"tur is proper when it's run on "sg" devices", but it always succeeds
when run on "sd" devices.  As the "tur" path checker uses "sd" devices
to check the path, we never got the path change status.=20

=20

We have tried the same on Suse SP2- rc2, rc3 and rc4. The behaviour is
the same, when the "readsector0" path checker is used for path
verification.

Even with 0.4.5 multipath tools we are seeing the problem.  Is this a
known problem?  Any pointer to get around this is appreciated.

=20

Thanks and regards

-Murthy

=20


------_=_NextPart_001_01C583B6.B6488634
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

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>In
Suse SP2,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Microsoft Sans Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'text-indent:.5in;text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>We
had 0.4.4 version of the multipath tools installed from Lars website =
along with
the kernel 2.6.5-7.183 kernel. The path status is never getting updated =
when
the path is made unavailable or available. Then we used OS sg tools to =
check if
we are able to get &quot;test unit ready (tur)&quot; responses proper as =
the
path checker we used is &quot;tur&quot;. The response of &quot;tur is =
proper
when it's run on &quot;sg&quot; devices&quot;, but it always succeeds =
when run
on &quot;sd&quot; devices.&nbsp; As the &quot;tur&quot; path checker =
uses
&quot;sd&quot; devices to check the path, we never got the path change =
status. <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Microsoft Sans Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>We have =
tried the
same on Suse SP2- rc2, rc3 and rc4. The behaviour is the same, when the =
&#8220;readsector0&#8221;
path checker is used for path verification.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Microsoft Sans Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Even with =
0.4.5
multipath tools we are seeing the problem. &nbsp;</span></font><font =
size=3D2
face=3D"MS Sans Serif"><span style=3D'font-size:10.0pt;font-family:"MS =
Sans Serif"'>Is
this a known problem?&nbsp; Any pointer to get around this is =
appreciated.<o:p></o:p></span></font></p>

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

------_=_NextPart_001_01C583B6.B6488634--


--===============0316030978==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0316030978==--
