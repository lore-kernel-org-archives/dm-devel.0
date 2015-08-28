From: Sharath Babu <sharath.babu@citrix.com>
Subject: Issue with DM Multipath reconfigure command
Date: Fri, 28 Aug 2015 14:04:20 +0000
Message-ID: <A6CE42142A091443876431D464B0DA9D24B54C@SINPEX01CL03.citrite.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1154122749574097029=="
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

--===============1154122749574097029==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_A6CE42142A091443876431D464B0DA9D24B54CSINPEX01CL03citri_"

--_000_A6CE42142A091443876431D464B0DA9D24B54CSINPEX01CL03citri_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

This is regarding an issue associated with multipath module. The reconfigur=
e of multipathd is dropping faulty paths from the maps. Consider a case as =
given below where a path is faulty. On doing a reconfigure, these faulty pa=
ths are dropped from the maps. This behavior prevents the path checkers to =
detect any changes that occur to these faulty paths asynchronously. Hence o=
nce the paths are up, an explicit reconfigure is needed to use these faulty=
 paths. These devices are still present in the system and they are added ba=
ck into the system only if dev_loss_tmo is set to a finite value. Is this h=
ow reconfigure designed to behave or this is an bug ?


[root@dt02 ~]# multipathd -k"show top"
create: 360a980004334694b50346e714b775277 dm-5 NETAPP,LUN
size=3D768M features=3D'4 queue_if_no_path pg_init_retries 50 retain_attach=
ed_hw_handle' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  |- 19:0:0:0 sdj 8:144 active ready  running
  `- 20:0:0:0 sdk 8:160 failed faulty offline
[root@dt02 ~]# multipathd -k"reconf"
ok
[root@dt02 ~]# multipathd -k"show top"
360a980004334694b50346e714b775277 dm-5 NETAPP,LUN
size=3D768M features=3D'4 queue_if_no_path pg_init_retries 50 retain_attach=
ed_hw_handle' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D2 status=3Dactive
  `- 19:0:0:0 sdj 8:144 active ready running




Please let me know if you need more information. This was tested by setting=
 dev_loss_tmo to "infinity" and DM library (device-mapper-multipath-libs-0.=
4.9-66.el7.x86_64) with CentOS. It would be really grateful if you can shar=
e your thoughts on the same.

Thanks,

Sharath Babu  | Software Engineer 2 - XenServer Dev,  India | M:  +91 90031=
00899
Citrix Systems, Inc. (NASDAQ: CTXS)  |  http://www.citrix.com<http://www.ci=
trix.com/>


--_000_A6CE42142A091443876431D464B0DA9D24B54CSINPEX01CL03citri_
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
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
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
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:"Calibri",sans-serif;}
span.EmailStyle21
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle22
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
span.EmailStyle23
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
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
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">This is regarding an issue associated with multipath=
 module. The reconfigure of
<i>multipathd</i> is dropping faulty paths from the maps. Consider a case a=
s given below where a path is faulty. On doing a reconfigure, these faulty =
paths are dropped from the maps. This behavior prevents the path checkers t=
o detect any changes that occur
 to these faulty paths asynchronously. Hence once the paths are up, an expl=
icit reconfigure is needed to use these faulty paths. These devices are sti=
ll present in the system and they are added back into the system only if
<i>dev_loss_tmo</i> is set to a finite value. Is this how reconfigure desig=
ned to behave or this is an bug ?
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">[root@dt02 ~]# multipathd -k&quot;show top&quot;<o:p></o:p></span></p=
>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">create: 360a980004334694b50346e714b775277 dm-5 NETAPP,LUN<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">size=3D768M features=3D'4 queue_if_no_path pg_init_retries 50 retain_=
attached_hw_handle' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">`-&#43;- policy=3D'round-robin 0' prio=3D2 status=3Dactive<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">&nbsp; |- 19:0:0:0 sdj 8:144 active ready&nbsp; running<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">&nbsp; `- 20:0:0:0 sdk 8:160 failed faulty offline<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">[root@dt02 ~]# multipathd -k&quot;reconf&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">ok<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">[root@dt02 ~]# multipathd -k&quot;show top&quot;<o:p></o:p></span></p=
>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">360a980004334694b50346e714b775277 dm-5 NETAPP,LUN<o:p></o:p></span></=
p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">size=3D768M features=3D'4 queue_if_no_path pg_init_retries 50 retain_=
attached_hw_handle' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">`-&#43;- policy=3D'round-robin 0' prio=3D2 status=3Dactive<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal" style=3D"line-height:12.0pt;background:whitesmoke"><=
span style=3D"font-size:9.0pt;font-family:&quot;Courier New&quot;;color:#33=
3333">&nbsp; `- 19:0:0:0 sdj 8:144 active ready running<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Please let me know if you need more information. =
This was tested by setting
<i>dev_loss_tmo</i> to &#8220;<i>infinity</i>&#8221; and DM library (device=
-mapper-multipath-libs-0.4.9-66.el7.x86_64) with CentOS. It would be really=
 grateful if you can share your thoughts on the same.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"margin-bottom:12.0pt"><b><span lang=3D"EN-I=
N" style=3D"font-size:10.0pt;color:#133259">Sharath Babu</span></b><span la=
ng=3D"EN-IN" style=3D"font-size:10.0pt;color:#133259">&nbsp;&nbsp;| Softwar=
e Engineer 2 &#8211; XenServer Dev,&nbsp; India | M: &nbsp;&#43;91 90031008=
99<br>
</span><span lang=3D"EN-IN" style=3D"font-size:10.0pt;color:#5089D0">Citrix=
 Systems, Inc. (NASDAQ: CTXS) &nbsp;| &nbsp;</span><span lang=3D"EN-IN" sty=
le=3D"color:#1F497D"><a href=3D"http://www.citrix.com/"><span style=3D"font=
-size:10.0pt;color:blue">http://www.citrix.com</span></a></span><span lang=
=3D"EN-GB" style=3D"color:#1F497D;mso-fareast-language:EN-GB"><o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_A6CE42142A091443876431D464B0DA9D24B54CSINPEX01CL03citri_--


--===============1154122749574097029==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1154122749574097029==--
