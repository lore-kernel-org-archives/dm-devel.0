From: Remington Brasga <Remington.Brasga@taec.toshiba.com>
Subject: How to properly benchmark dm-cache
Date: Thu, 31 Aug 2017 21:29:20 +0000
Message-ID: <A4C6B4012E4D254597FE91E8CF2C135D01063C9714@EXMAIL1.taec.toshiba.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6313199412609734751=="
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

--===============6313199412609734751==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_A4C6B4012E4D254597FE91E8CF2C135D01063C9714EXMAIL1taecto_"

--_000_A4C6B4012E4D254597FE91E8CF2C135D01063C9714EXMAIL1taecto_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, I'm trying to benchmark dm-cache, but I'm having trouble getting the be=
nchmark to show positive results. I've tried TPC-B, TPC-C, TPC-H, SQL, and =
a handful of other, but I think because they are simulations they don't gen=
erate the 'hot spots' required to promote blocks to the cache.

I know it's easy to show results using FIO with a specific configuration, b=
ut I was hoping to use a real benchmark like the ones I've tried.

Does anyone have a good set of benchmarks that shows positive results?

Thanks,
-Remi

--_000_A4C6B4012E4D254597FE91E8CF2C135D01063C9714EXMAIL1taecto_
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
	{font-family:"MS Mincho";
	panose-1:2 2 6 9 4 2 5 8 3 4;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@MS Mincho";
	panose-1:2 2 6 9 4 2 5 8 3 4;}
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
<p class=3D"MsoNormal">Hi, I&#8217;m trying to benchmark dm-cache, but I&#8=
217;m having trouble getting the benchmark to show positive results. I&#821=
7;ve tried TPC-B, TPC-C, TPC-H, SQL, and a handful of other, but I think be=
cause they are simulations they don&#8217;t generate the &#8216;hot
 spots&#8217; required to promote blocks to the cache.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I know it&#8217;s easy to show results using FIO wit=
h a specific configuration, but I was hoping to use a real benchmark like t=
he ones I&#8217;ve tried.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Does anyone have a good set of benchmarks that shows=
 positive results?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">-Remi <o:p></o:p></p>
</div>
</body>
</html>

--_000_A4C6B4012E4D254597FE91E8CF2C135D01063C9714EXMAIL1taecto_--


--===============6313199412609734751==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6313199412609734751==--
