From: "Stepan, Troy" <troy.stepan@unisys.com>
Subject: MPIO origins
Date: Mon, 1 May 2006 12:26:30 -0400
Message-ID: <94C8C9E8B25F564F95185BDA64AB05F603761DA2@USTR-EXCH5.na.uis.unisys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0272174281=="
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

--===============0272174281==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C66D3C.011F843F"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C66D3C.011F843F
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From my recent findings, it looks like the MPIO project in the dm layer
has come a long way towards making Linux an enterprise-class OS.
Lately, I've been curious in regards to the roots of the MPIO project as
an alternative to the costly and sometimes buggy EMC Powerpath.  Can
anyone shed some light on the following questions?

=20

When this project started, what were the goals?  Since there are so many
places where an IO can fail, were specific IO errors targeted or was
development limited to IO errors caused only by physical path loss?  Was
there a specific reliability target (i.e. - twice as reliable as a
single path to IO target)?  Also--this is a more general question--where
are all the places an IO can fail in Linux?

=20

I look forward to learning more about this project.  Thanks in advance
for any replies!

=20

--Troy


------_=_NextPart_001_01C66D3C.011F843F
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
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
font-family:Arial'>From my recent findings, it looks like the MPIO =
project in
the dm layer has come a long way towards making Linux an =
enterprise-class OS.&nbsp; Lately,
I&#8217;ve been curious in regards to the roots of the MPIO project as =
an
alternative to the costly and sometimes buggy EMC Powerpath.&nbsp; Can =
anyone shed
some light on the following questions?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>When this project started, what were the goals?&nbsp; =
Since there
are so many places where an IO can fail, were specific IO errors =
targeted or was
development limited to IO errors caused only by physical path =
loss?&nbsp; Was there
a specific reliability target (i.e. &#8211; twice as reliable as a =
single path
to IO target)?&nbsp; Also--this is a more general question--where are =
all the places
an IO can fail in Linux?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I look forward to learning more about this =
project.&nbsp; Thanks in
advance for any replies!<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>--<st1:City w:st=3D"on"><st1:place =
w:st=3D"on">Troy</st1:place></st1:City><o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C66D3C.011F843F--


--===============0272174281==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0272174281==--
