From: "Paul Cote" <paul.cote@incipient.com>
Subject: order of preference / multipath.conf
Date: Wed, 21 Nov 2007 09:51:50 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8C9D@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2059380515=="
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

--===============2059380515==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C82C4E.0C0D3C58"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C82C4E.0C0D3C58
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=20

I found this in an old thread and want to confirm as it will influence
how/what we include in multipath.conf

=20

Is the following order of preference accurate?=20

=20
1) Multipaths section (in /etc/multipath.conf)
2) Device section   (in /etc/multipath.conf)
3) Defaults section (in /etc/multipath.conf)
4) Internal default (hwtable.c)
=20
If so; then inclusions in the default section; such as setting multibus
as the path grouping policy; would adversely affect any active / passive
array definitions in hwtable.c.=20
=20
There really should be more guidance concerning these matters. Is this
documented somewhere?
=20

Thanks,

Paul


------_=_NextPart_001_01C82C4E.0C0D3C58
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 10 (filtered)">

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
pre
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{font-family:Arial;
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
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I found this in an old thread and want to confirm as =
it will
influence how/what we include in multipath.conf</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Is the following order of preference accurate? =
</span></font></p>

<pre><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></pre><p=
re><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>1) Multipaths section (in =
/etc/multipath.conf)</span></font></pre><pre><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>2) Device =
section&nbsp;&nbsp; (in =
/etc/multipath.conf)</span></font></pre><pre><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>3) Defaults section (in =
/etc/multipath.conf)</span></font></pre><pre><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>4) Internal default =
(hwtable.c)</span></font></pre><pre><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></pre><p=
re><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>If so; then inclusions in =
the default section; such as setting multibus as the path grouping =
policy; would adversely affect any active / passive array definitions in =
hwtable.c. </span></font></pre><pre><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></pre><p=
re><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>There really should be more =
guidance concerning these matters. Is this documented =
somewhere?</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks,</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Paul</span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C82C4E.0C0D3C58--


--===============2059380515==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2059380515==--
