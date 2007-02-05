From: "Srinivas Ramani" <sramani@pillardata.com>
Subject: Changes hwtable.c to Support New Pillar Hardware
Date: Mon, 5 Feb 2007 13:52:35 -0800
Message-ID: <35D744B011AD9A4A86B5962E85181C781091B776@caex02.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C7496F.F28ED879"
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr, bmarzins@redhat.com, lmb@suse.de, dmo@osdl.org, mbroz@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7496F.F28ED879
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_002_01C7496F.F28ED879"


------_=_NextPart_002_01C7496F.F28ED879
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Folks;

                 I am Srinivasan Ramani  from Pillar Data Systems .

=20

                 I am submitting code changes to support  the=20

                 new Pillar  Axiom 300 and Axiom 550 arrays .

=20

                  I request the following change to hwtable.c file .

=20

                  This change has been tested at Pillar Data Systems  on
RHEL 4 and 5 beta.

=20

                   If you have any comments or  suggestions please let
me know.

            =20

=20

/*

       * Pillar Data controller family

       *

       * Maintainer : Srinivasan Ramani

       * Mail : sramani@pillardata.com

       */

      {

            .vendor        =3D "Pillar",

            .product       =3D "*",

            .getuid        =3D DEFAULT_GETUID,

            .getprio       =3D "mpath_prio_alua %n",

            .features      =3D DEFAULT_FEATURES,

            .hwhandler     =3D DEFAULT_HWHANDLER,

            .selector      =3D DEFAULT_SELECTOR,

            .pgpolicy      =3D GROUP_BY_PRIO,

            .pgfailback    =3D FAILBACK_UNDEF,

            .rr_weight     =3D RR_WEIGHT_NONE,

            .no_path_retry =3D NO_PATH_RETRY_UNDEF,

            .minio         =3D DEFAULT_MINIO,

            .checker_name  =3D TUR,

      },

=20

=20

=20

        =20

Also enclosed is the hwtable.c file.

=20

=20

=20

With Best Regards

=20

Srinivasan Ramani

Pillar Data Systems
2840 Junction Ave
San Jose, CA 95134

Ph: 408-518-4456

=20

=20

=20

                                          =20


------_=_NextPart_002_01C7496F.F28ED879
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PostalCode"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"State"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"Street"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"address"/>
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
span.body1
	{font-family:Arial;}
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
font-family:Arial'>Hi Folks;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I
am Srinivasan Ramani &nbsp;from Pillar Data Systems =
.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
I am submitting code changes to support &nbsp;the =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
new Pillar &nbsp;Axiom 300 and Axiom 550 arrays =
.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;I request the following change to hwtable.c file =
.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
This change has been tested at Pillar Data Systems &nbsp;on RHEL 4 and 5 =
beta.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;If you have any comments or &nbsp;suggestions please let me =
know.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>/*<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*
Pillar Data controller family<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;*<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*
Maintainer : Srinivasan Ramani<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*
Mail : sramani@pillardata.com<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;*/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D &quot;Pillar&quot;,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D &quot;*&quot;,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.getuid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D DEFAULT_GETUID,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.getprio&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D &quot;mpath_prio_alua %n&quot;,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D DEFAULT_FEATURES,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.hwhandler&nbsp;&nbsp;&nbsp;&nbsp;
=3D DEFAULT_HWHANDLER,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D DEFAULT_SELECTOR,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.pgpolicy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D GROUP_BY_PRIO,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.pgfailback&nbsp;&nbsp;&nbsp;
=3D FAILBACK_UNDEF,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.rr_weight&nbsp;&nbsp;&nbsp;&nbsp;
=3D RR_WEIGHT_NONE,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.no_path_retry
=3D NO_PATH_RETRY_UNDEF,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.minio&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
=3D DEFAULT_MINIO,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.checker_name&nbsp;
=3D TUR,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; },<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Also enclosed is the hwtable.c =
file.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>With Best Regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D1 color=3Dblue face=3DArial><span
style=3D'font-size:9.0pt;font-family:Arial;color:blue;font-weight:bold'>S=
rinivasan
Ramani<o:p></o:p></span></font></b></p>

<p class=3DMsoNormal><span class=3Dbody1><font size=3D1 =
face=3DArial><span
style=3D'font-size:6.5pt'>Pillar Data Systems</span></font></span><font =
size=3D1
face=3DArial><span style=3D'font-size:6.5pt;font-family:Arial'><br>
<st1:Street w:st=3D"on"><st1:address w:st=3D"on"><span =
class=3Dbody1><font
  face=3DArial>2840 Junction =
Ave</font></span></st1:address></st1:Street><br>
<st1:place w:st=3D"on"><st1:City w:st=3D"on"><span class=3Dbody1><font =
face=3DArial>San
  Jose</font></span></st1:City><span class=3Dbody1><font face=3DArial>, =
<st1:State
 w:st=3D"on">CA</st1:State> <st1:PostalCode =
w:st=3D"on">95134</st1:PostalCode></font></span></st1:place></span></font=
><b><font
size=3D2 color=3Dblue face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial;
color:blue;font-weight:bold'><o:p></o:p></span></font></b></p>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DArial><span =
style=3D'font-size:
9.0pt;font-family:Arial;color:black'>Ph: =
408-518-4456<o:p></o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D2 color=3Dblue face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:blue;font-weight:bold'>=
<o:p>&nbsp;</o:p></span></font></b></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_002_01C7496F.F28ED879--

