From: "Eli Malul" <eli.malul@kaminario.com>
Subject: FW: creating a cascaded linear devices fails - please
	ignore previous mail
Date: Thu, 14 Apr 2011 13:01:32 +0300
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD3019D4994@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8981763087852819466=="
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

--===============8981763087852819466==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBFA8A.EEE423EE"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBFA8A.EEE423EE
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

My mistake, please ignore

=20

From: Eli Malul=20
Sent: Thursday, April 14, 2011 12:06 PM
To: 'dm-devel@redhat.com'
Subject: creating a cascaded linear devices fails

=20

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


------_=_NextPart_001_01CBFA8A.EEE423EE
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><META =
HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 12 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle19
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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
@list l0:level2
	{mso-level-tab-stop:72.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level3
	{mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level4
	{mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level5
	{mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level6
	{mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level7
	{mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level8
	{mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level9
	{mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
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
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'>My mistake, please =
ignore<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><div><div =
style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0cm =
0cm 0cm'><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><b><span =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>From:</span>=
</b><span style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'> =
Eli Malul <br><b>Sent:</b> Thursday, April 14, 2011 12:06 =
PM<br><b>To:</b> 'dm-devel@redhat.com'<br><b>Subject:</b> creating a =
cascaded linear devices fails<o:p></o:p></span></p></div></div><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'margin-bottom:12.0pt;text-align:left;direction:ltr;unicode-bidi:=
embed'>I do not understand why creating a linear device and then trying =
to create another linear device on top of it fails.<o:p></o:p></p><p =
class=3DMsoListParagraph =
style=3D'mso-margin-top-alt:0cm;margin-right:0cm;margin-bottom:12.0pt;mar=
gin-left:36.0pt;text-align:left;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2;direction:ltr;unicode-bidi:embed'><![if !supportLists]><span =
style=3D'mso-list:Ignore'>1.<span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]><span dir=3DLTR></span>Creating a linear device =
over =
loop1:<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D<br>dmsetup create linear_loop1 =
/tmp/linear_loop1<br><br>cat /tmp/linear_loop1<br>0 1000 linear =
/dev/loop1 0<o:p></o:p></p><p class=3DMsoListParagraph =
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
------_=_NextPart_001_01CBFA8A.EEE423EE--


--===============8981763087852819466==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8981763087852819466==--
