From: "Eli Malul" <eli.malul@kaminario.com>
Subject: mirrored device with thousand of mapping table entries
Date: Mon, 28 Feb 2011 13:21:10 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7608405501018611793=="
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

--===============7608405501018611793==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBD739.9A95C048"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBD739.9A95C048
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

I am trying to create a mirrored device with thousand of mapping table
entries.

=20

Unfortunately, it seems that the allocated kernel memory to satisfy this
configuration is unbearable - I am talking about 6G for 10,000 entries
where the used region size is for each entry is minimal (i.e. 8 blocks).

=20

My questions are as follows:

1.       Did anyone tried before to create a mirrored device with
thousands of targets?

2.       What is the estimated total allocated memory per each target?

3.       Is there something I am missing here?

=20

Thanks a lot,

Eli


------_=_NextPart_001_01CBD739.9A95C048
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
	{mso-list-id:169951139;
	mso-list-type:hybrid;
	mso-list-template-ids:486447756 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:none;
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
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Hi,<o:p></o:p>=
</p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>I am trying =
to create a mirrored device with thousand of mapping table =
entries.<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Unfortunately,=
 it seems that the allocated kernel memory to satisfy this configuration =
is unbearable - I am talking about 6G for 10,000 entries where the used =
region size is for each entry is minimal (i.e. 8 =
blocks).<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>My questions =
are as follows:<o:p></o:p></p><p class=3DMsoListParagraph =
style=3D'mso-margin-top-alt:0cm;margin-right:0cm;margin-bottom:0cm;margin=
-left:36.0pt;margin-bottom:.0001pt;text-align:left;text-indent:-18.0pt;ms=
o-list:l0 level1 lfo1;direction:ltr;unicode-bidi:embed'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>1.<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]><span dir=3DLTR></span>Did anyone tried before =
to create a mirrored device with thousands of targets?<o:p></o:p></p><p =
class=3DMsoListParagraph =
style=3D'mso-margin-top-alt:0cm;margin-right:0cm;margin-bottom:0cm;margin=
-left:36.0pt;margin-bottom:.0001pt;text-align:left;text-indent:-18.0pt;ms=
o-list:l0 level1 lfo1;direction:ltr;unicode-bidi:embed'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>2.<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]><span dir=3DLTR></span>What is the estimated =
total allocated memory per each target?<o:p></o:p></p><p =
class=3DMsoListParagraph =
style=3D'mso-margin-top-alt:0cm;margin-right:0cm;margin-bottom:0cm;margin=
-left:36.0pt;margin-bottom:.0001pt;text-align:left;text-indent:-18.0pt;ms=
o-list:l0 level1 lfo1;direction:ltr;unicode-bidi:embed'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>3.<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]><span dir=3DLTR></span>Is there something I am =
missing here?<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Thanks a =
lot,<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Eli<o:p></o:p>=
</p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'> =
<o:p></o:p></p></div></body></html>
------_=_NextPart_001_01CBD739.9A95C048--


--===============7608405501018611793==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7608405501018611793==--
