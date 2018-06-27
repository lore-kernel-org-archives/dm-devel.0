From: Jiaojianbing <jiaojianbing@huawei.com>
Subject: why command of multipath send reinstate message to all
	dm's paths
Date: Wed, 27 Jun 2018 07:58:12 +0000
Message-ID: <F0921BF66894AB498DE908B06C95871AB06F952B@nkgeml513-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3851843473628384410=="
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "Yangjie (S)" <yangjieyj.yang@huawei.com>, "Zhangyanfei (UVP)" <yanfei.zhang@huawei.com>
List-Id: dm-devel.ids

--===============3851843473628384410==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_F0921BF66894AB498DE908B06C95871AB06F952Bnkgeml513mbxchi_"

--_000_F0921BF66894AB498DE908B06C95871AB06F952Bnkgeml513mbxchi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Dear Christophe,
when dm-105 is in one state of below, paths of dm-105 will change to active=
 if we run command of multipath. I check code of multipath, it sends messge=
 "reinstate_path pathname" to kernel in routine reinstate_paths when status=
 of pathgroup =3D "PGSTATE_ENABLED/PGSTATE_UNDEF" and path's state =3D "PST=
ATE_FAILED".
why command of multipath do above action to all dm devices? actually, parts=
 of these paths are already offline or failed which can't be recovered. May=
be we can check these devices's status by sending io to these sd device at =
first. according to return of io, multipath send reinstate to running devic=
es and do nothing to failed devices?

# multipath -ll
36d0d04b100b8cba665a187f0000000f9 dm-105 HUAWEI  ,XSG1
size=3D1.0G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
  |- 17:0:0:101 sdcy 70:96   failed faulty offline
  |- 18:0:0:101 sdgw 132:192 failed faulty offline
  `- 19:0:0:101 sdku 67:288  failed faulty offline

# multipath -ll
36d0d04b100b8cba665a187f0000000f9 dm-105 HUAWEI  ,XSG1
size=3D1.0G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'service-time 0' prio=3D1 status=3Dactive
  |- 17:0:0:101 sdcy 70:96   failed ready running
  |- 18:0:0:101 sdgw 132:192 failed ready running
  `- 19:0:0:101 sdku 67:288  failed ready running

--_000_F0921BF66894AB498DE908B06C95871AB06F952Bnkgeml513mbxchi_
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
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"text-justi=
fy-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US">Dear </span><span lang=3D"EN-US=
" style=3D"font-size:10.0pt;font-family:&quot;Courier New&quot;;color:#292B=
2C;background:white">Christophe,<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:30.0pt"><span lang=3D"EN-US" st=
yle=3D"font-size:10.0pt;font-family:&quot;Courier New&quot;;color:#292B2C;b=
ackground:white">when dm-105 is in one state of below, paths of dm-105 will=
 change to active if we run command of multipath.
 I check code of multipath, it sends messge &quot;reinstate_path pathname&q=
uot; to kernel in routine reinstate_paths when status of pathgroup =3D &quo=
t;PGSTATE_ENABLED/PGSTATE_UNDEF&quot; and path's state =3D &quot;PSTATE_FAI=
LED&quot;.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:30.0pt"><span lang=3D"EN-US" st=
yle=3D"font-size:10.0pt;font-family:&quot;Courier New&quot;;color:#292B2C;b=
ackground:white">why command of multipath do above action to all dm devices=
? actually, parts of these paths are already offline
 or failed which can't be recovered. Maybe we can check these devices's sta=
tus by sending io to these sd device at first. according to return of io, m=
ultipath send reinstate to running devices and do nothing to failed devices=
?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white"><o:p>&nbsp;<=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white"># multipath =
-ll<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">36d0d04b100b=
8cba665a187f0000000f9 dm-105 HUAWEI&nbsp; ,XSG1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">size=3D1.0G =
features=3D'0' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">`-&#43;- pol=
icy=3D'service-time 0' prio=3D0 status=3Denabled<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">&nbsp; |- 17=
:0:0:101 sdcy 70:96&nbsp;&nbsp; failed faulty offline<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">&nbsp; |- 18=
:0:0:101 sdgw 132:192 failed faulty offline<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">&nbsp; `- 19=
:0:0:101 sdku 67:288&nbsp; failed faulty offline<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white"><o:p>&nbsp;<=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white"># multipath =
-ll<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">36d0d04b100b=
8cba665a187f0000000f9 dm-105 HUAWEI&nbsp; ,XSG1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">size=3D1.0G =
features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">`-&#43;- pol=
icy=3D'service-time 0' prio=3D1 status=3Dactive<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">&nbsp; |- 17=
:0:0:101 sdcy 70:96&nbsp;&nbsp; failed ready running<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">&nbsp; |- 18=
:0:0:101 sdgw 132:192 failed ready running<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:10.0pt;font-=
family:&quot;Courier New&quot;;color:#292B2C;background:white">&nbsp; `- 19=
:0:0:101 sdku 67:288&nbsp; failed ready running&nbsp;
</span><span lang=3D"EN-US"><o:p></o:p></span></p>
</div>
</body>
</html>

--_000_F0921BF66894AB498DE908B06C95871AB06F952Bnkgeml513mbxchi_--


--===============3851843473628384410==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3851843473628384410==--
