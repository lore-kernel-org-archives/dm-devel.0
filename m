From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 01/11] multipath-tools: add support for all
 IBM Enterprise Storage Server / Shark family
Date: Tue, 16 Aug 2016 09:50:15 +0200
Message-ID: <CABr-Gneur++JXv70qXrv0SzM5kRp+Hy3jci9tXvv06WDbeR2jw@mail.gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7537946468913596728=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
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

--===============7537946468913596728==
Content-Type: multipart/alternative; boundary=001a1142c130787e76053a2b996a

--001a1142c130787e76053a2b996a
Content-Type: text/plain; charset=UTF-8

This set is merged.
Thanks.

On Thu, Aug 11, 2016 at 8:32 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Only F20 and 800 were included:
> 2105F20 IBM Enterprise Storage Server Model F20
> 2105800 IBM TotalStorage Enterprise Storage Server Model 800
>
> Added all of them with just "^2105"
> 2105E10 IBM Enterprise Storage Server Model E10
> 2105E20 IBM Enterprise Storage Server Model E20
> 2105F10 IBM Enterprise Storage Server Model F10
> 2105750 IBM TotalStorage Enterprise Storage Server Model 750
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index edfd8fe..cd052e4 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -444,17 +444,9 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* Enterprise Storage Server / Shark 800 */
> +               /* Enterprise Storage Server / Shark family */
>                 .vendor        = "IBM",
> -               .product       = "^2105800",
> -               .features      = "1 queue_if_no_path",
> -               .pgpolicy      = GROUP_BY_SERIAL,
> -               .pgfailback    = FAILBACK_UNDEF,
> -       },
> -       {
> -               /* Enterprise Storage Server / Shark F20 */
> -               .vendor        = "IBM",
> -               .product       = "^2105F20",
> +               .product       = "^2105",
>                 .features      = "1 queue_if_no_path",
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = FAILBACK_UNDEF,
> --
> 2.7.4
>
>

--001a1142c130787e76053a2b996a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This set is merged.<div>Thanks.</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Thu, Aug 11, 2016 at 8:32 PM,=
 Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gm=
ail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br>=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Only F20 and 800 were included:<br>
2105F20 IBM Enterprise Storage Server Model F20<br>
2105800 IBM TotalStorage Enterprise Storage Server Model 800<br>
<br>
Added all of them with just &quot;^2105&quot;<br>
2105E10 IBM Enterprise Storage Server Model E10<br>
2105E20 IBM Enterprise Storage Server Model E20<br>
2105F10 IBM Enterprise Storage Server Model F10<br>
2105750 IBM TotalStorage Enterprise Storage Server Model 750<br>
<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt=
;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 12 ++----------<br>
=C2=A01 file changed, 2 insertions(+), 10 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index edfd8fe..cd052e4 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -444,17 +444,9 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D FAILBACK_UNDEF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Enterprise Stora=
ge Server / Shark 800 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Enterprise Stora=
ge Server / Shark family */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^2105800&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.features=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;1 queue_if_no_path&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_SERIAL,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =
=C2=A0 =3D FAILBACK_UNDEF,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Enterprise Stora=
ge Server / Shark F20 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^2105F20&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^2105&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .features=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;1 queue_if_no_path&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_SERIAL,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D FAILBACK_UNDEF,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142c130787e76053a2b996a--


--===============7537946468913596728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7537946468913596728==--
