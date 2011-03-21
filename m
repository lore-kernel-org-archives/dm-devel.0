From: "Eli Malul" <eli.malul@kaminario.com>
Subject: FW: the mirror log is NOT kept on disk
Date: Mon, 21 Mar 2011 15:10:12 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD301950E1B@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4581467728260145647=="
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

--===============4581467728260145647==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBE7C9.50087275"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBE7C9.50087275
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I just saw that clean_bits is being saved to the disk and is used to
update sync_bits after crash/reboot (although the default behavior is to
reset all the bits hence, resync is done for each resume).

=20

But I still do not understand how should I create a mapped device with
dmsetup tool which wouldl survive crash/reboot.

=20

Can anyone help?

=20

From: Eli Malul=20
Sent: Sunday, March 20, 2011 6:19 PM
To: 'dm-devel@redhat.com'
Subject: the mirror log is NOT kept on disk

=20

Hi,

=20

I tried a small test where I suspended and resumed a mirrored device
without IO going on.

My expectation was that the mirror set will not get re-synced but
unfortunately it did.

=20

According the documentation the mirror log is kept on disk when creating
a mirror logical device with 'disk' log type as an input parameter.

I looked at the code and I didn't see where the sync_bits are being
written to the disk or read from the disk but only the number of regions
is being saved.

=20

How should a mirror device survive reboots/crashes without syncing the
entire mirror set?

=20

BTW - another problem is that after reboot the created logical device
disappears, is there an easy way to keep it persistent or should I
create at each boot?

=20


------_=_NextPart_001_01CBE7C9.50087275
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
span.EmailStyle17
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle18
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
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'>I just saw that clean_bits is being saved to the =
disk and is used to update sync_bits after crash/reboot (although the =
default behavior is to reset all the bits hence, resync is done for each =
resume).<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'>But I still do not understand how should I =
create a mapped device with dmsetup tool which wouldl survive =
crash/reboot.<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'>Can anyone help?<o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p><div><div =
style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0cm =
0cm 0cm'><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><b><span =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>From:</span>=
</b><span style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'> =
Eli Malul <br><b>Sent:</b> Sunday, March 20, 2011 6:19 PM<br><b>To:</b> =
'dm-devel@redhat.com'<br><b>Subject:</b> the mirror log is NOT kept on =
disk<o:p></o:p></span></p></div></div><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Hi,<o:p></o:p>=
</p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>I tried a =
small test where I suspended and resumed a mirrored device without IO =
going on.<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>My =
expectation was that the mirror set will not get re-synced but =
unfortunately it did.<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>According the =
documentation the mirror log is kept on disk when creating a mirror =
logical device with 'disk' log type as an input =
parameter.<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>I looked at =
the code and I didn't see where the sync_bits are being written to the =
disk or read from the disk but only the number of regions is being =
saved.<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>How should a =
mirror device survive reboots/crashes without syncing the entire mirror =
set?<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>BTW &#8211; =
another problem is that after reboot the created logical device =
disappears, is there an easy way to keep it persistent or should I =
create at each boot?<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p></div></body></html>
------_=_NextPart_001_01CBE7C9.50087275--


--===============4581467728260145647==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4581467728260145647==--
