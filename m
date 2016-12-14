From: Xieyingtai <xieyingtai@huawei.com>
Subject: libmultipath: how to handle sg_read return PATH_DOWN
 with some lpfc drivers?
Date: Wed, 14 Dec 2016 03:19:38 +0000
Message-ID: <AF7C226D2A4F8B4D913D33FF7150AE055A769442@szxeml556-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8978927386071732458=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "Subo (A)" <subo7@huawei.com>, "Fangyi (C)" <eric.fangyi@huawei.com>
List-Id: dm-devel.ids

--===============8978927386071732458==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_AF7C226D2A4F8B4D913D33FF7150AE055A769442szxeml556mbschi_"

--_000_AF7C226D2A4F8B4D913D33FF7150AE055A769442szxeml556mbschi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
         Recently I met a problem with descrptions below:
         When /etc/multipath.conf was configured "path_checker" with readse=
ctor0 and passed in BUFFER_SIZE 4096 to
         sg_read() as below:
         int libcheck_check (struct checker * c)
{
         unsigned char buf[4096];
         unsigned char sbuf[SENSE_BUFF_LEN];
         int ret;

         ret =3D sg_read(c->fd, &buf[0], 4096, &sbuf[0],
                         SENSE_BUFF_LEN, c->timeout);
         ......
}
         In sg_read(), the io_hdr.dxfer_len =3D bs*blocks will be 4096, As =
a result the SG_IO may return DID_ERROR and libcheck_check
         return PATH_DOWN with some Storage devices. The lpfc_scsi logs pre=
sent as below:

lpfc 0000:82:00.0: 0:0336 Rsp Ring 0 error: IOCB Data: xff000018 x60 x0 x0 =
xe00 x0 xa8f0b2e xa29b12
lpfc 0000:82:00.0: 0:(0):9030 FCP cmd x28 failed <0/1> status: x1 result: x=
0 sid: x12700 did: x11a00 oxid: xffff Data: xa8f xb2e
lpfc 0000:82:00.0: 0:(0):9024 FCP command x28 failed: x0 SNS x0 x0 Data: x8=
 xe38 x0 x0 x0
lpfc 0000:82:00.0: 0:(0):9025 FCP Read Underrun, expected 4096, residual 36=
40 Data: xe00 x28 x0
lpfc 0000:82:00.0: 0:(0):9026 FCP Read Check Error and Underrun Data: x1000=
 xe38 xe00 x28
lpfc 0000:82:00.0: 0:(0):0710 Iodone <0/1> cmd ffff880a6927c080, error x700=
00 SNS x0 x0 Data: x0 x1000
lpfc 0000:82:00.0: 0:0336 Rsp Ring 0 error: IOCB Data: xff000018 x60 x0 x0 =
xe00 x0 xa930e92 xa29b12
lpfc 0000:82:00.0: 0:(0):9030 FCP cmd x28 failed <0/10> status: x1 result: =
x0 sid: x12700 did: x11a00 oxid: xffff Data: xa93 xe92
lpfc 0000:82:00.0: 0:(0):9024 FCP command x28 failed: x0 SNS x0 x0 Data: x8=
 xe38 x0 x0 x0
lpfc 0000:82:00.0: 0:(0):9025 FCP Read Underrun, expected 4096, residual 36=
40 Data: xe00 x28 x0
lpfc 0000:82:00.0: 0:(0):9026 FCP Read Check Error and Underrun Data: x1000=
 xe38 xe00 x28
multipathd[23272]: check_path[1334]: 363334351003637380b7492e600000077: sdc=
w - readsector0 checker reports path is down

         In fact, the devices can be read and write normally but multipathd=
 fail_path it. Is there any advice to handle this problem? Thanks

!

--_000_AF7C226D2A4F8B4D913D33FF7150AE055A769442szxeml556mbschi_
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
	font-family:"Calibri","sans-serif";}
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
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
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
<p class=3D"MsoNormal"><span lang=3D"EN-US">Hi,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; Recently I met a problem with descrptions below:<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; When /etc/multipath.conf was configured &#8220;path_check=
er&#8221; with readsector0 and passed in BUFFER_SIZE 4096 to<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; sg_read() as below:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; int libcheck_check (struct checker * c)<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">{<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; unsigned char buf[4096];<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; unsigned char sbuf[SENSE_BUFF_LEN];<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; int ret;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; ret =3D sg_read(c-&gt;fd, &amp;buf[0], 4096, &amp;sbuf[0]=
,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SENSE_BUFF_LEN, c-&gt;timeout);<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; &#8230;&#8230;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">}<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; In sg_read(), the io_hdr.dxfer_len =3D bs*blocks will be =
4096, As a result the SG_IO may return DID_ERROR and libcheck_check<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; return PATH_DOWN with some Storage devices. The lpfc_scsi=
 logs present as below:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:0336 Rsp Ring 0 error: IOCB Data: xff000018 x60 x0 x0 xe=
00 x0 xa8f0b2e xa29b12<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9030 FCP cmd x28 failed &lt;0/1&gt; status: x1 resul=
t: x0 sid: x12700 did: x11a00 oxid: xffff Data: xa8f xb2e<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9024 FCP command x28 failed: x0 SNS x0 x0 Data: x8 x=
e38 x0 x0 x0<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9025 FCP Read Underrun, expected 4096, residual 3640=
 Data: xe00 x28 x0<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9026 FCP Read Check Error and Underrun Data: x1000 x=
e38 xe00 x28<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):0710 Iodone &lt;0/1&gt; cmd ffff880a6927c080, error =
x70000 SNS x0 x0 Data: x0 x1000<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:0336 Rsp Ring 0 error: IOCB Data: xff000018 x60 x0 x0 xe=
00 x0 xa930e92 xa29b12<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9030 FCP cmd x28 failed &lt;0/10&gt; status: x1 resu=
lt: x0 sid: x12700 did: x11a00 oxid: xffff Data: xa93 xe92<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9024 FCP command x28 failed: x0 SNS x0 x0 Data: x8 x=
e38 x0 x0 x0<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9025 FCP Read Underrun, expected 4096, residual 3640=
 Data: xe00 x28 x0<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">lp=
fc 0000:82:00.0: 0:(0):9026 FCP Read Check Error and Underrun Data: x1000 x=
e38 xe00 x28<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:21.0pt"><span lang=3D"EN-US">mu=
ltipathd[23272]: check_path[1334]: 363334351003637380b7492e600000077: sdcw =
- readsector0 checker reports path is down<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; In fact, the devices can be read and write normally but m=
ultipathd fail_path it. Is there any advice to handle this problem? Thanks<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:7.5pt;font-f=
amily:&quot;Arial&quot;,&quot;sans-serif&quot;;color:gray">!</span><span la=
ng=3D"EN-US"><o:p></o:p></span></p>
</div>
</body>
</html>

--_000_AF7C226D2A4F8B4D913D33FF7150AE055A769442szxeml556mbschi_--


--===============8978927386071732458==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8978927386071732458==--
