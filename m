From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: default config details for HP arrays
Date: Mon, 21 Nov 2005 19:42:27 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA00306FB96@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C5EEA5.9A86050B"
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
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5EEA5.9A86050B
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_002_01C5EEA5.9A86050B"


------_=_NextPart_002_01C5EEA5.9A86050B
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

I have added the default config details for HP arrays into
multipath.conf files and hwtable.c for in-code defaults. The patches are
made using the 0.4.5.48 sources (which is the part of U2 codebase). I
request you to get the information updated for U3 codebase onwards.

=20

XP array supports multiple product id's. The information for XP array
(in the config details) is the regular expression, and this will work
only if the patch sent earlier that uses regexcomp for product string
comparisons, is included into the multipath-tools code base.

=20

The following are the XP product strings,

=20

OPEN-X, where X =3D {3, 8, 9, K, T, E, V} and

3390-3A, 3390-3B, OP-C:3390-3C, 3380KA, 3380-KB, OP-C:3380-KC

Thanks and regards
-Murthy


------_=_NextPart_002_01C5EEA5.9A86050B
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
10.0pt;font-family:"MS Sans Serif"'>Hi =
Alasdair,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>I have added the default config =
details for
HP arrays into multipath.conf files and hwtable.c for in-code defaults. =
The
patches are made using the 0.4.5.48 sources (which is the part of U2 =
codebase).
I request you to get the information updated for U3 codebase =
onwards.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>XP array supports multiple product =
id&#8217;s.
The information for XP array (in the config details) is the regular =
expression,
and this will work only if the patch sent earlier that uses regexcomp =
for
product string comparisons, is included into the multipath-tools code =
base.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>The following are the XP product =
strings,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>OPEN-X, where X =3D {3, 8, 9, K, T, =
E, V} and<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
lang=3DPL
style=3D'font-size:10.0pt;font-family:"MS Sans Serif"'>3390-3A, 3390-3B,
OP-C:3390-3C, 3380KA, 3380-KB, OP-C:3380-KC<o:p></o:p></span></font></p>

<p><font size=3D2 face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;
font-family:"Microsoft Sans Serif"'>Thanks and regards<br>
-Murthy<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_002_01C5EEA5.9A86050B--

------_=_NextPart_001_01C5EEA5.9A86050B
Content-Type: application/octet-stream;
	name="hwtable.c.patch"
Content-Transfer-Encoding: base64
Content-Description: hwtable.c.patch
Content-Disposition: attachment;
	filename="hwtable.c.patch"

