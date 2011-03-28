From: "Eli Malul" <eli.malul@kaminario.com>
Subject: mirror target memory consumption
Date: Mon, 28 Mar 2011 18:54:27 +0300
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD301951568@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0992346506077495765=="
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

--===============0992346506077495765==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBED60.6C40A8E9"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBED60.6C40A8E9
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Could someone please help out with this? This memory consumption is
preventing me from working with the device mapper...

=20

I created a mapped device with a table consisting 10, 20 and 30 mirror
targets to examine the memory consumption.

You can see that the memory consumption is very high (in terms of mega).

=20

I also verified that CONFIG_BLK_DEV_INTEGRITY is disabled.

=20

Do you have any idea why does a mirror target consumes so much memory?

=20

For 10 mirror targets the memory consumption is ~7M:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[root@vpc09 ~]# free -m

total      used       free     shared   buffers cached

Mem:                                    7837      566          7271    0
105        372

-/+ buffers/cache:                           88           7749

Swap:                                    0              0              0

[root@vpc09 ~]# dmsetup create mirror_dev /tmp/mirror_core_sync_10.txt

[root@vpc09 ~]# free -m

total       used      free     shared    buffers  cached

Mem:                                    7837       573         7264    0
105        372

-/+ buffers/cache:                           95           7742

Swap:                                    0              0              0

=20

For 20 mirror targets the memory consumption is ~12M:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[root@vpc09 ~]# dmsetup remove mirror_dev

[root@vpc09 ~]# free -m

total      used       free     shared   buffers cached

Mem:                                    7837      566          7271    0
105        372

-/+ buffers/cache:                           89           7749

Swap:                                    0              0              0

=20

[root@vpc09 ~]# dmsetup create mirror_dev /tmp/mirror_core_sync_20.txt

[root@vpc09 ~]# free -m

total      used       free     shared   buffers cached

Mem:                                    7837      580          7257    0
106        372

-/+ buffers/cache:                           101         7736

Swap:                                    0              0              0

=20

For 30 mirror targets the memory consumption is ~19M:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[root@vpc09 ~]# dmsetup remove mirror_dev

[root@vpc09 ~]# free -m

total      used       free     shared   buffers cached

Mem:                                    7837      568          7269    0
106        372

-/+ buffers/cache:                           89           7748

Swap:                                    0              0              0

=20

[root@vpc09 ~]# dmsetup create mirror_dev /tmp/mirror_core_sync_30.txt

[root@vpc09 ~]# free -m

total      used       free     shared   buffers cached

Mem:                                    7837      587          7250    0
106        372

-/+ buffers/cache:                           108         7729

Swap:                                    0              0              0

=20

This is how the mapped file table looks like (you get the picture for
the other 20 and 30 target files):

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D

[root@vpc09 ~]# cat /tmp/mirror_core_sync_10.txt

0 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

8 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

16 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

24 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

32 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

40 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

48 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

56 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

64 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0

72 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0


------_=_NextPart_001_01CBED60.6C40A8E9
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
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
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Could someone =
please help out with this? This memory consumption is preventing me from =
working with the device mapper&#8230;<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>I created a =
mapped device with a table consisting 10, 20 and 30 mirror targets to =
examine the memory consumption.<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>You can see =
that the memory consumption is very high (in terms of =
mega).<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>I also =
verified that CONFIG_BLK_DEV_INTEGRITY is disabled.<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Do you have =
any idea why does a mirror target consumes so much =
memory?<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>For 10 mirror =
targets the memory consumption is ~7M:<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# free &#8211;m<o:p></o:p></p><p class=3DMsoNormal =
style=3D'margin-left:72.0pt;text-align:left;text-indent:36.0pt;direction:=
ltr;unicode-bidi:embed'>total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; =
shared&nbsp;&nbsp; buffers cached<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Mem:&nbsp;&nbs=
p; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
7837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 566&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp; &nbsp;7271&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
105&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 372<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>-/+ =
buffers/cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 88&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 7749<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Swap:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# dmsetup create mirror_dev =
/tmp/mirror_core_sync_10.txt<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# free -m<o:p></o:p></p><p class=3DMsoNormal =
style=3D'margin-left:72.0pt;text-align:left;text-indent:36.0pt;direction:=
ltr;unicode-bidi:embed'>total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; =
shared&nbsp;&nbsp;&nbsp; buffers&nbsp; cached<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Mem:&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 7837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
573&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 7264&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
105&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 372<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>-/+ =
buffers/cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 95&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 7742<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Swap:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>For 20 mirror =
targets the memory consumption is ~12M:<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# dmsetup remove mirror_dev<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# free &#8211;m<o:p></o:p></p><p class=3DMsoNormal =
style=3D'margin-left:72.0pt;text-align:left;text-indent:36.0pt;direction:=
ltr;unicode-bidi:embed'>total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; =
shared&nbsp;&nbsp; buffers cached<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Mem:&nbsp;&nbs=
p; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
7837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 566&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp; &nbsp;7271&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
105&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 372<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>-/+ =
buffers/cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 89&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 7749<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Swap:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# dmsetup create mirror_dev =
/tmp/mirror_core_sync_20.txt<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# free &#8211;m<o:p></o:p></p><p class=3DMsoNormal =
style=3D'margin-left:72.0pt;text-align:left;text-indent:36.0pt;direction:=
ltr;unicode-bidi:embed'>total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; =
shared&nbsp;&nbsp; buffers cached<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Mem:&nbsp;&nbs=
p; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
7837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 580&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp; &nbsp;7257&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
106&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 372<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>-/+ =
buffers/cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 101&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp; 7736<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Swap:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>For 30 mirror =
targets the memory consumption is ~19M:<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# dmsetup remove mirror_dev<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# free &#8211;m<o:p></o:p></p><p class=3DMsoNormal =
style=3D'margin-left:72.0pt;text-align:left;text-indent:36.0pt;direction:=
ltr;unicode-bidi:embed'>total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; =
shared&nbsp;&nbsp; buffers cached<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Mem:&nbsp;&nbs=
p; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
7837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 568&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp; &nbsp;7269&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
106&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 372<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>-/+ =
buffers/cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 89&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 7748<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Swap:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# dmsetup create mirror_dev =
/tmp/mirror_core_sync_30.txt<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# free &#8211;m<o:p></o:p></p><p class=3DMsoNormal =
style=3D'margin-left:72.0pt;text-align:left;text-indent:36.0pt;direction:=
ltr;unicode-bidi:embed'>total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free&nbsp;&nbsp;&nbsp;&nbsp; =
shared&nbsp;&nbsp; buffers cached<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Mem:&nbsp;&nbs=
p; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
7837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 587&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp; &nbsp;7250&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
106&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 372<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>-/+ =
buffers/cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 108&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp; 7729<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>Swap:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'><o:p>&nbsp;</o=
:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>This is how =
the mapped file table looks like (you get the picture for the other 20 =
and 30 target files):<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:p></o:p=
></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>[root@vpc09 =
~]# cat /tmp/mirror_core_sync_10.txt<o:p></o:p></p><p class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>0 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>8 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>16 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>24 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>32 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>40 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>48 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>56 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>64 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0<o:p></o:p></p><p =
class=3DMsoNormal =
style=3D'text-align:left;direction:ltr;unicode-bidi:embed'>72 8 mirror =
core 2 8 sync 2 /dev/loop0 0 /dev/loop1 =
0<o:p></o:p></p></div></body></html>
------_=_NextPart_001_01CBED60.6C40A8E9--


--===============0992346506077495765==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0992346506077495765==--
