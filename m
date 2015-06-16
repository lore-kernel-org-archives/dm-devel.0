From: Artem Danielov <artem@flashgrid.io>
Subject: multipathd removing DM devices that don't belong to it
Date: Tue, 16 Jun 2015 22:02:23 +0000
Message-ID: <DM2PR11MB0335E7DB799EB58FD218AC62D5A70@DM2PR11MB0335.namprd11.prod.outlook.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4091664881079673824=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4091664881079673824==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM2PR11MB0335E7DB799EB58FD218AC62D5A70DM2PR11MB0335namp_"

--_000_DM2PR11MB0335E7DB799EB58FD218AC62D5A70DM2PR11MB0335namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,
Looking for an advice on whether this is an expected behavior or a bug.
device-mapper-multipath-0.4.9-77.el7.x86_64

When multipathd service starts it will remove any DM devices with multipath=
 target, even if the underlying devices are blacklisted.
We are trying to use dmsetup directly  to implement custom multipath manage=
ment logic separate from multipathd. But unfortunately if multipathd is pre=
sent and enabled it removes DM devices with multipath target that we create=
.

Is this a bug?

Thanks for your help!

Artem Danielov | Chief Technology Officer | FlashGrid Inc. | artem@flashgri=
d.io<mailto:artem@flashgrid.io> | +1-503-568-5249


--_000_DM2PR11MB0335E7DB799EB58FD218AC62D5A70DM2PR11MB0335namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hello,<o:p></o:p></p>
<p class=3D"MsoNormal">Looking for an advice on whether this is an expected=
 behavior or a bug.<o:p></o:p></p>
<p class=3D"MsoNormal">device-mapper-multipath-0.4.9-77.el7.x86_64<o:p></o:=
p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">When multipathd service starts it will remove any DM=
 devices with multipath target,
<u>even if the underlying devices are blacklisted</u>.<o:p></o:p></p>
<p class=3D"MsoNormal">We are trying to use dmsetup directly &nbsp;to imple=
ment custom multipath management logic separate from multipathd. But unfort=
unately if multipathd is present and enabled it removes DM devices with mul=
tipath target that we create.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is this a bug?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks for your help!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Artem Danielov | Chief Technology Officer | FlashGri=
d Inc. |
<a href=3D"mailto:artem@flashgrid.io">artem@flashgrid.io</a> | &#43;1-503-5=
68-5249<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_DM2PR11MB0335E7DB799EB58FD218AC62D5A70DM2PR11MB0335namp_--


--===============4091664881079673824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4091664881079673824==--
