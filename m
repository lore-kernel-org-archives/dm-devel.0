From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: merge dcssblk in similar
	blacklist regex
Date: Sun, 16 Oct 2016 17:53:54 +0200
Message-ID: <CABr-GnfyGcxKpvLgqQ6KVqn-yUCPq8VK1NK0E8PtHb=Mm7oH4g@mail.gmail.com>
References: <20161016135946.6479-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3203371652874108552=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161016135946.6479-1-xose.vazquez@gmail.com>
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

--===============3203371652874108552==
Content-Type: multipart/alternative; boundary=001a1141277c76b63c053efd7734

--001a1141277c76b63c053efd7734
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Sun, Oct 16, 2016 at 3:59 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Similar patterns.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/blacklist.c   | 8 +-------
>  multipath/multipath.conf.5 | 2 +-
>  2 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index aa8d975..f6c4506 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)
>         char * str;
>         int i;
>
> -       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]");
> +       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> @@ -184,12 +184,6 @@ setup_default_blist (struct config * conf)
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>                 return 1;
>
> -       str = STRDUP("^dcssblk[0-9]");
> -       if (!str)
> -               return 1;
> -       if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> -               return 1;
> -
>         str = STRDUP("^nvme");
>         if (!str)
>                 return 1;
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 313e21b..367688e 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -851,7 +851,7 @@ The following keywords are recognized:
>  Regular expression of the device nodes to be excluded.
>  .RS
>  .TP
> -Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]\fR,
> \fB^(td|hd|vd)[a-z]\fR, \fB^dcssblk[0-9]\fR and \fB^nvme\fR
> +Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR,
> \fB^(td|hd|vd)[a-z]\fR and \fB^nvme\fR
>  .RE
>  .TP
>  .B wwid
> --
> 2.10.1
>
>

--001a1141277c76b63c053efd7734
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sun, Oct 16, 2016 at 3:59 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">Similar patterns.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0| 8 +-------<br>
=C2=A0multipath/multipath.conf.5 | 2 +-<br>
=C2=A02 files changed, 2 insertions(+), 8 deletions(-)<br>
<br>
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c<br>
index aa8d975..f6c4506 100644<br>
--- a/libmultipath/blacklist.c<br>
+++ b/libmultipath/blacklist.c<br>
@@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * str;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st)[0-9]&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st|dcssblk)[0-9]&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
@@ -184,12 +184,6 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^dcssblk[0-9]&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!str)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 str =3D STRDUP(&quot;^nvme&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 313e21b..367688e 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -851,7 +851,7 @@ The following keywords are recognized:<br>
=C2=A0Regular expression of the device nodes to be excluded.<br>
=C2=A0.RS<br>
=C2=A0.TP<br>
-Default value is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st)[0-9]\fR, \fB=
^(td|hd|vd)[a-z]\fR, \fB^dcssblk[0-9]\fR and \fB^nvme\fR<br>
+Default value is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st|dcssblk)[0-9]=
\fR, \fB^(td|hd|vd)[a-z]\fR and \fB^nvme\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B wwid<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1141277c76b63c053efd7734--


--===============3203371652874108552==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3203371652874108552==--
