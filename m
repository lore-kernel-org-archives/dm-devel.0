From: "Nalla, Ravikanth" <ravikanth.nalla@hp.com>
Subject: Regarding RHEL multipath-tools-0.5.0
Date: Wed, 20 May 2015 16:08:53 +0000
Message-ID: <49D617FA63152941907AADE32CF072F127856374@G9W0747.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3852635051092186020=="
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
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3852635051092186020==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_49D617FA63152941907AADE32CF072F127856374G9W0747americas_"

--_000_49D617FA63152941907AADE32CF072F127856374G9W0747americas_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi Christophe,

I'm a registered user of RHEL dm-devel (ravikanth.nalla@yahoo.com<mailto:ra=
vikanth.nalla@yahoo.com>) and I'm reaching to you as I have found your id t=
agged to multipath-tools-0.5.0.
When I'm compiling "multipath-tools-0.5.0" I get udev dependency error ( li=
budev.h  not found). To resolve it, I  have downloaded SRPM
of udev-147-2.57.el6.src.rpm from http://ftp.redhat.com/redhat/linux/enterp=
rise/6Server/en/os/SRPMS/ and trying to "./configure" but
no luck as I get another dependency error as below,

"checking for INTROSPECTION... configure: error: Package requirements (gobj=
ect-introspection-1.0 >=3D 0.6.2) were not met:"

However I tried to find the SRPM for gobject-introspection-1.0  but could n=
ot find it on http://ftp.redhat.com/redhat/linux/enterprise/6Server/en/os/S=
RPMS/
I like to know what are the prerequisites to make multipath-tools-0.5.0 to =
compile on RHEL6update5 and if we have to have the additional RPMS then
where can I get it.
Thanks in advance,
Ravi

--_000_49D617FA63152941907AADE32CF072F127856374G9W0747americas_
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
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
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
/* List Definitions */
@list l0
	{mso-list-id:1650330682;
	mso-list-template-ids:-1793803846;}
@list l0:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:"Courier New";
	mso-bidi-font-family:"Times New Roman";}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:1.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:2.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:2.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:3.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:3.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:4.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:4.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:black"><o:p>&nbsp;</o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">Hi Christophe,<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black"><o:p>&nbsp;</o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">I&#8217;m a registered u=
ser of RHEL dm-devel (<a href=3D"mailto:ravikanth.nalla@yahoo.com">ravikant=
h.nalla@yahoo.com</a>) and I&#8217;m reaching to you as I have found your i=
d tagged to multipath-tools-0.5.0.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">When I&#8217;m compiling=
 &#8220;multipath-tools-0.5.0&#8221; I get udev dependency error (
</span>libudev.h &nbsp;not found). To resolve it, I &nbsp;have downloaded S=
RPM <o:p></o:p></p>
<p class=3D"MsoNormal">of udev-147-2.57.el6.src.rpm from <a href=3D"http://=
ftp.redhat.com/redhat/linux/enterprise/6Server/en/os/SRPMS/">
http://ftp.redhat.com/redhat/linux/enterprise/6Server/en/os/SRPMS/</a> and =
trying to &#8220;./configure&#8221; but &nbsp;<o:p></o:p></p>
<p class=3D"MsoNormal">no luck as I get another dependency error as below,<=
o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&#8220;<span style=3D"color:black">checking for INTR=
OSPECTION... configure: error: Package requirements (gobject-introspection-=
1.0 &gt;=3D 0.6.2) were not met:&#8221;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black"><o:p>&nbsp;</o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">However I tried to find =
the SRPM for gobject-introspection-1.0 &nbsp;but could not find it on
</span><a href=3D"http://ftp.redhat.com/redhat/linux/enterprise/6Server/en/=
os/SRPMS/">http://ftp.redhat.com/redhat/linux/enterprise/6Server/en/os/SRPM=
S/</a><o:p></o:p></p>
<p class=3D"MsoNormal">I like to know what are the prerequisites to make <s=
pan style=3D"color:black">
multipath-tools-0.5.0 to compile on RHEL6update5 and if we have to have the=
 additional RPMS then
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">where can I get it.<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black"></span><o:p></o:p></p>
<p class=3D"MsoNormal">Thanks in advance,<o:p></o:p></p>
<p class=3D"MsoNormal">Ravi<o:p></o:p></p>
</div>
</body>
</html>

--_000_49D617FA63152941907AADE32CF072F127856374G9W0747americas_--


--===============3852635051092186020==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3852635051092186020==--