ZGlmZiAtdXJOIG11bHRpcGF0aC10b29scy0wLjQuNS40OC9saWJtdWx0aXBhdGgvaHd0YWJsZS5j
IG11bHRpcGF0aC10b29scy0wLjQuNS40OC1tb2QvbGlibXVsdGlwYXRoL2h3dGFibGUuYwotLS0g
bXVsdGlwYXRoLXRvb2xzLTAuNC41LjQ4L2xpYm11bHRpcGF0aC9od3RhYmxlLmMJMjAwNS0xMS0y
MSAxODoyMjo1Ny4wMDAwMDAwMDAgKzA1MzAKKysrIG11bHRpcGF0aC10b29scy0wLjQuNS40OC1t
b2QvbGlibXVsdGlwYXRoL2h3dGFibGUuYwkyMDA1LTExLTIxIDE5OjA3OjUzLjAwMDAwMDAwMCAr
MDUzMApAQCAtMTUsNiArMTUsMTggQEAKIAlyICs9IHN0b3JlX2h3ZShodywgIkNPTVBBUSIsICJI
U1YxMTAgKEMpQ09NUEFRIiwgR1JPVVBfQllfU0VSSUFMLCBERUZBVUxUX0dFVFVJRCk7CiAJciAr
PSBzdG9yZV9od2UoaHcsICJDT01QQVEiLCAiTVNBMTAwMCIsIEdST1VQX0JZX1NFUklBTCwgREVG
QVVMVF9HRVRVSUQpOwogCXIgKz0gc3RvcmVfaHdlKGh3LCAiQ09NUEFRIiwgIk1TQTEwMDAgVk9M
VU1FIiwgR1JPVVBfQllfU0VSSUFMLCBERUZBVUxUX0dFVFVJRCk7CisgICAgICAgIHIgKz0gc3Rv
cmVfaHdlKGh3LCAiSFAiLCAiSFNWMjAwIiwgR1JPVVBfQllfU0VSSUFMLCBERUZBVUxUX0dFVFVJ
RCwgTlVMTCwgIjAiLAorCQkiMSBxdWV1ZV9pZl9ub19wYXRoIiwgInR1ciIpOworICAgICAgICBy
ICs9IHN0b3JlX2h3ZShodywgIkhQIiwgIkhTVjIxMCIsIEdST1VQX0JZX1NFUklBTCwgREVGQVVM
VF9HRVRVSUQsIE5VTEwsICIwIiwgCisJCSIxIHF1ZXVlX2lmX25vX3BhdGgiLCAidHVyIik7Cisg
ICAgICAgIHIgKz0gc3RvcmVfaHdlKGh3LCAiSFAiLCAiSFNWMTAxIiwgR1JPVVBfQllfU0VSSUFM
LCBERUZBVUxUX0dFVFVJRCwgTlVMTCwgIjAiLAorCQkiMSBxdWV1ZV9pZl9ub19wYXRoIiwgInR1
ciIpOworICAgICAgICByICs9IHN0b3JlX2h3ZShodywgIkNPTVBBUSIsICJIU1YxMTEgKEMpQ09N
UEFRIiwgR1JPVVBfQllfU0VSSUFMLCBERUZBVUxUX0dFVFVJRCwKKwkJTlVMTCwgIjAiLCAiMSBx
dWV1ZV9pZl9ub19wYXRoIiwgInR1ciIpOworICAgICAgICByICs9IHN0b3JlX2h3ZShodywgIkhQ
IiwgIk1TQSBWT0xVTUUiLCBHUk9VUF9CWV9TRVJJQUwsIERFRkFVTFRfR0VUVUlELCBOVUxMLCAi
MCIsCisJCSIwIiwgInR1ciIpOworICAgICAgICByICs9IHN0b3JlX2h3ZShodywgIkhQIiwgIk9Q
RU4tLiIsIE1VTFRJQlVTLCBERUZBVUxUX0dFVFVJRCwgTlVMTCwgIjAiLCAiMCIsICJ0dXIiKTsK
KyAgICAgICAgciArPSBzdG9yZV9od2UoaHcsICJIUCIsICIqMzNbODldMCoiLCBNVUxUSUJVUywg
REVGQVVMVF9HRVRVSUQsIE5VTEwsICIwIiwgIjAiLCAidHVyIik7CiAJciArPSBzdG9yZV9od2Uo
aHcsICJERE4iLCAiU0FOIERhdGFEaXJlY3RvciIsIE1VTFRJQlVTLCBERUZBVUxUX0dFVFVJRCk7
CiAJciArPSBzdG9yZV9od2UoaHcsICJERUMiLCAiSFNHODAiLCBHUk9VUF9CWV9TRVJJQUwsIERF
RkFVTFRfR0VUVUlEKTsKIAlyICs9IHN0b3JlX2h3ZShodywgIkVNQyIsICJTWU1NRVRSSVgiLCBN
VUxUSUJVUywgREVGQVVMVF9HRVRVSUQpOwo=

------_=_NextPart_001_01C5EEA5.9A86050B
Content-Type: application/octet-stream;
	name="multipath.conf.patch"
Content-Transfer-Encoding: base64
Content-Description: multipath.conf.patch
Content-Disposition: attachment;
	filename="multipath.conf.patch"

