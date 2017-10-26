From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Pushing the multipath state info into the fabric
Date: Thu, 26 Oct 2017 10:18:34 +0000
Message-ID: <003dec9a190f45aa91bff7e0010968e1@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5582541216918491775=="
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

--===============5582541216918491775==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_003dec9a190f45aa91bff7e0010968e1BRMWPEXMB12corpbrocadec_"

--_000_003dec9a190f45aa91bff7e0010968e1BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi ,

We are working on the SAN fabric side to collect and present the multipath status information to the SAN administrators.
So, I am looking forward to push the multipath state information to the fabric in the form of CT (Common Transport) frames, by using the libhba APIs.
Since the multipath daemon is already keeping track of the multipath device and state info, I feel that it is the correct place to add the code to push the info to the fabric.
Please kindly let me know your thoughts on this.


Regards,
Muneendra.

--_000_003dec9a190f45aa91bff7e0010968e1BRMWPEXMB12corpbrocadec_
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
<p class=3D"MsoNormal"><span style=3D"color:black">Hi ,<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:black"><o:p>&nbsp;</o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">We are working on the SA=
N fabric side to collect and present the multipath status information to th=
e SAN administrators.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">So, I am looking forward=
 to push the multipath state information to the fabric in the form of CT (C=
ommon Transport) frames, by using the libhba APIs.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">Since the multipath daem=
on is already keeping track of the multipath device and state info, I feel =
that it is the correct place to add the code to push the info to the fabric=
.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">Please kindly let me kno=
w your thoughts on this.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black"><o:p>&nbsp;</o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black"><o:p>&nbsp;</o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">Regards,<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:black">Muneendra.<o:p></o:p></s=
pan></p>
</div>
</body>
</html>

--_000_003dec9a190f45aa91bff7e0010968e1BRMWPEXMB12corpbrocadec_--


--===============5582541216918491775==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5582541216918491775==--
