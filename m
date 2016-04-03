From: Xieyingtai <xieyingtai@huawei.com>
Subject: libmultipath: alua prio mode can't not get priority when
 using DataCore product
Date: Sun, 3 Apr 2016 06:36:48 +0000
Message-ID: <AF7C226D2A4F8B4D913D33FF7150AE0531BBD543@szxeml556-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8780811963594790798=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

--===============8780811963594790798==
Content-Language: zh-CN
Content-Type: multipart/related;
	boundary="_004_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_";
	type="multipart/alternative"

--_004_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_
Content-Type: multipart/alternative;
	boundary="_000_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_"

--_000_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

DQoNCldoZW4gdXNpbmcgRGF0YUNvcmUgobBWaXJ0dWFsIERpc2uhsXByb2R1Y3RzIHJlY2VudGx5
LCBpIGdvdCBhIHByb2JsZW0uIERtIGRldmljZSBjb3VsZCBub3QgYmUgY3JlYXRlZA0KDQppbiBw
YXRoX2Rpc2NvdmVyIGFzIGdldF9wcmlvKCkgd2FzIG5vdCBhYmxlIHRvIGdldCBwcmlvcml0eSBp
biBhbHVhIHByaW8gbW9kZS4gVGhlIGRlZmF1bHRfaHcgaXMgYmVsb3c6DQoNCg0KDQp7DQoNCiAg
ICAgICAgLnZlbmRvciAgICAgICAgPSAiRGF0YUNvcmUiLA0KDQogICAgICAgIC5wcm9kdWN0ICAg
ICAgID0gIlZpcnR1YWwgRGlzayIsDQoNCiAgICAgICAgLmZlYXR1cmVzICAgICAgPSBERUZBVUxU
X0ZFQVRVUkVTLA0KDQogICAgICAgIC5od2hhbmRsZXIgICAgID0gREVGQVVMVF9IV0hBTkRMRVIs
DQoNCiAgICAgICAgLnBncG9saWN5ICAgICAgPSBHUk9VUF9CWV9QUklPLA0KDQogICAgICAgIC5w
Z2ZhaWxiYWNrICAgID0gLUZBSUxCQUNLX0lNTUVESUFURSwNCg0KICAgICAgICAucnJfd2VpZ2h0
ICAgICA9IFJSX1dFSUdIVF9OT05FLA0KDQogICAgICAgIC5jaGVja2VyX25hbWUgID0gVFVSLA0K
DQogICAgICAgIC5wcmlvX25hbWUgICAgID0gUFJJT19BTFVBLA0KDQogICAgICAgIC5wcmlvX2Fy
Z3MgICAgID0gTlVMTCwNCg0KfQ0KDQoNCg0KQnV0IGlmIGEgbmV3IHBhdGggaXMgYWRkZWQgd2hl
biB0aGUgZG0gZGV2aWNlIHdhcyBhbHJlYWR5IGNyZWF0ZWQsIGl0IHdpbGwgYmUgYWRkZWQgdG8g
dGhlIGRtIGRldmljZQ0KDQpzdWNjZXNzZnVsbHkganVzdCBiZWNhdXNlIGV2X2FkZF9wYXRoKCkg
d2lsbCBub3QgY2FyZSB0aGUgcGF0aCBwcmlvIHdoaWxlIGNvYWxlc2NlX3BhdGhzKCkgd2lsbCBj
aGVjaw0KDQp0aGUgcGF0aCBwcmlvcml0eSBhbmQgc2V0IHRoZSBtcHAgYWN0aW9uIHRvIEFDVF9S
RUpFQ1QuIElzIHRoZXJlIGFueSBzb2x1dGlvbiB0byBzb2x2ZSB0aGlzIHByb2JsZW2jvw0KDQoN
Cg0K

--_000_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:m=3D"http://sc=
hemas.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-=
html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Microsoft Theme 2.00" content=3D"sumipntg 011">
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:=CB=CE=CC=E5;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:"\@=CB=CE=CC=E5";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;}
h1
	{mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 1 Char";
	margin-top:17.0pt;
	margin-right:0cm;
	margin-bottom:16.5pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:240%;
	page-break-after:avoid;
	font-size:16.0pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;}
h2
	{mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 2 Char";
	margin-top:13.0pt;
	margin-right:0cm;
	margin-bottom:13.0pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:171%;
	page-break-after:avoid;
	font-size:14.0pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;
	font-weight:normal;}
h3
	{mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 3 Char";
	margin-top:13.0pt;
	margin-right:0cm;
	margin-bottom:13.0pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:171%;
	page-break-after:avoid;
	font-size:13.0pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;
	font-weight:normal;}
h4
	{mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 4 Char";
	margin-top:14.0pt;
	margin-right:0cm;
	margin-bottom:14.5pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:155%;
	page-break-after:avoid;
	font-size:14.0pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;
	font-weight:normal;}
h5
	{mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 5 Char";
	margin-top:14.0pt;
	margin-right:0cm;
	margin-bottom:14.5pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:155%;
	page-break-after:avoid;
	font-size:13.0pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;
	font-weight:normal;}
h6
	{mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 6 Char";
	margin-top:12.0pt;
	margin-right:0cm;
	margin-bottom:3.2pt;
	margin-left:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	line-height:131%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:=CB=CE=CC=E5;
	color:#000066;
	font-weight:normal;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#3333CC;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#666699;
	text-decoration:underline;}