------_=_NextPart_001_01C7496F.F28ED879
Content-Type: application/octet-stream;
	name="hwtable.c"
Content-Transfer-Encoding: base64
Content-Description: hwtable.c
Content-Disposition: attachment;
	filename="hwtable.c"

I2luY2x1ZGUgPHN0ZGlvLmg+IA0KI2luY2x1ZGUgPGNoZWNrZXJzLmg+IA0KDQojaW5jbHVkZSAi
dmVjdG9yLmgiDQojaW5jbHVkZSAiZGVmYXVsdHMuaCINCiNpbmNsdWRlICJzdHJ1Y3RzLmgiDQoj
aW5jbHVkZSAiY29uZmlnLmgiDQojaW5jbHVkZSAicGdwb2xpY2llcy5oIg0KDQovKg0KICogVHVu
aW5nIHN1Z2dlc3Rpb25zIG9uIHRoZXNlIHBhcmFtZXRlcnMgc2hvdWxkIGdvIHRvDQogKiBkbS1k
ZXZlbEByZWRoYXQuY29tDQogKiANCiAqIFlvdSBhcmUgd2VsY29tZSB0byBjbGFpbSBtYWludGFp
bmVyc2hpcCBvdmVyIGEgY29udHJvbGxlcg0KICogZmFtaWx5LiBQbGVhc2UgbWFpbCB0aGUgY3Vy
cmVudGx5IGVubGlzdGVkIG1haW50YWluZXIgYW5kDQogKiB0aGUgdXBzdHJlYW0gcGFja2FnZSBt
YWludGFpbmVyLg0KICovDQpzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gew0K
CS8qDQoJICogQXBwbGUgY29udHJvbGxlciBmYW1pbHkNCgkgKg0KCSAqIE1haW50YWluZXIgOiBT
aHlhbSBTdW5kYXINCgkgKiBNYWlsIDogZy5zaHlhbXN1bmRhckB5YWhvby5jby5pbg0KCSAqLw0K
CXsNCgkJLnZlbmRvciAgICAgICAgPSAiQVBQTEUqIiwNCgkJLnByb2R1Y3QgICAgICAgPSAiWHNl
cnZlIFJBSUQgIiwNCgkJLmdldHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHBy
aW8gICAgICAgPSBOVUxMLA0KCQkuZmVhdHVyZXMgICAgICA9IERFRkFVTFRfRkVBVFVSRVMsDQoJ
CS5od2hhbmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIsDQoJCS5zZWxlY3RvciAgICAgID0g
REVGQVVMVF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAgPSBNVUxUSUJVUywNCgkJLnBnZmFp
bGJhY2sgICAgPSBGQUlMQkFDS19VTkRFRiwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlHSFRf
Tk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQkubWluaW8g
ICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0gREVGQVVMVF9DSEVD
S0VSLA0KCX0sDQoJLyoNCgkgKiBTdG9yYWdlV29ya3MgY29udHJvbGxlciBmYW1pbHkNCgkgKg0K
CSAqIE1haW50YWluZXIgOiBDaHJpc3RvcGhlIFZhcm9xdWkNCgkgKiBNYWlsIDogY2hyaXN0b3Bo
ZS52YXJvcXVpQGZyZWUuZnINCgkgKi8NCgl7DQoJCS52ZW5kb3IgICAgICAgID0gIjNQQVJkYXRh
IiwNCgkJLnByb2R1Y3QgICAgICAgPSAiVlYiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRf
R0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5mZWF0dXJlcyAgICAgID0gREVG
QVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hXSEFORExFUiwNCgkJ
LnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xpY3kgICAgICA9IE1V
TFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KCQkucnJfd2VpZ2h0
ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllf
VU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJLmNoZWNrZXJfbmFt
ZSAgPSBERUZBVUxUX0NIRUNLRVIsDQoJfSwNCgl7DQoJCS52ZW5kb3IgICAgICAgID0gIkRFQyIs
DQoJCS5wcm9kdWN0ICAgICAgID0gIkhTRzgwIiwNCgkJLmdldHVpZCAgICAgICAgPSBERUZBVUxU
X0dFVFVJRCwNCgkJLmdldHByaW8gICAgICAgPSBOVUxMLA0KCQkuZmVhdHVyZXMgICAgICA9IERF
RkFVTFRfRkVBVFVSRVMsDQoJCS5od2hhbmRsZXIgICAgID0gIjEgaHBfc3ciLA0KCQkuc2VsZWN0
b3IgICAgICA9IERFRkFVTFRfU0VMRUNUT1IsDQoJCS5wZ3BvbGljeSAgICAgID0gR1JPVVBfQllf
U0VSSUFMLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KCQkucnJfd2VpZ2h0
ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllf
VU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJLmNoZWNrZXJfbmFt
ZSAgPSBIUF9TVywNCgl9LA0KCXsNCgkJLnZlbmRvciAgICAgICAgPSAiKENPTVBBUXxIUCkiLA0K
CQkucHJvZHVjdCAgICAgICA9ICIoTVNBfEhTVikxLioiLA0KCQkuZ2V0dWlkICAgICAgICA9IERF
RkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5mZWF0dXJlcyAgICAg
ID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSAiMSBocF9zdyIsDQoJCS5z
ZWxlY3RvciAgICAgID0gREVGQVVMVF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAgPSBNVUxU
SUJVUywNCgkJLnBnZmFpbGJhY2sgICAgPSBGQUlMQkFDS19VTkRFRiwNCgkJLnJyX3dlaWdodCAg
ICAgPSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VO
REVGLA0KCQkubWluaW8gICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUg
ID0gSFBfU1csDQoJfSwNCgl7DQoJCS52ZW5kb3IgICAgICAgID0gIkhQIiwNCgkJLnByb2R1Y3Qg
ICAgICAgPSAiQTYxODlBIiwNCgkJLmdldHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJ
LmdldHByaW8gICAgICAgPSBOVUxMLA0KCQkuZmVhdHVyZXMgICAgICA9IERFRkFVTFRfRkVBVFVS
RVMsDQoJCS5od2hhbmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIsDQoJCS5zZWxlY3RvciAg
ICAgID0gREVGQVVMVF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAgPSBNVUxUSUJVUywNCgkJ
LnBnZmFpbGJhY2sgICAgPSBGQUlMQkFDS19VTkRFRiwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9X
RUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQku
bWluaW8gICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0gUkVBRFNF
Q1RPUjAsDQoJfSwNCgl7DQoJCS52ZW5kb3IgICAgICAgID0gIkhQIiwNCgkJLnByb2R1Y3QgICAg
ICAgPSAiSFNWMjAuKiIsDQoJCS5yZXZpc2lvbiAgICAgID0gIlsxMjNdLioiLA0KCQkuZ2V0dWlk
ICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5m
ZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZB
VUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQku
cGdwb2xpY3kgICAgICA9IE1VTFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VO
REVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRy
eSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5J
TywNCgkJLmNoZWNrZXJfbmFtZSAgPSBIUF9TVywNCgl9LA0KCXsNCgkJLnZlbmRvciAgICAgICAg
PSAiSFAiLA0KCQkucHJvZHVjdCAgICAgICA9ICJIU1YyMC4qIiwNCgkJLnJldmlzaW9uICAgICAg
PSAiW14xMjNdLioiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0
cHJpbyAgICAgICA9ICIvc2Jpbi9tcGF0aF9wcmlvX2FsdWEgL2Rldi8lbiIsDQoJCS5mZWF0dXJl
cyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hX
SEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xp
Y3kgICAgICA9IE1VTFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IC1GQUlMQkFDS19JTU1FRElB
VEUsDQoJCS5ycl93ZWlnaHQgICAgID0gUlJfV0VJR0hUX05PTkUsDQoJCS5ub19wYXRoX3JldHJ5
ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiwNCgkJLm1pbmlvICAgICAgICAgPSBERUZBVUxUX01JTklP
LA0KCQkuY2hlY2tlcl9uYW1lICA9IFRVUiwNCgl9LA0KCXsNCgkJLnZlbmRvciAgICAgICAgPSAi
SFAiLA0KCQkucHJvZHVjdCAgICAgICA9ICJIU1YyMS4qIiwNCgkJLmdldHVpZCAgICAgICAgPSBE
RUZBVUxUX0dFVFVJRCwNCgkJLmdldHByaW8gICAgICAgPSAiL3NiaW4vbXBhdGhfcHJpb19hbHVh
IC9kZXYvJW4iLA0KCQkuZmVhdHVyZXMgICAgICA9IERFRkFVTFRfRkVBVFVSRVMsDQoJCS5od2hh
bmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIsDQoJCS5zZWxlY3RvciAgICAgID0gREVGQVVM
VF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAgPSBHUk9VUF9CWV9QUklPLA0KCQkucGdmYWls
YmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9O
T05FLA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAg
ICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBUVVIsDQoJfSwNCgkv
Kg0KCSAqIERETiBjb250cm9sbGVyIGZhbWlseQ0KCSAqDQoJICogTWFpbnRhaW5lciA6IENocmlz
dG9waGUgVmFyb3F1aQ0KCSAqIE1haWwgOiBjaHJpc3RvcGhlLnZhcm9xdWlAZnJlZS5mcg0KCSAq
Lw0KCXsNCgkJLnZlbmRvciAgICAgICAgPSAiREROIiwNCgkJLnByb2R1Y3QgICAgICAgPSAiU0FO
IERhdGFEaXJlY3RvciIsDQoJCS5nZXR1aWQgICAgICAgID0gREVGQVVMVF9HRVRVSUQsDQoJCS5n
ZXRwcmlvICAgICAgID0gTlVMTCwNCgkJLmZlYXR1cmVzICAgICAgPSBERUZBVUxUX0ZFQVRVUkVT
LA0KCQkuaHdoYW5kbGVyICAgICA9IERFRkFVTFRfSFdIQU5ETEVSLA0KCQkuc2VsZWN0b3IgICAg
ICA9IERFRkFVTFRfU0VMRUNUT1IsDQoJCS5wZ3BvbGljeSAgICAgID0gTVVMVElCVVMsDQoJCS5w
Z2ZhaWxiYWNrICAgID0gRkFJTEJBQ0tfVU5ERUYsDQoJCS5ycl93ZWlnaHQgICAgID0gUlJfV0VJ
R0hUX05PTkUsDQoJCS5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiwNCgkJLm1p
bmlvICAgICAgICAgPSBERUZBVUxUX01JTklPLA0KCQkuY2hlY2tlcl9uYW1lICA9IERJUkVDVElP
LA0KCX0sDQoJLyoNCgkgKiBFTUMgLyBDbGFyaWlvbiBjb250cm9sbGVyIGZhbWlseQ0KCSAqDQoJ
ICogTWFpbnRhaW5lciA6IEVkd2FyZCBHb2dnaW4sIEVNQw0KCSAqIE1haWwgOiBlZ29nZ2luQGVt
Yy5jb20NCgkgKi8NCgl7DQoJCS52ZW5kb3IgICAgICAgID0gIkVNQyIsDQoJCS5wcm9kdWN0ICAg
ICAgID0gIlNZTU1FVFJJWCIsDQoJCS5nZXR1aWQgICAgICAgID0gInNjc2lfaWQgLWcgLXUgLXBw
cmUtc3BjMy04MyAtcyAvYmxvY2svJW4iLA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5m
ZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZB
VUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQku
cGdwb2xpY3kgICAgICA9IE1VTFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VO
REVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRy
eSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5J
TywNCgkJLmNoZWNrZXJfbmFtZSAgPSBSRUFEU0VDVE9SMCwNCgl9LA0KCXsNCgkJLnZlbmRvciAg
ICAgICAgPSAiREdDIiwNCgkJLnByb2R1Y3QgICAgICAgPSAiLioiLA0KCQkuYmxfcHJvZHVjdCAg
ICA9ICJMVU5aIiwNCgkJLmdldHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHBy
aW8gICAgICAgPSAibXBhdGhfcHJpb19lbWMgL2Rldi8lbiIsDQoJCS5mZWF0dXJlcyAgICAgID0g
IjEgcXVldWVfaWZfbm9fcGF0aCIsDQoJCS5od2hhbmRsZXIgICAgID0gIjEgZW1jIiwNCgkJLnNl
bGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xpY3kgICAgICA9IEdST1VQ
X0JZX1BSSU8sDQoJCS5wZ2ZhaWxiYWNrICAgID0gLUZBSUxCQUNLX0lNTUVESUFURSwNCgkJLnJy
X3dlaWdodCAgICAgPSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSAoMzAwIC8g
REVGQVVMVF9DSEVDS0lOVCksDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJ
LmNoZWNrZXJfbmFtZSAgPSBFTUNfQ0xBUklJT04sDQoJfSwNCgkvKg0KCSAqIEZ1aml0c3UgY29u
dHJvbGxlciBmYW1pbHkNCgkgKg0KCSAqIE1haW50YWluZXIgOiBDaHJpc3RvcGhlIFZhcm9xdWkN
CgkgKiBNYWlsIDogY2hyaXN0b3BoZS52YXJvcXVpQGZyZWUuZnINCgkgKi8NCgl7DQoJCS52ZW5k
b3IgICAgICAgID0gIkZTQyIsDQoJCS5wcm9kdWN0ICAgICAgID0gIkNlbnRyaWNTdG9yIiwNCgkJ
LmdldHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHByaW8gICAgICAgPSBOVUxM
LA0KCQkuZmVhdHVyZXMgICAgICA9IERFRkFVTFRfRkVBVFVSRVMsDQoJCS5od2hhbmRsZXIgICAg
ID0gREVGQVVMVF9IV0hBTkRMRVIsDQoJCS5zZWxlY3RvciAgICAgID0gREVGQVVMVF9TRUxFQ1RP
UiwNCgkJLnBncG9saWN5ICAgICAgPSBHUk9VUF9CWV9TRVJJQUwsDQoJCS5wZ2ZhaWxiYWNrICAg
ID0gRkFJTEJBQ0tfVU5ERUYsDQoJCS5ycl93ZWlnaHQgICAgID0gUlJfV0VJR0hUX05PTkUsDQoJ
CS5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiwNCgkJLm1pbmlvICAgICAgICAg
PSBERUZBVUxUX01JTklPLA0KCQkuY2hlY2tlcl9uYW1lICA9IFJFQURTRUNUT1IwLA0KCX0sDQoJ
LyoNCgkgKiBIaXRhY2hpIGNvbnRyb2xsZXIgZmFtaWx5DQoJICoNCgkgKiBNYWludGFpbmVyIDog
TWF0dGhpYXMgUnVkb2xwaA0KCSAqIE1haWwgOiBtYXR0aGlhcy5ydWRvbHBoQGhkcy5jb20NCgkg
Ki8NCgl7DQoJCS52ZW5kb3IgICAgICAgID0gIihISVRBQ0hJfEhQKSIsDQoJCS5wcm9kdWN0ICAg
ICAgID0gIk9QRU4tLioiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQku
Z2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5mZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJF
UywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAg
ICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xpY3kgICAgICA9IE1VTFRJQlVTLA0KCQku
cGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dF
SUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5t
aW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBSRUFEU0VD
VE9SMCwNCgl9LA0KCXsNCgkJLnZlbmRvciAgICAgICAgPSAiSElUQUNISSIsDQoJCS5wcm9kdWN0
ICAgICAgID0gIkRGLioiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQku
Z2V0cHJpbyAgICAgICA9ICJtcGF0aF9wcmlvX2hkc19tb2R1bGFyICVkIiwNCgkJLmZlYXR1cmVz
ICAgICAgPSBERUZBVUxUX0ZFQVRVUkVTLA0KCQkuaHdoYW5kbGVyICAgICA9IERFRkFVTFRfSFdI
QU5ETEVSLA0KCQkuc2VsZWN0b3IgICAgICA9IERFRkFVTFRfU0VMRUNUT1IsDQoJCS5wZ3BvbGlj
eSAgICAgID0gR1JPVVBfQllfUFJJTywNCgkJLnBnZmFpbGJhY2sgICAgPSAtRkFJTEJBQ0tfSU1N
RURJQVRFLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9y
ZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9N
SU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBSRUFEU0VDVE9SMCwNCgl9LA0KCS8qDQoJICogSUJN
IGNvbnRyb2xsZXIgZmFtaWx5DQoJICoNCgkgKiBNYWludGFpbmVyIDogSGFubmVzIFJlaW5lY2tl
LCBTdVNFDQoJICogTWFpbCA6IGhhcmVAc3VzZS5kZQ0KCSAqLw0KCXsNCgkJLnZlbmRvciAgICAg
ICAgPSAiSUJNIiwNCgkJLnByb2R1Y3QgICAgICAgPSAiUHJvRmlicmUgNDAwMFIiLA0KCQkuZ2V0
dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJ
CS5mZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBE
RUZBVUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0K
CQkucGdwb2xpY3kgICAgICA9IE1VTFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNL
X1VOREVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9y
ZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9N
SU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBSRUFEU0VDVE9SMCwNCgl9LA0KCXsNCgkJLyogSUJN
IERTNDEwMCAvIEZBU3RUMTAwICovDQoJCS52ZW5kb3IgICAgICAgID0gIklCTSIsDQoJCS5wcm9k
dWN0ICAgICAgID0gIjE3NDIiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0K
CQkuZ2V0cHJpbyAgICAgICA9ICJtcGF0aF9wcmlvX3RwYyAvZGV2LyVuIiwNCgkJLmZlYXR1cmVz
ICAgICAgPSBERUZBVUxUX0ZFQVRVUkVTLA0KCQkuaHdoYW5kbGVyICAgICA9IERFRkFVTFRfSFdI
QU5ETEVSLA0KCQkuc2VsZWN0b3IgICAgICA9IERFRkFVTFRfU0VMRUNUT1IsDQoJCS5wZ3BvbGlj
eSAgICAgID0gR1JPVVBfQllfUFJJTywNCgkJLnBnZmFpbGJhY2sgICAgPSAtRkFJTEJBQ0tfSU1N
RURJQVRFLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9y
ZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9N
SU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBUVVIsDQoJfSwNCgl7DQoJCS8qIElCTSBOZXRmaW5p
dHkgRmlicmUgQ2hhbm5lbCBSQUlEIENvbnRyb2xsZXIgVW5pdCAqLw0KCQkudmVuZG9yICAgICAg
ICA9ICJJQk0iLA0KCQkucHJvZHVjdCAgICAgICA9ICIzNTI2IiwNCgkJLmdldHVpZCAgICAgICAg
PSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHByaW8gICAgICAgPSAibXBhdGhfcHJpb190cGMgL2Rl
di8lbiIsDQoJCS5mZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxl
ciAgICAgPSBERUZBVUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NF
TEVDVE9SLA0KCQkucGdwb2xpY3kgICAgICA9IEdST1VQX0JZX1BSSU8sDQoJCS5wZ2ZhaWxiYWNr
ICAgID0gLUZBSUxCQUNLX0lNTUVESUFURSwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlHSFRf
Tk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQkubWluaW8g
ICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0gVFVSLA0KCX0sDQoJ
ew0KCQkvKiBJQk0gRFM0MjAwIC8gRkFTdFQyMDAgKi8NCgkJLnZlbmRvciAgICAgICAgPSAiSUJN
IiwNCgkJLnByb2R1Y3QgICAgICAgPSAiMzU0MiIsDQoJCS5nZXR1aWQgICAgICAgID0gREVGQVVM
VF9HRVRVSUQsDQoJCS5nZXRwcmlvICAgICAgID0gTlVMTCwNCgkJLmZlYXR1cmVzICAgICAgPSBE
RUZBVUxUX0ZFQVRVUkVTLA0KCQkuaHdoYW5kbGVyICAgICA9IERFRkFVTFRfSFdIQU5ETEVSLA0K
CQkuc2VsZWN0b3IgICAgICA9IERFRkFVTFRfU0VMRUNUT1IsDQoJCS5wZ3BvbGljeSAgICAgID0g
R1JPVVBfQllfU0VSSUFMLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KCQku
cnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BB
VEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJLmNo
ZWNrZXJfbmFtZSAgPSBUVVIsDQoJfSwNCgl7DQoJCS8qIElCTSBFU1MgRjIwIGFrYSBTaGFyayAq
Lw0KCQkudmVuZG9yICAgICAgICA9ICJJQk0iLA0KCQkucHJvZHVjdCAgICAgICA9ICIyMTA1KDgw
MHxGMjApIiwNCgkJLmdldHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHByaW8g
ICAgICAgPSBOVUxMLA0KCQkuZmVhdHVyZXMgICAgICA9ICIxIHF1ZXVlX2lmX25vX3BhdGgiLA0K
CQkuaHdoYW5kbGVyICAgICA9IERFRkFVTFRfSFdIQU5ETEVSLA0KCQkuc2VsZWN0b3IgICAgICA9
IERFRkFVTFRfU0VMRUNUT1IsDQoJCS5wZ3BvbGljeSAgICAgID0gR1JPVVBfQllfU0VSSUFMLA0K
CQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJS
X1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJ
CS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBUVVIs
DQoJfSwNCgl7DQoJCS8qIElCTSBEUzYwMDAgKi8NCgkJLnZlbmRvciAgICAgICAgPSAiSUJNIiwN
CgkJLnByb2R1Y3QgICAgICAgPSAiMTc1MDUwMCIsDQoJCS5nZXR1aWQgICAgICAgID0gREVGQVVM
VF9HRVRVSUQsDQoJCS5nZXRwcmlvICAgICAgID0gIm1wYXRoX3ByaW9fYWx1YSAvZGV2LyVuIiwN
CgkJLmZlYXR1cmVzICAgICAgPSAiMSBxdWV1ZV9pZl9ub19wYXRoIiwNCgkJLmh3aGFuZGxlciAg
ICAgPSBERUZBVUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVD
VE9SLA0KCQkucGdwb2xpY3kgICAgICA9IEdST1VQX0JZX1BSSU8sDQoJCS5wZ2ZhaWxiYWNrICAg
ID0gLUZBSUxCQUNLX0lNTUVESUFURSwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlHSFRfTk9O
RSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQkubWluaW8gICAg
ICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0gVFVSLA0KCX0sDQoJew0K
CQkvKiBJQk0gRFM4MDAwICovDQoJCS52ZW5kb3IgICAgICAgID0gIklCTSIsDQoJCS5wcm9kdWN0
ICAgICAgID0gIjIxMDc5MDAiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0K
CQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5mZWF0dXJlcyAgICAgID0gIjEgcXVldWVfaWZf
bm9fcGF0aCIsDQoJCS5od2hhbmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIsDQoJCS5zZWxl
Y3RvciAgICAgID0gREVGQVVMVF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAgPSBNVUxUSUJV
UywNCgkJLnBnZmFpbGJhY2sgICAgPSBGQUlMQkFDS19VTkRFRiwNCgkJLnJyX3dlaWdodCAgICAg
PSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVG
LA0KCQkubWluaW8gICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0g
VFVSLA0KCX0sDQoJew0KCQkvKiBJQk0gU0FOIFZvbHVtZSBDb250cm9sbGVyICovDQoJCS52ZW5k
b3IgICAgICAgID0gIklCTSIsDQoJCS5wcm9kdWN0ICAgICAgID0gIjIxNDUiLA0KCQkuZ2V0dWlk
ICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9ICJtcGF0aF9wcmlv
X2FsdWEgL2Rldi8lbiIsDQoJCS5mZWF0dXJlcyAgICAgID0gIjEgcXVldWVfaWZfbm9fcGF0aCIs
DQoJCS5od2hhbmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIsDQoJCS5zZWxlY3RvciAgICAg
ID0gREVGQVVMVF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAgPSBHUk9VUF9CWV9QUklPLA0K
CQkucGdmYWlsYmFjayAgICA9IC1GQUlMQkFDS19JTU1FRElBVEUsDQoJCS5ycl93ZWlnaHQgICAg
ID0gUlJfV0VJR0hUX05PTkUsDQoJCS5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRF
RiwNCgkJLm1pbmlvICAgICAgICAgPSBERUZBVUxUX01JTklPLA0KCQkuY2hlY2tlcl9uYW1lICA9
IFRVUiwNCgl9LA0KCXsNCgkJLyogSUJNIFMvMzkwIEVDS0QgREFTRCAqLw0KCQkudmVuZG9yICAg
ICAgICA9ICJJQk0iLA0KCQkucHJvZHVjdCAgICAgICA9ICJTLzM5MCBEQVNEIEVDS0QiLA0KCQku
YmxfcHJvZHVjdCAgICAgICA9ICJTLzM5MC4qIiwNCgkJLmdldHVpZCAgICAgICAgPSAiZGFzZF9p
ZCAvZGV2LyVuIiwNCgkJLmdldHByaW8gICAgICAgPSBOVUxMLA0KCQkuZmVhdHVyZXMgICAgICA9
IERFRkFVTFRfRkVBVFVSRVMsDQoJCS5od2hhbmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIs
DQoJCS5zZWxlY3RvciAgICAgID0gREVGQVVMVF9TRUxFQ1RPUiwNCgkJLnBncG9saWN5ICAgICAg
PSBNVUxUSUJVUywNCgkJLnBnZmFpbGJhY2sgICAgPSBGQUlMQkFDS19VTkRFRiwNCgkJLnJyX3dl
aWdodCAgICAgPSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JF
VFJZX1VOREVGLA0KCQkubWluaW8gICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2Vy
X25hbWUgID0gRElSRUNUSU8sDQoJfSwNCiAJLyoNCgkgKiBORVRBUFAgY29udHJvbGxlciBmYW1p
bHkNCgkgKg0KCSAqIE1haW50YWluZXIgOiBEYXZlIFd5c29jaGFuc2tpDQoJICogTWFpbCA6IGRh
dmlkd0BuZXRhcHAuY29tDQoJICovDQoJew0KCQkudmVuZG9yICAgICAgICA9ICJORVRBUFAiLA0K
CQkucHJvZHVjdCAgICAgICA9ICJMVU4uKiIsDQoJCS5nZXR1aWQgICAgICAgID0gREVGQVVMVF9H
RVRVSUQsDQoJCS5nZXRwcmlvICAgICAgID0gIm1wYXRoX3ByaW9fbmV0YXBwIC9kZXYvJW4iLA0K
CQkuZmVhdHVyZXMgICAgICA9ICIxIHF1ZXVlX2lmX25vX3BhdGgiLA0KCQkuaHdoYW5kbGVyICAg
ICA9IERFRkFVTFRfSFdIQU5ETEVSLA0KCQkuc2VsZWN0b3IgICAgICA9IERFRkFVTFRfU0VMRUNU
T1IsDQoJCS5wZ3BvbGljeSAgICAgID0gR1JPVVBfQllfUFJJTywNCgkJLnBnZmFpbGJhY2sgICAg
PSAtRkFJTEJBQ0tfSU1NRURJQVRFLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05F
LA0KCQkubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAg
ICAgID0gMTI4LA0KCQkuY2hlY2tlcl9uYW1lICA9IFJFQURTRUNUT1IwLA0KCX0sDQogCS8qDQoJ
ICogSUJNIE5TZXJpZXMgKE5FVEFQUCkgY29udHJvbGxlciBmYW1pbHkNCgkgKg0KCSAqIE1haW50
YWluZXIgOiBEYXZlIFd5c29jaGFuc2tpDQoJICogTWFpbCA6IGRhdmlkd0BuZXRhcHAuY29tDQoJ
ICovDQoJew0KCQkudmVuZG9yICAgICAgICA9ICJJQk0iLA0KCQkucHJvZHVjdCAgICAgICA9ICJO
c2VyaWVzLioiLA0KCQkuZ2V0dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJp
byAgICAgICA9ICJtcGF0aF9wcmlvX25ldGFwcCAvZGV2LyVuIiwNCgkJLmZlYXR1cmVzICAgICAg
PSAiMSBxdWV1ZV9pZl9ub19wYXRoIiwNCgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hXSEFO
RExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xpY3kg
ICAgICA9IEdST1VQX0JZX1BSSU8sDQoJCS5wZ2ZhaWxiYWNrICAgID0gLUZBSUxCQUNLX0lNTUVE
SUFURSwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0
cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQkubWluaW8gICAgICAgICA9IDEyOCwNCgkJLmNo
ZWNrZXJfbmFtZSAgPSBSRUFEU0VDVE9SMCwNCgl9LA0KCS8qDQoJICogUGlsbGFyIERhdGEgY29u
dHJvbGxlciBmYW1pbHkNCgkgKg0KCSAqIE1haW50YWluZXIgOiBTcmluaXZhc2FuIFJhbWFuaQ0K
CSAqIE1haWwgOiBzcmFtYW5pQHBpbGxhcmRhdGEuY29tDQoJICovDQoJew0KCQkudmVuZG9yICAg
ICAgICA9ICJQaWxsYXIiLA0KCQkucHJvZHVjdCAgICAgICA9ICIqIiwNCgkJLmdldHVpZCAgICAg
ICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHByaW8gICAgICAgPSAibXBhdGhfcHJpb19hbHVh
ICVuIiwNCgkJLmZlYXR1cmVzICAgICAgPSBERUZBVUxUX0ZFQVRVUkVTLA0KCQkuaHdoYW5kbGVy
ICAgICA9IERFRkFVTFRfSFdIQU5ETEVSLA0KCQkuc2VsZWN0b3IgICAgICA9IERFRkFVTFRfU0VM
RUNUT1IsDQoJCS5wZ3BvbGljeSAgICAgID0gR1JPVVBfQllfUFJJTywNCgkJLnBnZmFpbGJhY2sg
ICAgPSBGQUlMQkFDS19VTkRFRiwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlHSFRfTk9ORSwN
CgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQkubWluaW8gICAgICAg
ICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0gVFVSLA0KCX0sDQoJLyoNCgkg
KiBTR0kgYXJyYXlzDQoJICoNCgkgKiBNYWludGFpbmVyIDogQ2hyaXN0b3BoZSBWYXJvcXVpDQoJ
ICogTWFpbCA6IGNocmlzdG9waGUudmFyb3F1aUBmcmVlLmZyDQoJICovDQoJew0KCQkudmVuZG9y
ICAgICAgICA9ICJTR0kiLA0KCQkucHJvZHVjdCAgICAgICA9ICJUUDlbMTNdMDAiLA0KCQkuZ2V0
dWlkICAgICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJ
CS5mZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBE
RUZBVUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0K
CQkucGdwb2xpY3kgICAgICA9IE1VTFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNL
X1VOREVGLA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9y
ZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9N
SU5JTywNCgkJLmNoZWNrZXJfbmFtZSAgPSBSRUFEU0VDVE9SMCwNCgl9LA0KCXsNCgkJLnZlbmRv
ciAgICAgICAgPSAiU0dJIiwNCgkJLnByb2R1Y3QgICAgICAgPSAiVFA5WzQ1XTAwIiwNCgkJLmdl
dHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJLmdldHByaW8gICAgICAgPSAibXBhdGhf
cHJpb190cGMgL2Rldi8lbiIsDQoJCS5mZWF0dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywN
CgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAg
PSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xpY3kgICAgICA9IEdST1VQX0JZX1BSSU8sDQoJ
CS5wZ2ZhaWxiYWNrICAgID0gLUZBSUxCQUNLX0lNTUVESUFURSwNCgkJLnJyX3dlaWdodCAgICAg
PSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVG
LA0KCQkubWluaW8gICAgICAgICA9IERFRkFVTFRfTUlOSU8sDQoJCS5jaGVja2VyX25hbWUgID0g
VFVSLA0KCX0sDQoJLyoNCgkgKiBTVEsgYXJyYXlzDQoJICoNCgkgKiBNYWludGFpbmVyIDogQ2hy
aXN0b3BoZSBWYXJvcXVpDQoJICogTWFpbCA6IGNocmlzdG9waGUudmFyb3F1aUBmcmVlLmZyDQoJ
ICovDQoJew0KCQkudmVuZG9yICAgICAgICA9ICJTVEsiLA0KCQkucHJvZHVjdCAgICAgICA9ICJP
UEVOc3RvcmFnZSBEMjgwIiwNCgkJLmdldHVpZCAgICAgICAgPSBERUZBVUxUX0dFVFVJRCwNCgkJ
LmdldHByaW8gICAgICAgPSAibXBhdGhfcHJpb190cGMgL2Rldi8lbiIsDQoJCS5mZWF0dXJlcyAg
ICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hXSEFO
RExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdwb2xpY3kg
ICAgICA9IEdST1VQX0JZX1BSSU8sDQoJCS5wZ2ZhaWxiYWNrICAgID0gLUZBSUxCQUNLX0lNTUVE
SUFURSwNCgkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlHSFRfTk9ORSwNCgkJLm5vX3BhdGhfcmV0
cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLA0KCQkubWluaW8gICAgICAgICA9IERFRkFVTFRfTUlO
SU8sDQoJCS5jaGVja2VyX25hbWUgID0gVFVSLA0KCX0sDQoJLyoNCgkgKiBTVU4gYXJyYXlzDQoJ
ICoNCgkgKiBNYWludGFpbmVyIDogQ2hyaXN0b3BoZSBWYXJvcXVpDQoJICogTWFpbCA6IGNocmlz
dG9waGUudmFyb3F1aUBmcmVlLmZyDQoJICovDQoJew0KCQkudmVuZG9yICAgICAgICA9ICJTVU4i
LA0KCQkucHJvZHVjdCAgICAgICA9ICIoU3RvckVkZ2UgMzUxMHxUNCkiLA0KCQkuZ2V0dWlkICAg
ICAgICA9IERFRkFVTFRfR0VUVUlELA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5mZWF0
dXJlcyAgICAgID0gREVGQVVMVF9GRUFUVVJFUywNCgkJLmh3aGFuZGxlciAgICAgPSBERUZBVUxU
X0hXSEFORExFUiwNCgkJLnNlbGVjdG9yICAgICAgPSBERUZBVUxUX1NFTEVDVE9SLA0KCQkucGdw
b2xpY3kgICAgICA9IE1VTFRJQlVTLA0KCQkucGdmYWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVG
LA0KCQkucnJfd2VpZ2h0ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KCQkubm9fcGF0aF9yZXRyeSA9
IE5PX1BBVEhfUkVUUllfVU5ERUYsDQoJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywN
CgkJLmNoZWNrZXJfbmFtZSAgPSBSRUFEU0VDVE9SMCwNCgl9LA0KCS8qDQoJICogRU9MDQoJICov
DQoJew0KCQkudmVuZG9yICAgICAgICA9IE5VTEwsDQoJCS5wcm9kdWN0ICAgICAgID0gTlVMTCwN
CgkJLmdldHVpZCAgICAgICAgPSBOVUxMLA0KCQkuZ2V0cHJpbyAgICAgICA9IE5VTEwsDQoJCS5m
ZWF0dXJlcyAgICAgID0gTlVMTCwNCgkJLmh3aGFuZGxlciAgICAgPSBOVUxMLA0KCQkuc2VsZWN0
b3IgICAgICA9IE5VTEwsDQoJCS5wZ3BvbGljeSAgICAgID0gMCwNCgkJLnBnZmFpbGJhY2sgICAg
PSAwLA0KCQkucnJfd2VpZ2h0ICAgICA9IDAsDQoJCS5ub19wYXRoX3JldHJ5ID0gMCwNCgkJLm1p
bmlvICAgICAgICAgPSAwLA0KCQkuY2hlY2tlcl9uYW1lICA9IE5VTEwsDQoJfSwNCn07DQoNCmV4
dGVybiBpbnQNCnNldHVwX2RlZmF1bHRfaHd0YWJsZSAodmVjdG9yIGh3KQ0Kew0KCWludCByID0g
MDsNCglzdHJ1Y3QgaHdlbnRyeSAqIGh3ZSA9IGRlZmF1bHRfaHc7DQoNCgl3aGlsZSAoaHdlLSZn
dDt2ZW5kb3IpIHsNCgkJaHdlLSZndDtjaGVja2VyID0gY2hlY2tlcl9sb29rdXAoaHdlLSZndDtj
aGVja2VyX25hbWUpOw0KCQlyICs9IHN0b3JlX2h3ZShodywgaHdlKTsNCgkJaHdlKys7DQoJfQ0K
CXJldHVybiByOw0KfQ0K

------_=_NextPart_001_01C7496F.F28ED879
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C7496F.F28ED879--
