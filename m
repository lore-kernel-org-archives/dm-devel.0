From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: error while loading multipathd
Date: Mon, 2 Jan 2017 07:14:59 +0000
Message-ID: <39bd29aea5ed4648b01c101c2206b93a@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2957564646315914881=="
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

--===============2957564646315914881==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_39bd29aea5ed4648b01c101c2206b93aBRMWPEXMB12corpbrocadec_"

--_000_39bd29aea5ed4648b01c101c2206b93aBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi All,
 Iam using CentOS Linux release 7.2.1511 .
I downloaded the latest sourcecode from git clone http://git.opensvc.com/multipath-tools/.git.
And I linked my binaries to the newly built libmultipath, using ldd, and not to a package-installed one using the below command from the build dir.

export LD_LIBRARY_PATH=libmultipath/:libmpathpersist/:libmpathcmd/:multipath/multipath-h

With this when I run the multipath utility and the output is fine as expected

But when I run the multipathd iam getting the below error.
./multipathd/multipathd: error while loading shared libraries: liburcu.so.4: cannot open shared object file: No such file or directory

Can anyone help me regarding this so that i can start working on my private build instead of default..



Regards,
Muneendra.


--_000_39bd29aea5ed4648b01c101c2206b93aBRMWPEXMB12corpbrocadec_
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Hi All,<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D">&nbsp;Iam using CentOS Linux release 7.2.1511 .<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D">I downloaded the latest sourcecode from&nbsp;git clone&nbsp;<a href=3D=
"http://git.opensvc.com/multipath-tools/.git" target=3D"_blank"><span style=
=3D"color:#1F497D;text-decoration:none">http://git.opensvc.com/multipath-to=
ols/.git</span></a>.
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D">And I linked my binaries to the newly built libmultipath, using ldd, a=
nd not to a package-installed one using the below command from the build di=
r.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D">export LD_LIBRARY_PATH=3Dlibmultipath/:libmpathpersist/:libmpathcmd/:m=
ultipath/multipath-h<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D">With this when I run the multipath utility and the output is fine as e=
xpected<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1F4=
97D">But when I run the multipathd iam getting the below error.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">./multipathd/multipath=
d: error while loading shared libraries: liburcu.so.4: cannot open shared o=
bject file: No such file or directory<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Can anyone help me reg=
arding this so that i can start working on my private build instead of defa=
ult..<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Regards,<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Muneendra.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_39bd29aea5ed4648b01c101c2206b93aBRMWPEXMB12corpbrocadec_--


--===============2957564646315914881==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2957564646315914881==--
