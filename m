From: Xieyingtai <xieyingtai@huawei.com>
Subject: How to filter local disks that should not be managed by
 multipathd?
Date: Mon, 18 Jul 2016 11:59:42 +0000
Message-ID: <AF7C226D2A4F8B4D913D33FF7150AE0531BECD94@szxeml556-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1264163793585001487=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============1264163793585001487==
Content-Language: zh-CN
Content-Type: multipart/related;
	boundary="_004_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_";
	type="multipart/alternative"

--_004_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_
Content-Type: multipart/alternative;
	boundary="_000_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_"

--_000_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi,
   Recently I encountered a problem, In certain scenarios that a new local =
disk was hot plugged, I have no way
to obtain the wwn of the disk in advance, so I can not filter that disk by =
adding it to blacklists. Actually there
is no need for multipathd to  take over local disks in the hot-plugged scen=
o. And find_multipaths param seems not to be
a perfect way to solve this problem. Is there any way to  provide a param i=
n /etc/multipath.conf for mulitpathd to manage
only ISCSI or FC bus disks? In that configuration, path_discovery() will on=
ly scan devices which were underline ISCSI bus
or FC bus in sysfs.

Thanks.

--_000_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:m=3D"http://sc=
hemas.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-=
html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Microsoft Theme 2.00" content=3D"Radial 011">
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif";
	color:black;}
h1
	{mso-style-priority:9;
	mso-style-link:"\6807\9898 1 Char";
	margin-top:17.0pt;
	margin-right:0cm;
	margin-bottom:16.5pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:240%;
	page-break-after:avoid;
	font-size:16.0pt;
	font-family:"Calibri","sans-serif";
	color:black;}
h2
	{mso-style-priority:9;
	mso-style-link:"\6807\9898 2 Char";
	margin-top:13.0pt;
	margin-right:0cm;
	margin-bottom:13.0pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:173%;
	page-break-after:avoid;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	font-weight:normal;}
h3
	{mso-style-priority:9;
	mso-style-link:"\6807\9898 3 Char";
	margin-top:13.0pt;
	margin-right:0cm;
	margin-bottom:13.0pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:173%;
	page-break-after:avoid;
	font-size:13.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	font-weight:normal;}
h4
	{mso-style-priority:9;
	mso-style-link:"\6807\9898 4 Char";
	margin-top:14.0pt;
	margin-right:0cm;
	margin-bottom:14.5pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:156%;
	page-break-after:avoid;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	font-weight:normal;}
h5
	{mso-style-priority:9;
	mso-style-link:"\6807\9898 5 Char";
	margin-top:14.0pt;
	margin-right:0cm;
	margin-bottom:14.5pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:156%;
	page-break-after:avoid;
	font-size:13.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	font-weight:normal;}
