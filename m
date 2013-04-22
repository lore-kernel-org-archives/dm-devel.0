From: "Mears, Morgan" <Morgan.Mears@netapp.com>
Subject: [BUG REPORT] ENOTBLK on create cache if metadata device
 not zeroed (3.9.0-rc7)
Date: Mon, 22 Apr 2013 16:47:16 +0000
Message-ID: <33A0129EBFD46748804DE81B354CA1B2DB1BCB@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7540648010033956586=="
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

--===============7540648010033956586==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_33A0129EBFD46748804DE81B354CA1B2DB1BCBSACEXCMBX06PRDhqn_"

--_000_33A0129EBFD46748804DE81B354CA1B2DB1BCBSACEXCMBX06PRDhqn_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I was setting up for some dm-cache testing this weekend (using 3.9.0-rc7 x8=
6_64) and ran into the following:

# dmsetup create cache --table '0 41943040 cache /dev/mapper/metadata /dev/=
mapper/ssd /dev/mapper/origin 512 1 writeback default 0'
device-mapper: reload ioctl on cache failed: Block device required
Command failed
#

After this error, /var/log/messages contains:

[75376.089354] device-mapper: cache metadata: sb_check failed: blocknr 1844=
6744073709551615: wanted 0
[75376.089362] device-mapper: block manager: superblock validator check fai=
led for block 0
[75376.089364] device-mapper: cache metadata: couldn't read lock superblock
[75376.095173] device-mapper: table: 253:5: cache: Error creating metadata =
object
[75376.095180] device-mapper: ioctl: error adding target to table

This comes from sb_check() in drivers/md/dm-cache-metadata.c and drivers/md=
/dm-thin-metadata.c, and it motivated me to try:

# dd if=3D/dev/zero of=3D/dev/mapper/metadata bs=3D4k conv=3Dnotrunc

Afterwards, I tried "dmsetup create cache" again and it worked fine.

Regards,
Morgan Mears


--_000_33A0129EBFD46748804DE81B354CA1B2DB1BCBSACEXCMBX06PRDhqn_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:m=3D"http://schema=
s.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html=
40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Hi,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
I was setting up for some dm-cache testing this weekend (using 3.9.0-rc7 x8=
6_64) and ran into the following:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
# dmsetup create cache --table '0 41943040 cache /dev/mapper/metadata /dev/=
mapper/ssd /dev/mapper/origin 512 1 writeback default 0'<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
device-mapper: reload ioctl on cache failed: Block device required<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Command failed<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
#<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
After this error, /var/log/messages contains:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
[75376.089354] device-mapper: cache metadata: sb_check failed: blocknr 1844=
6744073709551615: wanted 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
[75376.089362] device-mapper: block manager: superblock validator check fai=
led for block 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
[75376.089364] device-mapper: cache metadata: couldn't read lock superblock=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
[75376.095173] device-mapper: table: 253:5: cache: Error creating metadata =
object<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
[75376.095180] device-mapper: ioctl: error adding target to table<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
This comes from sb_check() in drivers/md/dm-cache-metadata.c and drivers/md=
/dm-thin-metadata.c, and it motivated me to try:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
# dd if=3D/dev/zero of=3D/dev/mapper/metadata bs=3D4k conv=3Dnotrunc<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Afterwards, I tried &#8220;dmsetup create cache&#8221; again and it worked =
fine.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Regards,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Morgan Mears<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_33A0129EBFD46748804DE81B354CA1B2DB1BCBSACEXCMBX06PRDhqn_--


--===============7540648010033956586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7540648010033956586==--
