From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: DM configuration
Date: Tue, 4 Oct 2005 15:29:51 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA002C73E05@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0091291477=="
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
To: christophe varoqui <christophe.varoqui@free.fr>, device-mapper development <dm-devel@redhat.com>
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0091291477==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C5C8CA.5CCF9092"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5C8CA.5CCF9092
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

Please let me know your inputs on the following,

=20

1) Under all path failure condition or the device is removed from array
(using management station), IO continues if "queue_if_no_path" feature
is enabled. As all the requests are cached all the memory gets used out
for this. Can there be any mechanism where the all path failure is
detected and marked, devices can be suspended or removed after some time
(user configurable). By doing this the OS stalling can be avoided when
the LUN is in dead state for prolonged period of time.

  =20

2) I am not able to give partial product ID string (substring) in
/etc/multipath.conf as DM expects complete product string. This
requirement is needed to cater different product id strings for same
product. The XP array has the ids based on the emulation type of each
LUN.   With the current settings available in /etc/multipath.conf, the
only option is to have separate "device" structs mentioning about the
policies/features for each LUN.

Thanks
-Murthy


------_=_NextPart_001_01C5C8CA.5CCF9092
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
10.0pt;font-family:"MS Sans Serif"'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Please let me know your inputs on =
the
following,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>1) Under all path failure condition =
or the
device is removed from array (using management station), IO continues if
&quot;queue_if_no_path&quot; feature is enabled. As all the requests are =
cached
all the memory gets used out for this. Can there be any mechanism where =
the all
path failure is detected and marked, devices can be suspended or removed =
after
some time (user configurable). By doing this the OS stalling can be =
avoided
when the LUN is in dead state for prolonged period of =
time.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>&nbsp;&nbsp; =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>2) I am not able to give partial =
product ID
string (substring) in /etc/multipath.conf as DM expects complete product
string. This requirement is needed to cater different product id strings =
for
same product. The XP array has the ids based on the emulation type of =
each LUN.
&nbsp;&nbsp;With the current settings available in /etc/multipath.conf, =
the
only option is to have separate &#8220;device&#8221; structs mentioning =
about
the policies/features for each LUN.<o:p></o:p></span></font></p>

<p><font size=3D2 face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;
font-family:"Microsoft Sans Serif"'>Thanks<br>
-Murthy<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C5C8CA.5CCF9092--


--===============0091291477==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0091291477==--
