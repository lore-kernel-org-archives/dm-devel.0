From: "Paul Cote" <paul.cote@incipient.com>
Subject: RE: order of preference / multipath.conf
Date: Wed, 21 Nov 2007 12:01:10 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8CA3@exch-2003.incipient.waltham>
References: <5201e28f0711210848m7ff4f2daxb6644b2ae006a3e7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1938920212=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <5201e28f0711210848m7ff4f2daxb6644b2ae006a3e7@mail.gmail.com>
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

--===============1938920212==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C82C60.1D798D15"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C82C60.1D798D15
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Stefan / Tore

=20

Thanks ... and good to know that hwtable.c entries take precedence over
defaults.

=20

=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Stefan Bader
Sent: Wednesday, November 21, 2007 11:48 AM
To: device-mapper development
Subject: Re: [dm-devel] order of preference / multipath.conf

=20

=20

2007/11/21, Paul Cote <paul.cote@incipient.com>:

=20

I found this in an old thread and want to confirm as it will influence
how/what we include in multipath.conf

=20

Is the following order of preference accurate?=20

=20
1) Multipaths section (in /etc/multipath.conf)
2) Device section   (in /etc/multipath.conf)
=20
3) Defaults section (in /etc/multipath.conf)
4) Internal default (hwtable.c)
=20
=20

The last two (3 and 4) are the other way round. If there is an entry in
hwtable.c, this will take effect.

Stefan=20


------_=_NextPart_001_01C82C60.1D798D15
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DGenerator content=3D"Microsoft Word 10 (filtered)">

<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
	{color:blue;
	text-decoration:underline;}
p
	{margin-right:0in;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
pre
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle20
	{font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dblue>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Stefan / Tore</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks &#8230; and good to know =
that hwtable.c
entries take precedence over defaults.</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
face=3DTahoma><span
style=3D'font-size:10.0pt;font-family:Tahoma'>-----Original =
Message-----<br>
<b><span style=3D'font-weight:bold'>From:</span></b> =
dm-devel-bounces@redhat.com
[mailto:dm-devel-bounces@redhat.com] <b><span =
style=3D'font-weight:bold'>On
Behalf Of </span></b>Stefan Bader<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> </span></font><font =
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'>Wednesday,
 November 21, 2007</span></font><font size=3D2 face=3DTahoma><span
style=3D'font-size:10.0pt;font-family:Tahoma'> </span></font><font
 size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'>11:48 =
AM</span></font><font
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'><br>
<b><span style=3D'font-weight:bold'>To:</span></b> device-mapper =
development<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] =
order of
preference / multipath.conf</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D3 =
face=3D"Times New Roman"><span
style=3D'font-size:12.0pt'>&nbsp;</span></font></p>

<p class=3DMsoNormal =
style=3D'margin-right:0in;margin-bottom:12.0pt;margin-left:
.5in'><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>&nbsp;</span></font></p>

<div>

<p class=3DMsoNormal style=3D'margin-left:.5in'><span =
class=3Dgmailquote><font
size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>2007/11/21, Paul
Cote &lt;<a =
href=3D"mailto:paul.cote@incipient.com">paul.cote@incipient.com</a>&gt;:<=
/span></font></span></p>

<div link=3Dblue vlink=3Dpurple>

<div>

<p style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial'>I found this in an old thread and want to =
confirm as
it will influence how/what we include in =
multipath.conf</span></font></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial'>Is the following order of preference accurate? =
</span></font></p>

<pre style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial'>&nbsp;</span></font></pre><pre =
style=3D'margin-left:
.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>1) Multipaths section (in =
/etc/multipath.conf)</span></font></pre><pre
style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>2) Device section&nbsp;&nbsp; (in =
/etc/multipath.conf)</span></font></pre><pre
style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></pre><pre =
style=3D'margin-left:.5in'><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>3) Defaults section (in =
/etc/multipath.conf)</span></font></pre><pre
style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>4) Internal default =
(hwtable.c)</span></font></pre><pre
style=3D'margin-left:.5in'><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></pre><pre =
style=3D'margin-left:.5in'><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></pre></=
div>

</div>

</div>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D3 =
face=3D"Times New Roman"><span
style=3D'font-size:12.0pt'>The last two (3 and 4) are the other way =
round. If
there is an entry in hwtable.c, this will take effect.<br>
<br>
Stefan </span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C82C60.1D798D15--


--===============1938920212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1938920212==--
