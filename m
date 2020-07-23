From: lutianxiong <lutianxiong@huawei.com>
Subject: libmultipath: fix null dereference
Date: Thu, 23 Jul 2020 01:11:47 +0000
Message-ID: <B8F26E5D3A1269458BE7CD6D60E9885F7A369633@dggemm531-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3443771905671819030=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Liaoqingwei <liaoqingwei@huawei.com>
List-Id: dm-devel.ids

--===============3443771905671819030==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_B8F26E5D3A1269458BE7CD6D60E9885F7A369633dggemm531mbxchi_"

--_000_B8F26E5D3A1269458BE7CD6D60E9885F7A369633dggemm531mbxchi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi
I got a multipath segfault while running iscsi login/logout and following s=
cripts in parallel:

#!/bin/bash

interval=3D1
while true
do
              multipath -F &> /dev/null
              multipath -r &> /dev/null
              multipath -v2 &> /dev/null
              multipath -ll &> /dev/null
              sleep $interval
done

This is the debuginfo:
#0  0x00007f3805e4df58 in add (ctx=3D0x55d1569e4a00, ud=3D0x55d1569bafd0) a=
t nvme.c:801
801              if (strcmp("disk", udev_device_get_devtype(ud)))
(gdb) bt
#0  0x00007f3805e4df58 in add (ctx=3D0x55d1569e4a00, ud=3D0x55d1569bafd0) a=
t nvme.c:801
#1  0x00007f3806687a44 in add_foreign (udev=3D0x55d1569bafd0) at foreign.c:=
299
#2  0x00007f3806665abf in is_claimed_by_foreign (ud=3D<optimized out>) at f=
oreign.h:316
#3  pathinfo (pp=3D0x55d1569e9f50, conf=3D0x55d1569b92d0, mask=3D69) at dis=
covery.c:2064
#4  0x000055d154c91cbb in check_usable_paths (conf=3D0x55d1569b92d0, devpat=
h=3D0x55d1569e3200 "dm-6", dev_type=3D<optimized out>) at main.c:368
#5  0x000055d154c910a5 in main (argc=3D3, argv=3D<optimized out>) at main.c=
:1057

In add() at libmultipath/foreign/nvme.c, udev_device_get_devtype(ud) return=
 a NULL pointer then dereferenced.
Here, NULL check is needed.



Check if udev_device_get_devtype return NULL before dereferencing it.

