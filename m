From: "Akash Bhatnagar" <akash.bhatnagar@broadcom.com>
Subject: Unknown crypt device type VERITY over Ubuntu 12.04
Date: Tue, 26 Nov 2013 12:22:38 +0000
Message-ID: <E9CDC8D7E4A711429544A9E2B5E944734B062D@SJEXCHMB15.corp.ad.broadcom.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1336231900761886476=="
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


--===============1336231900761886476==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary=_000_E9CDC8D7E4A711429544A9E2B5E944734B062DSJEXCHMB15corpadb_


--_000_E9CDC8D7E4A711429544A9E2B5E944734B062DSJEXCHMB15corpadb_
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

HI,

I have build cryptsetup over Ubuntu 12.04 using standard way with almost al=
l the dependent packages compiled manually. Below is the list of all the pa=
ckages which generated dependency errors:-

1) util-linux-ng-2.18.tar.bz2 -->{./configure && make && make install}
2) libgpg-error-1.9.tar.gz --> {./configure && make && make install}
3) libgcrypt-1.5.3.tar.gz --> {./configure && make && make install}
4) LVM2.2.02.99.tgz --> {./configure && make && make install}
5) cryptsetup-1.6.2.tar.bz2 --> {./configure && make && make install}

After that I have changed the running kernel 3.8.x with the debian packages=
 of Linux kernel 3.11.x which already have dm-verity.ko module.

6) Then I have insert dm-verity module (modprobe dm-verity)

In order to test verity framework, I have created two sample block devices;=
one for data device and other for hash device:-

7) losetup system.img.raw /dev/loop2
   echo "0 $(blockdev --getsize /dev/loop2) linear /dev/loop2 0" |\
   dmsetup  create my_dm

8) dd if=3D/dev/zero of=3D/tmp/store1 bs=3D1024 seek=3D2047 count=3D1
   losetup /tmp/store1 /dev/loop0
   echo "0 $(blockdev --getsize /dev/loop0) linear /dev/loop0 0" |\
   dmsetup  create my_hash_dm

And finally during test; the veritysetup shows following error instead of R=
oot Hash

veritysetup format /dev/mapper/my_dm /dev/mapper/my_hash_dm

Unknown crypt device type VERITY requested.

I am unable to locate the issue and tried alot. Please indicate if any of t=
he step is incorrect and should not be done. Also specify any alternatives.

Thanks
Akash


--_000_E9CDC8D7E4A711429544A9E2B5E944734B062DSJEXCHMB15corpadb_
Content-Type: text/html;
 charset=us-ascii
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
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
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">HI,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">I have build cryptsetup over Ubuntu 12.04 using standard w=
ay with almost all the dependent packages compiled manually. Below is the l=
ist of all the packages which generated dependency
 errors:-<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">1) util-linux-ng-2.18.tar.bz2 --&gt;{./configure &amp;&amp=
; make &amp;&amp; make install}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">2) libgpg-error-1.9.tar.gz --&gt; {./configure &amp;&amp; =
make &amp;&amp; make install}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">3) libgcrypt-1.5.3.tar.gz --&gt; {./configure &amp;&amp; m=
ake &amp;&amp; make install}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">4) LVM2.2.02.99.tgz --&gt; {./configure &amp;&amp; make &a=
mp;&amp; make install}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">5) cryptsetup-1.6.2.tar.bz2 --&gt; {./configure &amp;&amp;=
 make &amp;&amp; make install}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">After that I have changed the running kernel 3.8.x with th=
e debian packages of Linux kernel 3.11.x which already have dm-verity.ko mo=
dule.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">6) Then I have insert dm-verity module (modprobe dm-verity=
)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">In order to test verity framework, I have created two samp=
le block devices;one for data device and other for hash device:-<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">7) losetup system.img.raw /dev/loop2<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">&nbsp;&nbsp; echo &quot;0 $(blockdev --getsize /dev/loop2)=
 linear /dev/loop2 0&quot; |\
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">&nbsp;&nbsp;&nbsp;dmsetup&nbsp; create my_dm<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">8) dd if=3D/dev/zero of=3D/tmp/store1 bs=3D1024 seek=3D204=
7 count=3D1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">&nbsp;&nbsp; losetup /tmp/store1 /dev/loop0<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">&nbsp;&nbsp; echo &quot;0 $(blockdev --getsize /dev/loop0)=
 linear /dev/loop0 0&quot; |\
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">&nbsp;&nbsp;&nbsp;dmsetup&nbsp; create my_hash_dm<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">And finally during test; the veritysetup shows following e=
rror instead of Root Hash<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">veritysetup format /dev/mapper/my_dm /dev/mapper/my_hash_d=
m
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">Unknown crypt device type VERITY requested.<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">I am unable to locate the issue and tried alot. Please ind=
icate if any of the step is incorrect and should not be done. Also specify =
any alternatives.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">Thanks<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;">Akash<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_E9CDC8D7E4A711429544A9E2B5E944734B062DSJEXCHMB15corpadb_--


--===============1336231900761886476==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1336231900761886476==--