span.1Char
	{mso-style-name:"=B1=EA=CC=E2 1 Char";
	mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 1";
	font-family:=CB=CE=CC=E5;
	color:#000066;
	font-weight:bold;}
span.2Char
	{mso-style-name:"=B1=EA=CC=E2 2 Char";
	mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 2";
	font-family:=CB=CE=CC=E5;
	color:#000066;}
span.3Char
	{mso-style-name:"=B1=EA=CC=E2 3 Char";
	mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 3";
	font-family:=CB=CE=CC=E5;
	color:#000066;}
span.4Char
	{mso-style-name:"=B1=EA=CC=E2 4 Char";
	mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 4";
	font-family:=CB=CE=CC=E5;
	color:#000066;}
span.5Char
	{mso-style-name:"=B1=EA=CC=E2 5 Char";
	mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 5";
	font-family:=CB=CE=CC=E5;
	color:#000066;}
span.6Char
	{mso-style-name:"=B1=EA=CC=E2 6 Char";
	mso-style-priority:9;
	mso-style-link:"=B1=EA=CC=E2 6";
	font-family:=CB=CE=CC=E5;
	color:#000066;}
span.EmailStyle23
	{mso-style-type:personal-compose;
	color:#000066;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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
<body bgcolor=3D"white" background=3D"cid:image001.jpg@01D18D92.999649C0" l=
ang=3D"ZH-CN" link=3D"#3333CC" vlink=3D"#666699" style=3D"text-justify-trim=
:punctuation">
<img src=3D"cid:image001.jpg@01D18D92.999649C0" v:src=3D"cid:image001.jpg@0=
1D18D92.999649C0" v:shapes=3D"_x0000_Mail" width=3D"0" height=3D"0" class=
=3D"shape" style=3D"display:none;width:0;height:0"><!--[if gte mso 9]><xml>
<v:background id=3D"_x0000_s1025" o:bwmode=3D"white" o:targetscreensize=3D"=
800,600">
<v:fill src=3D"cid:image001.jpg@01D18D92.999649C0" o:title=3D"sumtextb" typ=
e=3D"frame" />
</v:background></xml><![endif]-->
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US">When using DataCore </span>=A1=
=B0<span lang=3D"EN-US">Virtual Disk</span>=A1=B1<span lang=3D"EN-US">produ=
cts recently, i got a problem. Dm device could not be created<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">in path_discover as get_prio() =
was not able to get priority in alua prio mode. The default_hw is below:<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">{<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .vendor &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D &quot;DataCore=
&quot;,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D &quot;Virtual =
Disk&quot;,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D DEFAULT_FEATURES,<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .hwhandler&nbsp;&nbsp;&nbsp;&nbsp; =3D DEFAULT_HWHANDLER,<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .pgpolicy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D GROUP_BY_PRIO,<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .pgfailback&nbsp;&nbsp;&nbsp; =3D -FAILBACK_IMMEDIATE,<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .rr_weight&nbsp;&nbsp;&nbsp;&nbsp; =3D RR_WEIGHT_NONE,<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .checker_name&nbsp; =3D TUR,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .prio_name&nbsp;&nbsp;&nbsp;&nbsp; =3D PRIO_ALUA,<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; .prio_args&nbsp;&nbsp;&nbsp;&nbsp; =3D NULL,<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">But if a new path is added when=
 the dm device was already created, it will be added to the dm device
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">successfully just because ev_ad=
d_path() will not care the path prio while coalesce_paths() will check<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">the path priority and set the m=
pp action to ACT_REJECT. Is there any solution to solve this problem</span>=
=A3=BF<span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_--

--_004_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_
Content-Type: image/jpeg; name="image001.jpg"
Content-Description: image001.jpg
Content-Disposition: inline; filename="image001.jpg"; size=4863;
	creation-date="Sun, 03 Apr 2016 02:51:43 GMT";
	modification-date="Sun, 03 Apr 2016 02:51:43 GMT"
Content-ID: <image001.jpg@01D18D92.999649C0>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAwICAgJCAwJCQwRCwoLERUPDAwPFRgTExUTExgRDAwM
DAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQ0LCw0ODRAODhAUDg4OFBQODg4O
FBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAC3AS8DASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD09mbo
w5FKH6H+VNBB4HT1pcD7pFACkk98Ug9+tBIyPftQxPGBmgA6Drmk3c45paBnHJwBQAZ70Zz+FJgk
84xRgbeDk9h2oAWg/TOKOenX1ozjpQAAY6dKDtXJxzSFwevbinZGOB+NACBl9OtLuA7DmmkZ60Hg
8DJoAdkkH09KM+nX2po46k/nSnP5UAHtjrR0OMflQW9aQk9wcfSgBckfT9KQ59M0bS3TIz0zShQO
CSR7UAIGycdPanHntj6Unyj2H60Z5GDx60AKM0E5+tIcnuaBnGKADLDp1pdxI5OaQryeKNqjtQAp
U55OPagr/t8ewpCAT1IoKjIznI70AKEUj79LsA/ippH+z+NGBnPegA7cEn60UpGRnNKFPc0AIxHc
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
xjp70UUAOpORxnJ9aKKAP//Z

--_004_AF7C226D2A4F8B4D913D33FF7150AE0531BBD543szxeml556mbschi_--


--===============8780811963594790798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8780811963594790798==--