Signed-off-by: lutianxiong <lutianxiong@huawei.com>
---
libmultipath/foreign/nvme.c | 4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 09cdddf0..f1da1dcd 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -793,12 +793,14 @@ int add(struct context *ctx, struct udev_device *ud)
{
        struct udev_device *subsys;
        int rc;
+       const char *devtype;

        condlog(5, "%s called for \"%s\"", __func__, THIS);

        if (ud =3D=3D NULL)
                return FOREIGN_ERR;
-       if (strcmp("disk", udev_device_get_devtype(ud)))
+       if ((devtype =3D udev_device_get_devtype(ud)) =3D=3D NULL ||
+                       strcmp("disk", devtype))
                return FOREIGN_IGNORED;

        subsys =3D udev_device_get_parent_with_subsystem_devtype(ud,
--
2.23.0

--_000_B8F26E5D3A1269458BE7CD6D60E9885F7A369633dggemm531mbxchi_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
=09{font-family:SimSun;
=09panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
=09{font-family:SimSun;
=09panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0cm;
=09margin-bottom:.0001pt;
=09text-align:justify;
=09text-justify:inter-ideograph;
=09font-size:10.5pt;
=09font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:#0563C1;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:#954F72;
=09text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
=09{mso-style-priority:99;
=09mso-style-link:"\7EAF\6587\672C Char";
=09margin:0cm;
=09margin-bottom:.0001pt;
=09font-size:10.5pt;
=09font-family:"Calibri",sans-serif;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri",sans-serif;
=09color:windowtext;}
span.Char
=09{mso-style-name:"\7EAF\6587\672C Char";
=09mso-style-priority:99;
=09mso-style-link:\7EAF\6587\672C;
=09font-family:"Calibri",sans-serif;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri",sans-serif;}
/* Page Definitions */
@page WordSection1
=09{size:612.0pt 792.0pt;
=09margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
=09{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"text-justi=
fy-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">Hi<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">I go=
t a multipath segfault while running iscsi login/logout and following scrip=
ts in parallel:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">#=
!/bin/bash<o:p></o:p></span></i></p>
<p class=3D"MsoPlainText"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt=
">interval=3D1<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">w=
hile true<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">d=
o<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; multipath -F &amp;&gt; /dev/null<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; multipath -r &amp;&gt; /dev/null<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; multipath -v2 &amp;&gt; /dev/null<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; multipath -ll &amp;&gt; /dev/null<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; sleep $interval<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><i><span lang=3D"EN-US" style=3D"font-size:14.0pt">d=
one<o:p></o:p></span></i></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">This=
 is the debuginfo:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#0&n=
bsp; 0x00007f3805e4df58 in add (ctx=3D0x55d1569e4a00, ud=3D0x55d1569bafd0) =
at nvme.c:801<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">801&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; if (strcmp(&quot;disk&quot;, udev_device_get_devtype(ud)))<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">(gdb=
) bt<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#0&n=
bsp; 0x00007f3805e4df58 in add (ctx=3D0x55d1569e4a00, ud=3D0x55d1569bafd0) =
at nvme.c:801<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#1&n=
bsp; 0x00007f3806687a44 in add_foreign (udev=3D0x55d1569bafd0) at foreign.c=
:299<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#2&n=
bsp; 0x00007f3806665abf in is_claimed_by_foreign (ud=3D&lt;optimized out&gt=
;) at foreign.h:316<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#3&n=
bsp; pathinfo (pp=3D0x55d1569e9f50, conf=3D0x55d1569b92d0, mask=3D69) at di=
scovery.c:2064<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#4&n=
bsp; 0x000055d154c91cbb in check_usable_paths (conf=3D0x55d1569b92d0, devpa=
th=3D0x55d1569e3200 &quot;dm-6&quot;, dev_type=3D&lt;optimized out&gt;) at =
main.c:368<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">#5&n=
bsp; 0x000055d154c910a5 in main (argc=3D3, argv=3D&lt;optimized out&gt;) at=
 main.c:1057<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">In a=
dd() at </span>
<span lang=3D"EN-US" style=3D"font-size:14.0pt">libmultipath/foreign/nvme.c=
, udev_device_get_devtype(ud) return a NULL pointer then
</span><span lang=3D"EN-US" style=3D"font-size:14.0pt">dereferenced.<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">Here=
, NULL check is needed.</span><span lang=3D"EN-US" style=3D"font-size:14.0p=
t"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">Chec=
k if udev_device_get_devtype return NULL before dereferencing it.<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">Sign=
ed-off-by: lutianxiong &lt;lutianxiong@huawei.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">---<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">libm=
ultipath/foreign/nvme.c | 4 &#43;&#43;&#43;-<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">1 fi=
le changed, 3 insertions(&#43;), 1 deletion(-)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">diff=
 --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">inde=
x 09cdddf0..f1da1dcd 100644<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">--- =
a/libmultipath/foreign/nvme.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&#43=
;&#43;&#43; b/libmultipath/foreign/nvme.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">@@ -=
793,12 &#43;793,14 @@ int add(struct context *ctx, struct udev_device *ud)<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">{<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct udev_device *subsys;<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int rc;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&#43=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const char *devtype;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; condlog(5, &quot;%s called for \&quo=
t;%s\&quot;&quot;, __func__, THIS);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ud =3D=3D NULL)<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; return FOREIGN_ERR;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">-&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (strcmp(&quot;disk&quot;, udev_device_=
get_devtype(ud)))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&#43=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((devtype =3D udev_device_get_devt=
ype(ud)) =3D=3D NULL ||<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&#43=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; strcmp(&quot;dis=
k&quot;, devtype))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; return FOREIGN_IGNORED;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt"><o:p=
>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; subsys =3D udev_device_get_parent_wi=
th_subsystem_devtype(ud,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">--<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:14.0pt">2.23=
.0<o:p></o:p></span></p>
</div>
</body>
</html>

--_000_B8F26E5D3A1269458BE7CD6D60E9885F7A369633dggemm531mbxchi_--

--===============3443771905671819030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3443771905671819030==--
