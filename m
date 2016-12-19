From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: deterministic io throughput in multipath
Date: Mon, 19 Dec 2016 11:50:36 +0000
Message-ID: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2455925303803120355=="
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

--===============2455925303803120355==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_1649d4b8538d4b4cb1efacdfe8cf31ebBRMWPEXMB12corpbrocadec_"

--_000_1649d4b8538d4b4cb1efacdfe8cf31ebBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Customers using Linux host (mostly RHEL host) using a SAN network for block storage, complain the Linux multipath stack is not resilient to handle non-deterministic storage network behaviors. This has caused many customer move away to non-linux based servers. The intent of the below patch and the prevailing issues are given below. With the below design we are seeing the Linux multipath stack becoming resilient to such network issues. We hope by getting this patch accepted will help in more Linux server adoption that use SAN network.
I have already sent the design details to the community in a different mail chain and the details are available in the below link.
https://www.redhat.com/archives/dm-devel/2016-December/msg00122.html.
Can you please go through the design and send the comments to us.

Regards,
Muneendra.



--_000_1649d4b8538d4b4cb1efacdfe8cf31ebBRMWPEXMB12corpbrocadec_
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
@font-face
	{font-family:"Segoe UI";
	panose-1:2 11 5 2 4 2 4 2 2 3;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:8.0pt;
	margin-left:0in;
	line-height:106%;
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
<p class=3D"MsoNormal" style=3D"margin-bottom:0in;margin-bottom:.0001pt;lin=
e-height:normal;text-autospace:none">
<span style=3D"font-size:10.0pt;font-family:&quot;Segoe UI&quot;,sans-serif=
;color:black">Customers using Linux host (mostly RHEL host) using a SAN net=
work for block storage, complain the Linux multipath stack is not resilient=
 to handle non-deterministic storage network
 behaviors. This has caused many customer move away to non-linux based serv=
ers. The intent of the below patch and the prevailing issues are given belo=
w. With the below design we are seeing the Linux multipath stack becoming r=
esilient to such network issues.
 We hope by getting this patch accepted will help in more Linux server adop=
tion that use SAN network.
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-bottom:0in;margin-bottom:.0001pt;lin=
e-height:normal;text-autospace:none">
<span style=3D"font-size:10.0pt;font-family:&quot;Segoe UI&quot;,sans-serif=
;color:black">I have already sent the design details to the community in a =
different mail chain and the details are available in the below link.</span=
><o:p></o:p></p>
<p class=3D"MsoNormal"><a href=3D"https://www.redhat.com/archives/dm-devel/=
2016-December/msg00122.html">https://www.redhat.com/archives/dm-devel/2016-=
December/msg00122.html</a>.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"margin-bottom:0in;margin-bottom:.0001pt;lin=
e-height:normal;text-autospace:none">
<span style=3D"font-size:10.0pt;font-family:&quot;Segoe UI&quot;,sans-serif=
;color:black">Can you please go through the design and send the comments to=
 us. &nbsp;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Regards,<o:p></o:p></p>
<p class=3D"MsoNormal">Muneendra.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_1649d4b8538d4b4cb1efacdfe8cf31ebBRMWPEXMB12corpbrocadec_--


--===============2455925303803120355==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2455925303803120355==--
