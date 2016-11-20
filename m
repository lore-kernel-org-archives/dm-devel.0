From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: merge nvme in similar
	blacklist regex
Date: Sun, 20 Nov 2016 14:24:05 +0100
Message-ID: <CABr-GndS2dFAsVQ4TCpCXp_xHP=kePwqTesk+d5FrR2Zjfotyg@mail.gmail.com>
References: <20161116161325.3326-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0859876518022650223=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161116161325.3326-1-xose.vazquez@gmail.com>
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

--===============0859876518022650223==
Content-Type: multipart/alternative; boundary=94eb2c0ec21417bfdb0541bb74b0

--94eb2c0ec21417bfdb0541bb74b0
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Wed, Nov 16, 2016 at 5:13 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Similar patterns, /dev/nvme[0-9] .
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/blacklist.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index f6c4506..9e225cd 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)
>         char * str;
>         int i;
>
> -       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
> +       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-
> 9]");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> @@ -184,12 +184,6 @@ setup_default_blist (struct config * conf)
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>                 return 1;
>
> -       str = STRDUP("^nvme");
> -       if (!str)
> -               return 1;
> -       if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> -               return 1;
> -
>         str = STRDUP("(SCSI_IDENT_|ID_WWN)");
>         if (!str)
>                 return 1;
> --
> 2.10.2
>
>

--94eb2c0ec21417bfdb0541bb74b0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, Nov 16, 2016 at 5:13 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Similar patterns, /dev/nvme[0-9] .<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/blacklist.c | 8 +-------<br>
=C2=A01 file changed, 1 insertion(+), 7 deletions(-)<br>
<br>
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c<br>
index f6c4506..9e225cd 100644<br>
--- a/libmultipath/blacklist.c<br>
+++ b/libmultipath/blacklist.c<br>
@@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * str;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st|dcssblk)[0-9]&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st|dcssblk|nvme)[0-<wbr>9]&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
@@ -184,12 +184,6 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^nvme&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!str)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 str =3D STRDUP(&quot;(SCSI_IDENT_|ID_WWN)&quot;=
)<wbr>;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c0ec21417bfdb0541bb74b0--


--===============0859876518022650223==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0859876518022650223==--
