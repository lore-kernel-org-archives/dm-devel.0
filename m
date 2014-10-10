From: Pavitra Kumar <pavitrak@nvidia.com>
Subject: Subject: [PATCH] dm stripe: fixed resource leak of sc
Date: Fri, 10 Oct 2014 15:19:46 +0000
Message-ID: <157461d0595944edb529638bf9ea3ec2@bgmail102.nvidia.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7869201095600970316=="
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
To: "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============7869201095600970316==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_157461d0595944edb529638bf9ea3ec2bgmail102nvidiacom_"

--_000_157461d0595944edb529638bf9ea3ec2bgmail102nvidiacom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Fixed the resource leak of sc in case the chunk size
exceeds the limit at dm_set_target_max_io_len.

Signed-off-by: Pavitrakumar <pavitrak@nvidia.com>
---
drivers/md/dm-stripe.c | 4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index d1600d2..f8b37d4 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -159,8 +159,10 @@ static int stripe_ctr(struct dm_target *ti, unsigned=
=20int argc, char **argv)
=20                              sc->stripes_shift =3D __ffs(stripes);
=20               r =3D dm_set_target_max_io_len(ti, chunk_size);
-              if (r)
+             if (r) {
+                             kfree(sc);
=20                              return r;
+             }
=20               ti->num_flush_bios =3D stripes;
=20              ti->num_discard_bios =3D stripes;
--
1.8.1.5

-------------------------------------------------------------------------=
----------
This email message is for the sole use of the intended recipient(s) and m=
ay contain
confidential information.  Any unauthorized review, use, disclosure or di=
stribution
is prohibited.  If you are not the intended recipient, please contact the=
=20sender by
reply email and destroy all copies of the original message.
-------------------------------------------------------------------------=
----------

--_000_157461d0595944edb529638bf9ea3ec2bgmail102nvidiacom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-mi=
crosoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:wo=
rd" xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D=
"http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-asci=
i">
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">=

<style><!--
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
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Fixed the resource leak of sc in case the chunk si=
ze<o:p></o:p></p>
<p class=3D"MsoNormal">exceeds the limit at dm_set_target_max_io_len.<o:p=
></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Signed-off-by: Pavitrakumar &lt;pavitrak@nvidia.co=
m&gt;<o:p></o:p></p>
<p class=3D"MsoNormal">---<o:p></o:p></p>
<p class=3D"MsoNormal">drivers/md/dm-stripe.c | 4 &#43;&#43;&#43;-<o:p></=
o:p></p>
<p class=3D"MsoNormal">1 file changed, 3 insertions(&#43;), 1 deletion(-)=
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">diff --git a/drivers/md/dm-stripe.c b/drivers/md/d=
m-stripe.c<o:p></o:p></p>
<p class=3D"MsoNormal">index d1600d2..f8b37d4 100644<o:p></o:p></p>
<p class=3D"MsoNormal">--- a/drivers/md/dm-stripe.c<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&#43;&#43; b/drivers/md/dm-stripe.c<o:p></o:p=
></p>
<p class=3D"MsoNormal">@@ -159,8 &#43;159,10 @@ static int stripe_ctr(str=
uct dm_target *ti, unsigned int argc, char **argv)<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sc-&gt;stripes_=
shift =3D __ffs(stripes);<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D dm_set_target_max_io_len(t=
i, chunk_size);<o:p></o:p></p>
<p class=3D"MsoNormal">-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r)<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; if (r) {<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kfree(sc);<o:p></o:p><=
/p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return r;<o:p><=
/o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;num_flush_bios =3D stripe=
s;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;num_discard_bios =3D stripes;<o=
:p></o:p></p>
<p class=3D"MsoNormal">-- <o:p></o:p></p>
<p class=3D"MsoNormal">1.8.1.5<o:p></o:p></p>
</div>

<DIV>
<HR>
</DIV>
<DIV>This email message is for the sole use of the intended recipient(s) =
and may=20
contain confidential information.&nbsp; Any unauthorized review, use, dis=
closure=20
or distribution is prohibited.&nbsp; If you are not the intended recipien=
t,=20
please contact the sender by reply email and destroy all copies of the or=
iginal=20
message. </DIV>
<DIV>
<HR>
</DIV>
</body>
</html>

--_000_157461d0595944edb529638bf9ea3ec2bgmail102nvidiacom_--


--===============7869201095600970316==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7869201095600970316==--