ZGlmZiAtdXJOIGRldmljZS1tYXBwZXItbXVsdGlwYXRoLTAuNC41L211bHRpcGF0aC5jb25mLmFu
bm90YXRlZCBkZXZpY2UtbWFwcGVyLW11bHRpcGF0aC0wLjQuNS1tb2QvbXVsdGlwYXRoLmNvbmYu
YW5ub3RhdGVkCi0tLSBkZXZpY2UtbWFwcGVyLW11bHRpcGF0aC0wLjQuNS9tdWx0aXBhdGguY29u
Zi5hbm5vdGF0ZWQJMjAwNS0wNy0yMSAwMToxNDo1NC4wMDAwMDAwMDAgKzA1MzAKKysrIGRldmlj
ZS1tYXBwZXItbXVsdGlwYXRoLTAuNC41LW1vZC9tdWx0aXBhdGguY29uZi5hbm5vdGF0ZWQJMjAw
NS0xMS0yMSAxNjozNTo1Ni4wMDAwMDAwMDAgKzA1MzAKQEAgLTI4Miw2ICsyODIsNTEgQEAKICMJ
CXBhdGhfZ3JvdXBpbmdfcG9saWN5CW11bHRpYnVzCiAjCQlwYXRoX2NoZWNrZXIJCXR1cgogIwl9
CisjICAgICAgICAgICAgICAgdmVuZG9yICAgICAgICAgICAgICAgICAgIkhQICAgICAgIgorIyAg
ICAgICAgICAgICAgIHByb2R1Y3QgICAgICAgICAgICAgICAgICJIU1YyMDAgICAgICAgICAgIgor
IyAgICAgICAgICAgICAgIHBhdGhfZ3JvdXBpbmdfcG9saWN5ICAgIGdyb3VwX2J5X3NlcmlhbCAg
ICAgICAgICAKKyMgICAgICAgICAgICAgICBwYXRoX2NoZWNrZXIgICAgICAgICAgICB0dXIKKyMg
ICAgICAgICAgICAgICBmZWF0dXJlcyAgICAgICAgICAgICAgICAiMSBxdWV1ZV9pZl9ub19wYXRo
IgorIyAgICAgICAgfQorIyAgICAgICBkZXZpY2UgeworIyAgICAgICAgICAgICAgIHZlbmRvciAg
ICAgICAgICAgICAgICAgICJIUCAgICAgICIKKyMgICAgICAgICAgICAgICBwcm9kdWN0ICAgICAg
ICAgICAgICAgICAiSFNWMjEwICAgICAgICAgICIKKyMgICAgICAgICAgICAgICBwYXRoX2dyb3Vw
aW5nX3BvbGljeSAgICBncm91cF9ieV9zZXJpYWwKKyMgICAgICAgICAgICAgICBwYXRoX2NoZWNr
ZXIgICAgICAgICAgICB0dXIKKyMgICAgICAgICAgICAgICBmZWF0dXJlcyAgICAgICAgICAgICAg
ICAiMSBxdWV1ZV9pZl9ub19wYXRoIgorIyAgICAgICAgfQorIyAgICAgICBkZXZpY2UgeworIyAg
ICAgICAgICAgICAgIHZlbmRvciAgICAgICAgICAgICAgICAgICJIUCAgICAgICIKKyMgICAgICAg
ICAgICAgICBwcm9kdWN0ICAgICAgICAgICAgICAgICAiSFNWMTAxICAgICAgICAgICIKKyMgICAg
ICAgICAgICAgICBwYXRoX2dyb3VwaW5nX3BvbGljeSAgICBncm91cF9ieV9zZXJpYWwKKyMgICAg
ICAgICAgICAgICBwYXRoX2NoZWNrZXIgICAgICAgICAgICB0dXIKKyMgICAgICAgICAgICAgICBm
ZWF0dXJlcyAgICAgICAgICAgICAgICAiMSBxdWV1ZV9pZl9ub19wYXRoIgorIyAgICAgICAgfQor
IyAgICAgICBkZXZpY2UgeworIyAgICAgICAgICAgICAgIHZlbmRvciAgICAgICAgICAgICAgICAg
ICJDT01QQVEgICIKKyMgICAgICAgICAgICAgICBwcm9kdWN0ICAgICAgICAgICAgICAgICAiSFNW
MTExIChDKUNPTVBBUSIKKyMgICAgICAgICAgICAgICBwYXRoX2dyb3VwaW5nX3BvbGljeSAgICBn
cm91cF9ieV9zZXJpYWwKKyMgICAgICAgICAgICAgICBwYXRoX2NoZWNrZXIgICAgICAgICAgICB0
dXIKKyMgICAgICAgICAgICAgICBmZWF0dXJlcyAgICAgICAgICAgICAgICAiMSBxdWV1ZV9pZl9u
b19wYXRoIgorIyAgICAgICB9CisjICAgICAgZGV2aWNlIHsKKyMgICAgICAgICAgICAgICB2ZW5k
b3IgICAgICAgICAgICAgICAgICAiSFAgICAgICAiCisjICAgICAgICAgICAgICAgcHJvZHVjdCAg
ICAgICAgICAgICAgICAgIk1TQSBWT0xVTUUgICAgICAiCisjICAgICAgICAgICAgICAgcGF0aF9n
cm91cGluZ19wb2xpY3kgICAgZ3JvdXBfYnlfc2VyaWFsCisjICAgICAgICAgICAgICAgcGF0aF9j
aGVja2VyICAgICAgICAgICAgdHVyCisjICAgICAgIH0KKyMgICAgICAgZGV2aWNlIHsKKyMgICAg
ICAgICAgICAgICAgdmVuZG9yICAgICAgICAgICAgICAgICAiSFAgICAgICAiCisjICAgICAgICAg
ICAgICAgIHByb2R1Y3QgICAgICAgICAgICAgICAgIk9QRU4tLiAgICAgICAgICAiCisjICAgICAg
ICAgICAgICAgIHBhdGhfZ3JvdXBpbmdfcG9saWN5ICAgbXVsdGlidXMKKyMgICAgICAgICAgICAg
ICAgcGF0aF9jaGVja2VyICAgICAgICAgICB0dXIKKyMgICAgICAgIH0KKyMgICAgICAgZGV2aWNl
IHsKKyMgICAgICAgICAgICAgICAgdmVuZG9yICAgICAgICAgICAgICAgICAiSFAgICAgICAiCisj
ICAgICAgICAgICAgICAgIHByb2R1Y3QgICAgICAgICAgICAgICAgIiozM1s4OV0wKiAgICAgICAi
CisjICAgICAgICAgICAgICAgIHBhdGhfZ3JvdXBpbmdfcG9saWN5ICAgbXVsdGlidXMKKyMgICAg
ICAgICAgICAgICAgcGF0aF9jaGVja2VyICAgICAgICAgICB0dXIKKyMgICAgICAgIH0KICMJZGV2
aWNlIHsKICMJCXZlbmRvcgkJCSIzUEFSZGF0YSIKICMJCXByb2R1Y3QJCQkiVlYgICAgICAgICAg
ICAgICIKZGlmZiAtdXJOIGRldmljZS1tYXBwZXItbXVsdGlwYXRoLTAuNC41L211bHRpcGF0aC5j
b25mLnN5bnRoZXRpYyBkZXZpY2UtbWFwcGVyLW11bHRpcGF0aC0wLjQuNS1tb2QvbXVsdGlwYXRo
LmNvbmYuc3ludGhldGljCi0tLSBkZXZpY2UtbWFwcGVyLW11bHRpcGF0aC0wLjQuNS9tdWx0aXBh
dGguY29uZi5zeW50aGV0aWMJMjAwNS0wNi0yMSAwNjo0MTo0NC4wMDAwMDAwMDAgKzA1MzAKKysr
IGRldmljZS1tYXBwZXItbXVsdGlwYXRoLTAuNC41LW1vZC9tdWx0aXBhdGguY29uZi5zeW50aGV0
aWMJMjAwNS0xMS0yMSAxNjozODo0NS4wMDAwMDAwMDAgKzA1MzAKQEAgLTcxLDYgKzcxLDUyIEBA
CiAjCQlwYXRoX2NoZWNrZXIJCXR1cgogIwl9CiAjCWRldmljZSB7CisjICAgICAgICAgICAgICAg
dmVuZG9yICAgICAgICAgICAgICAgICAgIkhQICAgICAgIgorIyAgICAgICAgICAgICAgIHByb2R1
Y3QgICAgICAgICAgICAgICAgICJIU1YyMDAgICAgICAgICAgIgorIyAgICAgICAgICAgICAgIHBh
dGhfZ3JvdXBpbmdfcG9saWN5ICAgIGdyb3VwX2J5X3NlcmlhbCAgICAgICAgICAKKyMgICAgICAg
ICAgICAgICBwYXRoX2NoZWNrZXIgICAgICAgICAgICB0dXIKKyMgICAgICAgICAgICAgICBmZWF0
dXJlcyAgICAgICAgICAgICAgIAkiMSBxdWV1ZV9pZl9ub19wYXRoIgorIyAgICAgICAgfQorIyAg
ICAgICBkZXZpY2UgeworIyAgICAgICAgICAgICAgIHZlbmRvciAgICAgICAgICAgICAgICAgICJI
UCAgICAgICIKKyMgICAgICAgICAgICAgICBwcm9kdWN0ICAgICAgICAgICAgICAgICAiSFNWMjEw
ICAgICAgICAgICIKKyMgICAgICAgICAgICAgICBwYXRoX2dyb3VwaW5nX3BvbGljeSAgICBncm91
cF9ieV9zZXJpYWwKKyMgICAgICAgICAgICAgICBwYXRoX2NoZWNrZXIgICAgICAgICAgICB0dXIK
KyMgICAgICAgICAgICAgICBmZWF0dXJlcyAgICAgICAgICAgICAgICAiMSBxdWV1ZV9pZl9ub19w
YXRoIgorIyAgICAgICAgfQorIyAgICAgICBkZXZpY2UgeworIyAgICAgICAgICAgICAgIHZlbmRv
ciAgICAgICAgICAgICAgICAgICJIUCAgICAgICIKKyMgICAgICAgICAgICAgICBwcm9kdWN0ICAg
ICAgICAgICAgICAgICAiSFNWMTAxICAgICAgICAgICIKKyMgICAgICAgICAgICAgICBwYXRoX2dy
b3VwaW5nX3BvbGljeSAgICBncm91cF9ieV9zZXJpYWwKKyMgICAgICAgICAgICAgICBwYXRoX2No
ZWNrZXIgICAgICAgICAgICB0dXIKKyMgICAgICAgICAgICAgICBmZWF0dXJlcyAgICAgICAgICAg
ICAgICAiMSBxdWV1ZV9pZl9ub19wYXRoIgorIyAgICAgICAgfQorIyAgICAgICBkZXZpY2Ugewor
IyAgICAgICAgICAgICAgIHZlbmRvciAgICAgICAgICAgICAgICAgICJDT01QQVEgICIKKyMgICAg
ICAgICAgICAgICBwcm9kdWN0ICAgICAgICAgICAgICAgICAiSFNWMTExIChDKUNPTVBBUSIKKyMg
ICAgICAgICAgICAgICBwYXRoX2dyb3VwaW5nX3BvbGljeSAgICBncm91cF9ieV9zZXJpYWwKKyMg
ICAgICAgICAgICAgICBwYXRoX2NoZWNrZXIgICAgICAgICAgICB0dXIKKyMgICAgICAgICAgICAg
ICBmZWF0dXJlcyAgICAgICAgICAgICAgICAiMSBxdWV1ZV9pZl9ub19wYXRoIgorIyAgICAgICB9
CisjICAgICAgZGV2aWNlIHsKKyMgICAgICAgICAgICAgICB2ZW5kb3IgICAgICAgICAgICAgICAg
ICAiSFAgICAgICAiCisjICAgICAgICAgICAgICAgcHJvZHVjdCAgICAgICAgICAgICAgICAgIk1T
QSBWT0xVTUUgICAgICAiCisjICAgICAgICAgICAgICAgcGF0aF9ncm91cGluZ19wb2xpY3kgICAg
Z3JvdXBfYnlfc2VyaWFsCisjICAgICAgICAgICAgICAgcGF0aF9jaGVja2VyICAgICAgICAgICAg
dHVyCisjICAgICAgIH0KKyMJZGV2aWNlIHsKKyMgICAgICAgICAgICAgICAgdmVuZG9yICAgICAg
ICAgICAgICAgICAiSFAgICAgICAiCisjICAgICAgICAgICAgICAgIHByb2R1Y3QgICAgICAgICAg
ICAgICAgIk9QRU4tLiAgICAgICAgICAiCisjICAgICAgICAgICAgICAgIHBhdGhfZ3JvdXBpbmdf
cG9saWN5ICAJbXVsdGlidXMKKyMgICAgICAgICAgICAgICAgcGF0aF9jaGVja2VyICAgICAgICAg
ICB0dXIKKyMgICAgICAgIH0KKyMJZGV2aWNlIHsKKyMgICAgICAgICAgICAgICAgdmVuZG9yICAg
ICAgICAgICAgICAgICAiSFAgICAgICAiCisjICAgICAgICAgICAgICAgIHByb2R1Y3QgICAgICAg
ICAgICAgICAgIiozM1s4OV0wKiAgICAgICAiCisjICAgICAgICAgICAgICAgIHBhdGhfZ3JvdXBp
bmdfcG9saWN5ICAJbXVsdGlidXMKKyMgICAgICAgICAgICAgICAgcGF0aF9jaGVja2VyICAgICAg
ICAgICB0dXIKKyMgICAgICAgIH0KKyMJZGV2aWNlIHsKICMJCXZlbmRvcgkJCSIzUEFSZGF0YSIK
ICMJCXByb2R1Y3QJCQkiVlYgICAgICAgICAgICAgICIKICMJCXBhdGhfZ3JvdXBpbmdfcG9saWN5
CW11bHRpYnVzCg==

------_=_NextPart_001_01C5EEA5.9A86050B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C5EEA5.9A86050B--
