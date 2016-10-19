From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace static value with
 default_variable for flush_on_last_del
Date: Wed, 19 Oct 2016 08:03:57 +0200
Message-ID: <CABr-Gnf5O5yKjKj+tzUFo31jBH-vcoMXxoXpQhDVZz+NApV20w@mail.gmail.com>
References: <20161017170949.27523-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1074254024767145755=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161017170949.27523-1-xose.vazquez@gmail.com>
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

--===============1074254024767145755==
Content-Type: multipart/alternative; boundary=001a1140170225b4d7053f3193bc

--001a1140170225b4d7053f3193bc
Content-Type: text/plain; charset=UTF-8

Merged

On Mon, Oct 17, 2016 at 7:09 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index a48b8af..92e4deb 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -597,7 +597,7 @@ load_config (char * file)
>         conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
>         conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
>         conf->features = set_default(DEFAULT_FEATURES);
> -       conf->flush_on_last_del = 0;
> +       conf->flush_on_last_del = DEFAULT_FLUSH;
>         conf->attribute_flags = 0;
>         conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
>         conf->checkint = DEFAULT_CHECKINT;
> --
> 2.10.1
>
>

--001a1140170225b4d7053f3193bc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged</div><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Mon, Oct 17, 2016 at 7:09 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmarzin=
s@redhat.com</a>&gt;<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt=
;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index a48b8af..92e4deb 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -597,7 +597,7 @@ load_config (char * file)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;wwids_file =3D set_default(DEFAULT_WWI=
DS_<wbr>FILE);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;multipath_dir =3D set_default(DEFAULT_=
<wbr>MULTIPATHDIR);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;features =3D set_default(DEFAULT_FEATU=
RES);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;flush_on_last_del =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;flush_on_last_del =3D DEFAULT_FLUSH;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;attribute_flags =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;reassign_maps =3D DEFAULT_REASSIGN_MAP=
S;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;checkint =3D DEFAULT_CHECKINT;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1140170225b4d7053f3193bc--


--===============1074254024767145755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1074254024767145755==--
