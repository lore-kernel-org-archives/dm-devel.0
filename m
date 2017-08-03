From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add HPE StoreVirtual 3200
	family to hwtable
Date: Thu, 3 Aug 2017 08:48:14 +0200
Message-ID: <CABr-Gnetf8BFR_MLL6L1GBC-UFqzDJMA_4W9Ns75YxZC-fiWvg@mail.gmail.com>
References: <20170707135545.3645-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6662817513213434565=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170707135545.3645-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6662817513213434565==
Content-Type: multipart/alternative; boundary="001a113d29d4ccd6a60555d3c39c"

--001a113d29d4ccd6a60555d3c39c
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Fri, Jul 7, 2017 at 3:55 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> It's a new LEFTHAND array.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 390d143..4acaeee 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -147,9 +147,9 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* StoreVirtual 4000 family */
> +               /* StoreVirtual 4000 and 3200 families */
>                 .vendor        = "LEFTHAND",
> -               .product       = "^(P4000|iSCSIDisk)",
> +               .product       = "(P4000|iSCSIDisk|FCDISK)",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .no_path_retry = 18,
> --
> 2.13.2
>
>

--001a113d29d4ccd6a60555d3c39c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Jul 7, 2017 at 3:55 PM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">It&#39;s a new LEFTHAND array.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 4 ++--<br>
=C2=A01 file changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 390d143..4acaeee 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -147,9 +147,9 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* StoreVirtual 400=
0 family */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* StoreVirtual 400=
0 and 3200 families */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;LEFTHAND&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^(P4000|iSCSIDisk)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;(P4000|iSCSIDisk|FCDISK)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
18,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a113d29d4ccd6a60555d3c39c--


--===============6662817513213434565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6662817513213434565==--
