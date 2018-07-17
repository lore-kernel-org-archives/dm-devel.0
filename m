From: dingwenyi <dingwenyi@huawei.com>
Subject: Can we add a command to display the physical topology
 link information from the host to the storage?
Date: Tue, 17 Jul 2018 02:22:33 +0000
Message-ID: <93124DD789DD024A93798C694A8359A5422D98AF@dggemi522-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2692065380149568383=="
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
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: wangzhoumengjian <wangzhoumengjian@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>, "Chengjike (ISSP)" <chengjike.cheng@huawei.com>
List-Id: dm-devel.ids

--===============2692065380149568383==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_93124DD789DD024A93798C694A8359A5422D98AFdggemi522mbxchi_"

--_000_93124DD789DD024A93798C694A8359A5422D98AFdggemi522mbxchi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

We execute the multipath -ll output information as follows, and can not obt=
ain the information about the host's initiator and storage target that can =
be directly recognized , such as WWN.
mpathe (360022a11000beb2a7fc8e9c500000001) dm-3 HUAWEI,S5500T
size=3D512G features=3D'1 retain_attached_hw_handler' hwhandler=3D'0' wp=3D=
rw
|-+- policy=3D'service-time 0' prio=3D1 status=3Dactive
| `- 6:0:0:1 sde 8:64  active ghost running
`-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
  `- 7:0:0:1 sdd 8:48  active ready running
mpathd (360022a11000beb2a7fca035a00000004) dm-2 HUAWEI,S5500T
size=3D100M features=3D'1 retain_attached_hw_handler' hwhandler=3D'0' wp=3D=
rw
|-+- policy=3D'service-time 0' prio=3D1 status=3Dactive
| `- 6:0:0:0 sdc 8:32  active ready running
`-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
  `- 7:0:0:0 sdb 8:16  active ghost running


We have a solution for the multipath path. Add a command to display the phy=
sical topology link information from the host to the storage, and display t=
he following information to quickly and easily find the host and initiator =
information on the storage.
[root@redhat7 ~]# multipath -k
link-6:0:0 host-WWNN=3Diqn.1994-05.com.redhat:86329aefccdb host-WWPN=3D[unk=
nown] target-WWNN=3Diqn.2006-08.com.huawei:oceanstor:21000022a10beb2a::1020=
002:129.13.100.240 target-WWPN=3D[undef]
link-7:0:0 host-WWNN=3Diqn.1994-05.com.redhat:86329aefccdb host-WWPN=3D[unk=
nown] target-WWNN=3Diqn.2006-08.com.huawei:oceanstor:21000022a10beb2a::2000=
3:129.13.100.241 target-WWPN=3D[undef]

could you agree with this solution or have a better solution?



I am looking forward to your reply.
Best wishes to you.

--_000_93124DD789DD024A93798C694A8359A5422D98AFdggemi522mbxchi_
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
@font-face
	{font-family:inherit;
	panose-1:0 0 0 0 0 0 0 0 0 0;}
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML \9884\8BBE\683C\5F0F Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:SimSun;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.HTMLChar
	{mso-style-name:"HTML \9884\8BBE\683C\5F0F Char";
	mso-style-priority:99;
	mso-style-link:"HTML \9884\8BBE\683C\5F0F";
	font-family:SimSun;}
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
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"text-justi=
fy-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN" style=3D"font-size:12.0pt;font-family:&quot;inherit=
&quot;,serif;color:#212121">We execute the multipath -ll output information=
 as follows, and can not obtain the information about
 the host's initiator and storage target that can be directly recognized , =
such as WWN.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">mpathe (360022a11000beb2a7fc8e9=
c500000001) dm-3 HUAWEI,S5500T<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">size=3D512G features=3D'1 retai=
n_attached_hw_handler' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">|-&#43;- policy=3D'service-time=
 0' prio=3D1 status=3Dactive<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">| `- 6:0:0:1 sde 8:64&nbsp; act=
ive ghost running<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">`-&#43;- policy=3D'service-time=
 0' prio=3D1 status=3Denabled<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; `- 7:0:0:1 sdd 8:48&nbsp=
; active ready running<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">mpathd (360022a11000beb2a7fca03=
5a00000004) dm-2 HUAWEI,S5500T<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">size=3D100M features=3D'1 retai=
n_attached_hw_handler' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">|-&#43;- policy=3D'service-time=
 0' prio=3D1 status=3Dactive<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">| `- 6:0:0:0 sdc 8:32&nbsp; act=
ive ready running<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">`-&#43;- policy=3D'service-time=
 0' prio=3D1 status=3Denabled<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; `- 7:0:0:0 sdb 8:16&nbsp=
; active ghost running<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN" style=3D"font-size:12.0pt;font-family:&quot;inherit=
&quot;,serif;color:#212121"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN" style=3D"font-size:12.0pt;font-family:&quot;inherit=
&quot;,serif;color:#212121"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN" style=3D"font-size:12.0pt;font-family:&quot;inherit=
&quot;,serif;color:#212121">We have a solution for the multipath path. Add =
a command to display the physical topology link information
 from the host to the storage, and display the following information to qui=
ckly and easily find the host and initiator information on the storage.<o:p=
></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;inhe=
rit&quot;,serif;color:#212121">[root@redhat7 ~]# multipath -k<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;inhe=
rit&quot;,serif;color:#212121">link-6:0:0 host-WWNN=3Diqn.1994-05.com.redha=
t:86329aefccdb host-WWPN=3D[unknown] target-WWNN=3Diqn.2006-08.com.huawei:o=
ceanstor:21000022a10beb2a::1020002:129.13.100.240
 target-WWPN=3D[undef]<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;inhe=
rit&quot;,serif;color:#212121">link-7:0:0 host-WWNN=3Diqn.1994-05.com.redha=
t:86329aefccdb host-WWPN=3D[unknown] target-WWNN=3Diqn.2006-08.com.huawei:o=
ceanstor:21000022a10beb2a::20003:129.13.100.241
 target-WWPN=3D[undef]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN" style=3D"font-size:12.0pt;font-family:&quot;inherit=
&quot;,serif;color:#212121">could you agree with this solution or have a be=
tter solution?</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-fa=
mily:&quot;inherit&quot;,serif;color:#212121"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN" style=3D"font-size:12.0pt;font-fam=
ily:&quot;inherit&quot;,serif;color:#212121"><o:p>&nbsp;</o:p></span></p>
<pre><span lang=3D"EN-US">I am looking forward to your reply.<o:p></o:p></s=
pan></pre>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:SimSun">Best wishes to you.</span><span lang=3D"EN-US"><o:p></o:p></=
span></p>
</div>
</body>
</html>

--_000_93124DD789DD024A93798C694A8359A5422D98AFdggemi522mbxchi_--


--===============2692065380149568383==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2692065380149568383==--
