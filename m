From: <Menny_Hamburger@Dell.com>
Subject: [Patch 2 of 2]: scsi-dh + dm-mpath: propagate SCSI
 device deletion to multipath
Date: Wed, 15 Dec 2010 08:31:24 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AFC9450@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_"
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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

--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The problem:
When a SCSI device attached to a device handler is deleted, userland proces=
ses currently performing I/O on the device will I/O hang forever.

Attached is the multipath layer part of the patch.

Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DWordSection1>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>The
problem:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>When
a SCSI device attached to a device handler is deleted, userland processes c=
urrently
performing I/O on the device will I/O hang forever.<o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Attached is the multipath layer part of the patch.<o:p=
></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'>Menny Hamburger</span></b><span style=3D'font-size:8.0pt;
font-family:"Trebuchet MS","sans-serif";color:#444444'><o:p></o:p></span></=
p>

<p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet =
MS","sans-serif";
color:#444444'>Engineer<o:p></o:p></span></p>

<p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuch=
et MS","sans-serif";
color:#0085C3'>Dell</span></b><span style=3D'font-size:8.0pt;font-family:"T=
rebuchet MS","sans-serif";
color:#444444'> | IDC<b><o:p></o:p></b></span></p>

<p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuch=
et MS","sans-serif";
color:#444444'>office </span></b><span style=3D'font-size:8.0pt;font-family=
:"Trebuchet MS","sans-serif";
color:#444444'>+972 97698789<b>,&nbsp; fax </b>+972 97698889<b><o:p></o:p><=
/b></span></p>

<p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet =
MS","sans-serif";
color:#444444'>Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel</span><spa=
n
style=3D'color:#1F497D'><o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_--

--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_
Content-Type: application/octet-stream; name="md-handle-device-deletion.patch"
Content-Description: md-handle-device-deletion.patch
Content-Disposition: attachment; filename="md-handle-device-deletion.patch";
	size=687; creation-date="Wed, 15 Dec 2010 08:30:02 GMT";
	modification-date="Wed, 15 Dec 2010 08:08:13 GMT"
Content-Transfer-Encoding: base64

RnJvbTogTWVubnkgSGFtYnVyZ2VyIDxNZW5ueV9IYW1idXJnZXJARGVsbC5jb20+ClN1YmplY3Q6
IFttZF0gZG0tbXVsdGlwYXRoOiBIYW5kbGUgaGFyZHdhcmUgaGFuZGxlciBkZWxldGlvbiBpbiBw
Z19pbml0X2RvbmUKQnVnemlsbGE6IDY0NTM0MwoKV2hlbiB0aGUgU0NTSSBkZXZpY2UgSC9XIGhh
bmRsZXIgaXMgZGVsZXRlZCBvciBvZmZsaW5lZCwgcGdfaW5pdF9kb25lIHNob3VsZCBmYWlsIHRo
ZSBwYXRoLgpGYWlsaW5nIGFsbCB0aGUgcGF0aHMgYXNzb2NpYXRlZCB3aXRoIHRoZSBIL1cgaGFu
ZGxlciB3aWxsIGV2ZW50dWFsbHkgdGVybWluYXRlIGFsbCBJL08gcmVxdWVzdHMgcXVldWVkIG9u
IHRoZSBtdWx0aXBhdGggZGV2aWNlCgoKZGlmZiAtciAtVSAyIGEvZHJpdmVycy9tZC9kbS1tcGF0
aC5jIGIvZHJpdmVycy9tZC9kbS1tcGF0aC5jCi0tLSBhL2RyaXZlcnMvbWQvZG0tbXBhdGguYwky
MDEwLTEyLTE1IDEwOjA4OjEzLjI0Mzk5MTAwMCArMDIwMAorKysgYi9kcml2ZXJzL21kL2RtLW1w
YXRoLmMJMjAxMC0xMi0xNSAxMDowODoxMy4zMjk3MzYwMDAgKzAyMDAKQEAgLTExOTAsNCArMTE5
MCw1IEBACiAJY2FzZSBTQ1NJX0RIX09LOgogCQlicmVhazsKKwljYXNlIFNDU0lfREhfREVWX09G
RkxJTkVEOgogCWNhc2UgU0NTSV9ESF9OT1NZUzoKIAkJaWYgKCFtLT5od19oYW5kbGVyX25hbWUp
IHsK

--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9450DUBX7MCDUB01E_--
