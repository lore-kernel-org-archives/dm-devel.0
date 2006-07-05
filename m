From: "Rajat Sharma, Noida" <sharma.rajat@hcl.in>
Subject: md and dm
Date: Wed, 5 Jul 2006 13:19:12 +0530
Message-ID: <539C0A297AA0C74581CB5AF82D53729101CC7DDD@HSDLNTD1110010.noida.hcltech.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1664061261=="
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

--===============1664061261==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6A007.81BABFF2"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6A007.81BABFF2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Could anybody tell me how md driver and device-mapper are linked??
dm_mpath.c file contains multipath support then so does the multipath.c
provides multipath personality for md driver. Both are placed in same
directory in kernel sources but why?? Does device-mapper uses md driver
anyhow??

=20

Rajat Sharma

HCL Technologies Ltd.,
A-11, Sector-16, Noida-201301
http://www.hcltechnologies.com <http://www.hcltechnologies.com/>=20
Ph. : +91-120-2510701/702 Ext : 3155
FAX : +91-120-2510713
Mobile: 9810057563=20

=20



DISCLAIMER:
---------------------------------------------------------------------------=
--------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and=
 intended for the named recipient(s) only.=20
It shall not attach any liability on the originator or HCL or its=
 affiliates. Any views or opinions presented in=20
this email are solely those of the author and may not necessarily reflect=
 the opinions of HCL or its affiliates.=20
Any form of reproduction, dissemination, copying, disclosure, modification,=
 distribution and / or publication of=20
this message without the prior written consent of the author of this e-mail=
 is strictly prohibited. If you have=20
received this email in error please delete it and notify the sender=
 immediately. Before opening any mail and=20
attachments please check them for viruses and defect.

---------------------------------------------------------------------------=
--------------------------------------------
------_=_NextPart_001_01C6A007.81BABFF2
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=
=3D"urn:schemas-microsoft-com:office:word" xmlns:st1=
=3D"urn:schemas-microsoft-com:office:smarttags" xmlns=
=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=
=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Comic Sans MS";
	panose-1:3 15 7 2 3 3 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:9.0pt;
	font-family:Arial;}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p.MsoAutoSig, li.MsoAutoSig, div.MsoAutoSig
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
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

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=
=3D'font-size:10.0pt'>Could
anybody tell me how md driver and device-mapper are linked?? dm_mpath.c=
 file
contains multipath support then so does the multipath.c provides multipath
personality for md driver. Both are placed in same directory in kernel=
 sources
but why?? Does device-mapper uses md driver=
 anyhow??<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=
=3D'font-size:10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoAutoSig><font size=3D4 color=3D"#339966" face=3D"Times New=
 Roman"><span
style=3D'font-size:14.0pt;color:#339966'>Rajat=
 Sharma</span></font><o:p></o:p></p>

<p class=3DMsoAutoSig><b><font size=3D2 color=3Dblue face=3DArial><span
style=
=3D'font-size:10.0pt;font-family:Arial;color:blue;font-weight:bold'>HCL
Technologies Ltd.,</span></font></b><br>
<font size=3D2 face=3DArial><span style=
=3D'font-size:10.0pt;font-family:Arial'>A-11,
Sector-16, Noida-201301</span></font><br>
<u><font size=3D2 color=3Dblue face=3DArial><span style=
=3D'font-size:10.0pt;font-family:
Arial;color:blue'><a href=3D"http://www.hcltechnologies.com/" target=
=3D"_blank"
title=
=3D"http://www.hcltechnologies.com/">http://www.hcltechnologies.com</a></sp=
an></font></u><br>
<font face=3DArial><span style=3D'font-family:Arial'>Ph. :=
 +91-120-2510701/702 Ext
: 3155<br>
FAX : +91-120-2510713<br>
</span></font><st1:place w:st=3D"on"><st1:City w:st=3D"on"><font
  face=3D"Comic Sans MS"><span style=3D'font-family:"Comic Sans=
 MS"'>Mobile</span></font></st1:City></st1:place><font
face=3D"Comic Sans MS"><span style=3D'font-family:"Comic Sans MS"'>:=
 9810057563</span></font>
<o:p></o:p></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span style=
=3D'font-size:9.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

<table><tr><td bgcolor=3D#ffffff><font color=3D#000000>DISCLAIMER:<br>
---------------------------------------------------------------------------=
--------------------------------------------<br>
<br>
The contents of this e-mail and any attachment(s) are confidential and=
 intended for the named recipient(s) only. <br>
It shall not attach any liability on the originator or HCL or its=
 affiliates. Any views or opinions presented in <br>
this email are solely those of the author and may not necessarily reflect=
 the opinions of HCL or its affiliates. <br>
Any form of reproduction, dissemination, copying, disclosure, modification,=
 distribution and / or publication of <br>
this message without the prior written consent of the author of this e-mail=
 is strictly prohibited. If you have <br>
received this email in error please delete it and notify the sender=
 immediately. Before opening any mail and <br>
attachments please check them for viruses and defect.<br>
<br>
---------------------------------------------------------------------------=
--------------------------------------------<br>
</font></td></tr></table>
------_=_NextPart_001_01C6A007.81BABFF2--


--===============1664061261==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1664061261==--