h6
	{mso-style-priority:9;
	mso-style-link:"\6807\9898 6 Char";
	margin-top:12.0pt;
	margin-right:0cm;
	margin-bottom:3.2pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:133%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	font-weight:normal;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#6666FF;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#993333;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	color:black;}
span.1Char
	{mso-style-name:"\6807\9898 1 Char";
	mso-style-priority:9;
	mso-style-link:"\6807\9898 1";
	font-family:SimSun;
	color:black;
	font-weight:bold;}
span.2Char
	{mso-style-name:"\6807\9898 2 Char";
	mso-style-priority:9;
	mso-style-link:"\6807\9898 2";
	font-family:SimSun;
	color:black;}
span.3Char
	{mso-style-name:"\6807\9898 3 Char";
	mso-style-priority:9;
	mso-style-link:"\6807\9898 3";
	font-family:SimSun;
	color:black;}
span.4Char
	{mso-style-name:"\6807\9898 4 Char";
	mso-style-priority:9;
	mso-style-link:"\6807\9898 4";
	font-family:SimSun;
	color:black;}
span.5Char
	{mso-style-name:"\6807\9898 5 Char";
	mso-style-priority:9;
	mso-style-link:"\6807\9898 5";
	font-family:SimSun;
	color:black;}
span.6Char
	{mso-style-name:"\6807\9898 6 Char";
	mso-style-priority:9;
	mso-style-link:"\6807\9898 6";
	font-family:SimSun;
	color:black;}
.MsoChpDefault
	{mso-style-type:export-only;}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body bgcolor=3D"white" background=3D"cid:image001.gif@01D1E12A.80191AE0" l=
ang=3D"ZH-CN" link=3D"#6666FF" vlink=3D"#993333" style=3D"text-justify-trim=
:punctuation">
<img src=3D"cid:image001.gif@01D1E12A.80191AE0" v:src=3D"cid:image001.gif@0=
1D1E12A.80191AE0" v:shapes=3D"_x0000_Mail" width=3D"0" height=3D"0" class=
=3D"shape" style=3D"display:none;width:0;height:0"><!--[if gte mso 9]><xml>
<v:background id=3D"_x0000_s1025" o:bwmode=3D"white" o:targetscreensize=3D"=
800,600">
<v:fill src=3D"cid:image001.gif@01D1E12A.80191AE0" o:title=3D"radbkgnd" typ=
e=3D"frame" />
</v:background></xml><![endif]-->
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">Hi,<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp; Recently I encountered a problem, In certain scenarios that a new =
local disk was hot plugged, I have no way<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">to o=
btain the wwn of the disk in advance, so I can not filter that disk by addi=
ng it to blacklists. Actually there<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">is n=
o need for multipathd to &nbsp;take over local disks in the hot-plugged sce=
no. And find_multipaths param seems not to be
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">a pe=
rfect way to solve this problem. Is there any way to &nbsp;provide a param =
in /etc/multipath.conf for mulitpathd to manage<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">only=
 ISCSI or FC bus disks? In that configuration, path_discovery() will only s=
can devices which were underline ISCSI bus<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">or F=
C bus in sysfs.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">Than=
ks.<o:p></o:p></span></p>
</div>
</body>
</html>

--_000_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_--

--_004_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_
Content-Type: image/gif; name="image001.gif"
Content-Description: image001.gif
Content-Disposition: inline; filename="image001.gif"; size=1065;
	creation-date="Mon, 18 Jul 2016 11:59:42 GMT";
	modification-date="Mon, 18 Jul 2016 11:59:42 GMT"
Content-ID: <image001.gif@01D1E12A.80191AE0>
Content-Transfer-Encoding: base64

R0lGODlhkAEsAYD/AP///8zM/ywAAAAAkAEsAUAC/4SPqcvtD6OctNqLs968+w+G4kiW5omm6sq2
7gvH8kzX9o3n+s73/g8MCofEovGITCqXzKbzCY1Kp9Sq9YrNarfcrvcLDovH5PIjYE5r0eq2+91g
h+Xwuptuz+v3/L7/DxgoOEhYaHiImKi4WIjH+Ag54RhJWZkwaZkJianZ6fkJGio66sVJegpnirrK
2uqi6voF6zlLWkt1m5kbm7XL++j7KzxMXAwQbJzMg6zcTMPsHP2BRi1tfY2drb3N3e39DR4uPk5e
bn5uBI2+zt7u/g5vXs2oHl9Vb5/vgK/f38TvA6A/ENSqGTyG8KDChAwXzhsIMaLEie8EUryIkZzF
jP/dNnLU5vGjyJEkS4YKaTKlSk0oMzpsCPOlzJg0Z9qsifOmzpw8A+z82TMo0JmtWq5EYPRP0kFL
fzQ9KuMp1KlUq1rtIfWq1q1IsnL9Cjas2LFky5o9izat2rVs27p9Czeu3Ll069p1ifCuM696+/r9
Cziw4MGE6/A9urDTYbWLnzSW+7jwm8g4KBO23AKzZKSbUWnm8LmzaMSjS5s+jTq16tVsQ7N+DTs2
Edeyl9CuneQ27iO6dxfp7XsI8OBAhhM/jjy58uXMmysx7jy6dNXQp8Oobp04djHbQbvqzg48LmPi
vRclVr5D+ijry7XPDv/E+/jT6NunOP++hvz6L/D/71/BfwBKIOCAZxi4RYEIMrRgg1Io6OCBEZYy
IYUVcgHhhQpkqCFnHfbyIYghXsFhiCV+eGKHKWq44oUtVvjihDFGOKODNTZ444I5IrijgT0O+COA
QfY3pH5F3nfkSEMJxeSSQ/nUZJROSknllFZWieVOd1io0o0vJgnIl1xadaKYXHFo5lcQpglWgWyG
9d+bcLI35lj5ySnWfHjm6cSefDLh55yA1ukjodRlGZNPVy6KqE5QMgppozS5AyYiD4HEWF57QUae
XZUu8NSnq4ga6mCionDqL6mKsGp0rTr36lx8xQrXYrQud2s0uW7oG3iY7WoNdKEBe41utxGLDWWX
/wY0IonNtYosN6lGK60e1HZkx7XYphJfktp+c+S34LYh7rhplAsbuq+pyxq75nJXKLzxguHuoc3e
cy+++U5Rb2r9ovbvaQGbNnBpBY92sGgJd7bwZg1L9nBhEW+T4sSYruFighljDKPGHXMso8chg7wv
FBYLdnJgKQO2sq5dtLwphiU/ODOdNTt2M845/4MjvTrOsTPPQds2r89CkgFzX0nrtfRdTXs6NNHd
bumZpJFebXXWCimqdddYJ2bA03WJTRfZskb9HNq5Mfeq2cCEqXZXcfMWHLFux3V3rXOns/dvfc/2
t3AOn3SZLSyzkrfI352N3lrLdspn4gx87XXllAhfbjmigcNVAAA7

--_004_AF7C226D2A4F8B4D913D33FF7150AE0531BECD94szxeml556mbschi_--


--===============1264163793585001487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1264163793585001487==--
