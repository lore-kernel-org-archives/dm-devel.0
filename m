From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: state of inflight pending io's
Date: Mon, 6 Nov 2017 16:33:41 +0000
Message-ID: <4a06048d695541f48e1b8e058801ea3a@BRMWP-EXMB12.corp.brocade.com>
References: <423f36c4564248a7995f0f380c67fcb9@BRMWP-EXMB12.corp.brocade.com>
	<25bc44786c8d4fc4a674ef822ca2d3c4@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3586895410280725075=="
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

--===============3586895410280725075==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_4a06048d695541f48e1b8e058801ea3aBRMWPEXMB12corpbrocadec_"

--_000_4a06048d695541f48e1b8e058801ea3aBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi All,
We have two paths(devices) sda and sdb  under DM-1.
If the dm-1 have sent 5 requests(rq no: 1 thro 5) to the sda,  but req-3 got a check condition, whereas req-1,2,4,5 are still pending for completion.

My understanding from the  code is that, the DM would mark the sda path as failed, and moves the req-3 alone to other path. However, when the response (STATUS_GOOD)  for the req 1,2,4,5 arrives,  it would accept the response and complete the IOs successfully on sda. Can you plz kindly let me know if my understanding is correct?


Regards,
Muneendra.

--_000_4a06048d695541f48e1b8e058801ea3aBRMWPEXMB12corpbrocadec_
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
p.msonormal0, li.msonormal0, div.msonormal0
	{mso-style-name:msonormal;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle20
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
span.EmailStyle21
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
span.EmailStyle22
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
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1031" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi All,<o:p></o:p></p>
<p class=3D"MsoNormal">We have two <span style=3D"color:#1F497D">paths(devi=
ces)</span> sda and sdb&nbsp; under DM-1.<o:p></o:p></p>
<p class=3D"MsoNormal">If the dm-1 have sent 5 requests(rq no: 1 thro 5) to=
 the sda, &nbsp;but req-3 got a check condition, whereas req-1,2,4,5 are st=
ill pending for completion.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">My understanding from the &nbsp;code is that, the DM=
 would mark the sda
<span style=3D"color:#1F497D">path </span>as fa<span style=3D"color:#1F497D=
">iled</span>, and moves the req-3 alone to other path. However, when the r=
esponse (STATUS_GOOD) &nbsp;for the req 1,2,4,5 arrives, &nbsp;it would acc=
ept the response and complete the IOs successfully<span style=3D"color:#1F4=
97D">
 on sda</span>. Can you plz kindly let me know if my understanding is corre=
ct? <o:p>
</o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Regards,<o:p></o:p></p>
<p class=3D"MsoNormal">Muneendra.<o:p></o:p></p>
</div>
</body>
</html>

--_000_4a06048d695541f48e1b8e058801ea3aBRMWPEXMB12corpbrocadec_--


--===============3586895410280725075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3586895410280725075==--
