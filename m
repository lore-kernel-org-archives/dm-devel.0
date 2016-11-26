From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: remove NO_PATH_RETRY_FAIL
	from hwtable
Date: Sat, 26 Nov 2016 09:59:00 +0100
Message-ID: <CABr-GnfnwZwFM1WDNYzaF5WohH-OoXTJ9B+hdqRLFPs7T24fGA@mail.gmail.com>
References: <20161121113931.4255-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4701166473207405463=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161121113931.4255-1-xose.vazquez@gmail.com>
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

--===============4701166473207405463==
Content-Type: multipart/alternative; boundary=001a1146c3542195a7054230732d

--001a1146c3542195a7054230732d
Content-Type: text/plain; charset=UTF-8

Applied, thanks.

On Mon, Nov 21, 2016 at 12:39 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> It's the default value.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 7619994..c46b072 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -544,7 +544,6 @@ static struct hwentry default_hw[] = {
>                 /* FlashSystem 710/720/810/820/840/900 */
>                 .vendor        = "IBM",
>                 .product       = "FlashSystem",
> -               .no_path_retry = NO_PATH_RETRY_FAIL,
>                 .pgpolicy      = MULTIBUS,
>         },
>         {
> @@ -918,7 +917,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "Ceph",
>                 .product       = "RBD",
> -               .no_path_retry = NO_PATH_RETRY_FAIL,
>                 .checker_name  = RBD,
>                 .deferred_remove = DEFERRED_REMOVE_ON,
>         },
> --
> 2.10.2
>
>

--001a1146c3542195a7054230732d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied, thanks.</div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Mon, Nov 21, 2016 at 12:39 PM, Xose Vazquez Perez =
<span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_=
blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">It&#39;s the default value.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 2 --<br>
=C2=A01 file changed, 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 7619994..c46b072 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -544,7 +544,6 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* FlashSystem 710/=
720/810/820/840/900 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;FlashSystem&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D =
NO_PATH_RETRY_FAIL,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
@@ -918,7 +917,6 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;Ceph&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;RBD&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D =
NO_PATH_RETRY_FAIL,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .checker_name=C2=A0=
 =3D RBD,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .deferred_remove =
=3D DEFERRED_REMOVE_ON,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a1146c3542195a7054230732d--


--===============4701166473207405463==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4701166473207405463==--
