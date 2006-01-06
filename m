From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: in-code default value for no_path_retry parameter
Date: Fri, 6 Jan 2006 20:53:19 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA003450837@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0618551215=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Securelinux <securelinux@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0618551215==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C612D5.203E6F1C"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C612D5.203E6F1C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Alasdair

We can set "no_path_retry" to "fail" or "queue" or <num> from
/etc/multipath.conf file. But we can't set any in-code default value as
we do for other variables in setup_default_hwtable(..) in
libmultipath/hwtable.c, rather "features" parameter has to be set to
either NULL or "1 queue_if_no_path".  Also the value is applied to DM
devices only when the no_path_retry is configured via defaults section
in /etc/multipath.conf file. There is no change in DM device map
properties if "no_path_retry" is configured elsewhere other than default
section.  Do I need to submit a bugzilla for this?

Thanks and regards
-Murthy


------_=_NextPart_001_01C612D5.203E6F1C
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"MS Sans Serif";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Microsoft Sans Serif";
	panose-1:2 11 6 4 2 2 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"MS Sans Serif";
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Hi =
Alasdair<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>We can set <b><span =
style=3D'font-weight:
bold'>&#8220;no_path_retry&#8221;</span></b> to &#8220;fail&#8221; or =
&#8220;queue&#8221;
or &lt;num&gt; from /etc/multipath.conf file. But we can&#8217;t set any =
in-code
default value as we do for other variables in setup_default_hwtable(..) =
in
libmultipath/hwtable.c, rather <b><span =
style=3D'font-weight:bold'>&#8220;features&#8221;
</span></b>parameter has to be set to either NULL or &#8220;1 =
queue_if_no_path&#8221;.
&nbsp;Also the value is applied to DM devices only when the =
no_path_retry is
configured via <b><span style=3D'font-weight:bold'>defaults =
</span></b>section in
/etc/multipath.conf file. There is no change in DM device map properties =
if <b><span
style=3D'font-weight:bold'>&#8220;no_path_retry&#8221;</span></b> is =
configured
elsewhere other than default section. &nbsp;Do I need to submit a =
bugzilla for
this?<o:p></o:p></span></font></p>

<p><font size=3D2 face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;
font-family:"Microsoft Sans Serif"'>Thanks and regards<br>
-Murthy<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C612D5.203E6F1C--


--===============0618551215==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0618551215==--
