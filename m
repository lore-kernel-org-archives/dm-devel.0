From: James Shoemaker <james@dhlake.com>
Subject: libmultipath issue
Date: Tue, 13 Jun 2017 11:19:51 -0500
Message-ID: <CALRmJ1uB6SA_ct7O-2XxQthWmXZpLhnJ0sAj3tc0kmTxkGu9LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1341285766129863132=="
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

--===============1341285766129863132==
Content-Type: multipart/alternative; boundary="001a113979e038e49d0551d9ce91"

--001a113979e038e49d0551d9ce91
Content-Type: text/plain; charset="UTF-8"

   I have a piece of hardware, a 16 bay storagetek  optically connected SAN
to
be specific, that returns empty string for Device id.

   I did the following patch to resolve the issue, it basically allows empty
string for vendor and product, I couldn't find anywhere that had an issue
with
it..

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8ea..92d0e49 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1149,12 +1149,12 @@ scsi_sysfs_pathinfo (struct path * pp, vector
hwtable)
        if (!attr_path || pp->sg_id.host_no == -1)
                return 1;

-       if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
+       if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) < 0)
                return 1;

        condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);

-       if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <= 0)
+       if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) < 0)
                return 1;

        condlog(3, "%s: product = %s", pp->dev, pp->product_id);

--001a113979e038e49d0551d9ce91
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:12.8px">=C2=A0 =C2=A0I have a pie=
ce of hardware, a 16 bay storagetek=C2=A0 optically connected SAN to</span>=
<br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">be specific=
, that returns empty string for Device id.</span><br style=3D"font-size:12.=
8px"><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">=C2=A0=
 =C2=A0I did the following patch to resolve the issue, it basically allows =
empty</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px"=
>string for vendor and product, I couldn&#39;t find anywhere that had an is=
sue with</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8=
px">it..</span><br style=3D"font-size:12.8px"><br style=3D"font-size:12.8px=
"><span style=3D"font-size:12.8px">diff --git a/libmultipath/discovery.c b/=
libmultipath/discovery.c</span><br style=3D"font-size:12.8px"><span style=
=3D"font-size:12.8px">index 663c8ea..92d0e49 100644</span><br style=3D"font=
-size:12.8px"><span style=3D"font-size:12.8px">--- a/libmultipath/discovery=
.c</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">++=
+ b/libmultipath/discovery.c</span><br style=3D"font-size:12.8px"><span sty=
le=3D"font-size:12.8px">@@ -1149,12 +1149,12 @@ scsi_sysfs_pathinfo (struct=
 path * pp, vector hwtable)</span><br style=3D"font-size:12.8px"><span styl=
e=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!attr_path || pp-&gt=
;sg_id.host_no =3D=3D -1)</span><br style=3D"font-size:12.8px"><span style=
=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return 1;</span><br style=3D"font-size:12.8px"><br style=3D"font-size:1=
2.8px"><span style=3D"font-size:12.8px">-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sys=
fs_get_vendor(parent, pp-&gt;vendor_id, SCSI_VENDOR_SIZE) &lt;=3D 0)</span>=
<br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">+=C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (sysfs_get_vendor(parent, pp-&gt;vendor_id, SCSI_VENDOR=
_SIZE) &lt; 0)</span><br style=3D"font-size:12.8px"><span style=3D"font-siz=
e:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;=
</span><br style=3D"font-size:12.8px"><br style=3D"font-size:12.8px"><span =
style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s:=
 vendor =3D %s&quot;, pp-&gt;dev, pp-&gt;vendor_id);</span><br style=3D"fon=
t-size:12.8px"><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8=
px">-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sysfs_get_model(parent, pp-&gt;product_=
id, SCSI_PRODUCT_SIZE) &lt;=3D 0)</span><br style=3D"font-size:12.8px"><spa=
n style=3D"font-size:12.8px">+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sysfs_get_mode=
l(parent, pp-&gt;product_id, SCSI_PRODUCT_SIZE) &lt; 0)</span><br style=3D"=
font-size:12.8px"><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;</span><br style=3D"font-size:12.8=
px"><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: product =3D %s&quot;, pp-&gt;dev,=
 pp-&gt;product_id);</span><br style=3D"font-size:12.8px"></div>

--001a113979e038e49d0551d9ce91--


--===============1341285766129863132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1341285766129863132==--
