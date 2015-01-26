From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: dm_mirror/dm_raid1 limitations ?.
Date: Mon, 26 Jan 2015 05:51:43 -0800 (PST)
Message-ID: <4d982ea8-3769-46d2-ba73-2d1525faa63b@default>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1617046755302804762=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============1617046755302804762==
Content-Type: multipart/alternative;
	boundary="__142228030742528457abhmp0019.oracle.com"

--__142228030742528457abhmp0019.oracle.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Use case is : Two luns are mapped from storage array to linux host which ar=
e in same SAN fabric . we want to create a mirror on the linux host with th=
ese two luns and let  host use that mirror lun .  basic tests suggest that =
dm_mirror working fine . when we have any intermittent path issues with bet=
ween host and san array , host i/o just freeze , never returns back even af=
ter the path is online. =20

=20

Is dm_mirror viable solution here  ?. Can you point me any link which gives=
 the limitations of dm_mirror ? . another alternate solutions you propose h=
ere ?. Thanks in advance .

=20

Thanks

/Suresh

--__142228030742528457abhmp0019.oracle.com
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><meta http-equiv=3DContent-Type content=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 14 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:purple;
=09text-decoration:underline;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri","sans-serif";
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri","sans-serif";}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Use case is : Tw=
o luns are mapped from storage array to linux host which are in same SAN fa=
bric . we want to create a mirror on the linux host with these two luns and=
 let&nbsp; host use that mirror lun .&nbsp; basic tests suggest that dm_mir=
ror working fine . when we have any intermittent path issues with between h=
ost and san array , host i/o just freeze , never returns back even after th=
e path is online.&nbsp; <o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:=
p></p><p class=3DMsoNormal>Is dm_mirror viable solution here &nbsp;?. Can y=
ou point me any link which gives the limitations of dm_mirror ? . another a=
lternate solutions you propose here ?. Thanks in advance .<o:p></o:p></p><p=
 class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Thanks<o:p></o=
:p></p><p class=3DMsoNormal>/Suresh<o:p></o:p></p></div></body></html>
--__142228030742528457abhmp0019.oracle.com--


--===============1617046755302804762==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1617046755302804762==--
