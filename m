From: "Vaknin, Rami" <Rami.Vaknin@emc.com>
Subject: rr_min_io vs rr_min_io_rq on 6.5
Date: Tue, 21 Oct 2014 08:03:09 +0000
Message-ID: <CBD76F19A3EEF14686BFFB30222C123C1FFB1182@MX106CL02.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8539588601807754762=="
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

--===============8539588601807754762==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CBD76F19A3EEF14686BFFB30222C123C1FFB1182MX106CL02corpem_"

--_000_CBD76F19A3EEF14686BFFB30222C123C1FFB1182MX106CL02corpem_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm working on 6.5 running with 2.6.32-431.el6.x86_64, my multipath.conf if=
 configured with both rr_min_io and rr_min_io_rq, running 64k 100% write lo=
ad to my storage system using 8 paths over FC ("queue-length" policy).

I found [1] that rr_min_io is deprecated in favor of rr_min_io_rq, but play=
ing with these values show that different rr_min_io_rq have no influence on=
 performance in my env, however, different values of rr_min_io have huge in=
fluence on the average latency I get for the same iops.

Am I missing something?


[1] https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/=
6/html/DM_Multipath/MPIO_Overview.html

device-mapper-libs-1.02.79-8.el6.x86_64
device-mapper-event-libs-1.02.79-8.el6.x86_64
device-mapper-persistent-data-0.2.8-2.el6.x86_64
device-mapper-1.02.79-8.el6.x86_64
device-mapper-event-1.02.79-8.el6.x86_64
device-mapper-multipath-libs-0.4.9-72.el6_5.3.x86_64
device-mapper-multipath-0.4.9-72.el6_5.3.x86_64


--_000_CBD76F19A3EEF14686BFFB30222C123C1FFB1182MX106CL02corpem_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
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
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
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
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I&#8217;m working on 6.5 running with 2.6.32-431.el6=
.x86_64, my multipath.conf if configured with both rr_min_io and rr_min_io_=
rq, running 64k 100% write load to my storage system using 8 paths over FC =
(&#8220;queue-length&#8221; policy).<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I found [1] that rr_min_io is deprecated in favor of=
 rr_min_io_rq, but playing with these values show that different rr_min_io_=
rq have no influence on performance in my env, however, different values of=
 rr_min_io have huge influence on
 the average latency I get for the same iops.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Am I missing something?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">[1] <a href=3D"https://access.redhat.com/documentati=
on/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/MPIO_Overview.html">
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/ht=
ml/DM_Multipath/MPIO_Overview.html</a><o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">device-mapper-libs-1.02.79-8.el6.x86_64<o:p></o:p></=
p>
<p class=3D"MsoNormal">device-mapper-event-libs-1.02.79-8.el6.x86_64<o:p></=
o:p></p>
<p class=3D"MsoNormal">device-mapper-persistent-data-0.2.8-2.el6.x86_64<o:p=
></o:p></p>
<p class=3D"MsoNormal">device-mapper-1.02.79-8.el6.x86_64<o:p></o:p></p>
<p class=3D"MsoNormal">device-mapper-event-1.02.79-8.el6.x86_64<o:p></o:p><=
/p>
<p class=3D"MsoNormal">device-mapper-multipath-libs-0.4.9-72.el6_5.3.x86_64=
<o:p></o:p></p>
<p class=3D"MsoNormal">device-mapper-multipath-0.4.9-72.el6_5.3.x86_64<o:p>=
</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_CBD76F19A3EEF14686BFFB30222C123C1FFB1182MX106CL02corpem_--


--===============8539588601807754762==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8539588601807754762==--
