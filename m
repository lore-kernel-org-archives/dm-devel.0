From: "Eli Malul" <eli.malul@kaminario.com>
Subject: creating a cascaded linear devices fails
Date: Thu, 14 Apr 2011 12:06:26 +0300
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD3019D4988@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4766342916176957600=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============4766342916176957600==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBFA83.3CA25E54"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBFA83.3CA25E54
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I do not understand why creating a linear device and then trying to
create another linear device on top of it fails.



1.       Creating a linear device over loop1:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
dmsetup create linear_loop1 /tmp/linear_loop1

cat /tmp/linear_loop1
0 1000 linear /dev/loop1 0



2.       Then creating another linear device over this linear device:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
dmsetup create linear_loop2 /tmp/linear_loop2

device-mapper: reload ioctl failed: Invalid argument
Command failed

cat /tmp/klinear_loop2
0 1000 linear /dev/linear_loop1 0

=20

Could you please explain what am I doing wrong?


------_=_NextPart_001_01CBFA83.3CA25E54
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 12 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:right;
	direction:rtl;
	unicode-bidi:embed;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0cm;
	margin-right:36.0pt;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	text-align:right;
	direction:rtl;
	unicode-bidi:embed;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:240875289;
	mso-list-type:hybrid;
	mso-list-template-ids:-1310158852 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1
	{mso-list-id:319700188;
	mso-list-type:hybrid;
	mso-list-template-ids:-1000020896 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l1:level1
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:18.0pt;
	text-indent:-18.0pt;}
@list l1:level2
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:54.0pt;
	text-indent:-18.0pt;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>I do not =
understand why creating a linear device and then trying to create =
another linear device on top of it fails.<br><br><o:p></o:p></p><p =
class=3DMsoListParagraph =
style=3D'mso-margin-top-alt:0cm;margin-right:0cm;margin-bottom:0cm;margin=
-left:36.0pt;margin-bottom:.0001pt;text-align:left;text-indent:-18.0pt;ms=
o-list:l0 level1 lfo2;direction:ltr;unicode-bidi:embed'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>1.<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]><span dir=3DLTR></span>Creating a linear device =
over =
loop1:<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D<br>dmsetup create linear_loop1 =
/tmp/linear_loop1<br><br>cat /tmp/linear_loop1<br>0 1000 linear =
/dev/loop1 0<br><br><o:p></o:p></p><p class=3DMsoListParagraph =
style=3D'mso-margin-top-alt:0cm;margin-right:0cm;margin-bottom:0cm;margin=
-left:36.0pt;margin-bottom:.0001pt;text-align:left;text-indent:-18.0pt;ms=
o-list:l0 level1 lfo2;direction:ltr;unicode-bidi:embed'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>2.<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]><span dir=3DLTR></span>Then creating another =
linear device over this linear =
device:<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<=
br>dmsetup create linear_loop2 /tmp/linear_loop2<br><br>device-mapper: =
reload ioctl failed: Invalid argument<br>Command failed<br><br>cat =
/tmp/klinear_loop2<br>0 1000 linear /dev/linear_loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Could you =
please explain what am I doing wrong?<o:p></o:p></p></div></body></html>
------_=_NextPart_001_01CBFA83.3CA25E54--


--===============4766342916176957600==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4766342916176957600==--
