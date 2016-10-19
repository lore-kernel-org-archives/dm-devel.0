From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: fix DEFAULT values
Date: Wed, 19 Oct 2016 08:05:59 +0200
Message-ID: <CABr-Gnf+mQgZ9e-Bv9x8xMRtQGpbNyvw+5+jqe-HA2CRXzc3CA@mail.gmail.com>
References: <20161017163228.26804-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0016335808728681861=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161017163228.26804-1-xose.vazquez@gmail.com>
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

--===============0016335808728681861==
Content-Type: multipart/alternative; boundary=001a1141277c66cfcd053f319a71

--001a1141277c66cfcd053f319a71
Content-Type: text/plain; charset=UTF-8

Merged.

On Mon, Oct 17, 2016 at 6:32 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> replace RR_WEIGHT_NONE with DEFAULT_RR_WEIGHT, and define DEFAULT_FLUSH
>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/defaults.h | 1 +
>  libmultipath/propsel.c  | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 9bf27d6..d00a86f 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -31,6 +31,7 @@
>  #define DEFAULT_PRIO           "const"
>  #define DEFAULT_PRIO_ARGS      ""
>  #define DEFAULT_CHECKER                TUR
> +#define DEFAULT_FLUSH          FLUSH_DISABLED
>
>  #define DEFAULT_CHECKINT       5
>  #define MAX_CHECKINT(a)                (a << 2)
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 1625990..88a1916 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -137,7 +137,7 @@ select_rr_weight (struct config *conf, struct
> multipath * mp)
>         mp_set_ovr(rr_weight);
>         mp_set_hwe(rr_weight);
>         mp_set_conf(rr_weight);
> -       mp_set_default(rr_weight, RR_WEIGHT_NONE);
> +       mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);
>  out:
>         print_rr_weight(buff, 13, &mp->rr_weight);
>         condlog(3, "%s: rr_weight = %s %s", mp->alias, buff, origin);
> @@ -550,7 +550,7 @@ select_flush_on_last_del(struct config *conf, struct
> multipath *mp)
>         mp_set_ovr(flush_on_last_del);
>         mp_set_hwe(flush_on_last_del);
>         mp_set_conf(flush_on_last_del);
> -       mp_set_default(flush_on_last_del, FLUSH_DISABLED);
> +       mp_set_default(flush_on_last_del, DEFAULT_FLUSH);
>  out:
>         condlog(3, "%s: flush_on_last_del = %s %s", mp->alias,
>                 (mp->flush_on_last_del == FLUSH_ENABLED)? "yes" : "no",
> origin);
> --
> 2.10.1
>
>

--001a1141277c66cfcd053f319a71
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Mon, Oct 17, 2016 at 6:32 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><div class=3D"HOEnZb"><div class=3D"h5">replace RR_WEIGHT_NONE with DEFAU=
LT_RR_WEIGHT, and define DEFAULT_FLUSH<br>
<br>
Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmarzins@=
redhat.com</a>&gt;<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt=
;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/defaults.h | 1 +<br>
=C2=A0libmultipath/propsel.c=C2=A0 | 4 ++--<br>
=C2=A02 files changed, 3 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h<br>
index 9bf27d6..d00a86f 100644<br>
--- a/libmultipath/defaults.h<br>
+++ b/libmultipath/defaults.h<br>
@@ -31,6 +31,7 @@<br>
=C2=A0#define DEFAULT_PRIO=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;co=
nst&quot;<br>
=C2=A0#define DEFAULT_PRIO_ARGS=C2=A0 =C2=A0 =C2=A0 &quot;&quot;<br>
=C2=A0#define DEFAULT_CHECKER=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 TUR<br>
+#define DEFAULT_FLUSH=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FLUSH_DISABLED<br>
<br>
=C2=A0#define DEFAULT_CHECKINT=C2=A0 =C2=A0 =C2=A0 =C2=A05<br>
=C2=A0#define MAX_CHECKINT(a)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (a &lt;&lt; 2)<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index 1625990..88a1916 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -137,7 +137,7 @@ select_rr_weight (struct config *conf, struct multipath=
 * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_ovr(rr_weight);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(rr_weight);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(rr_weight);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(rr_weight, RR_WEIGHT_NONE);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);<b=
r>
=C2=A0out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 print_rr_weight(buff, 13, &amp;mp-&gt;rr_weight=
);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: rr_weight =3D %s %s&quot;,=
 mp-&gt;alias, buff, origin);<br>
@@ -550,7 +550,7 @@ select_flush_on_last_del(<wbr>struct config *conf, stru=
ct multipath *mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_ovr(flush_on_last_del);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(flush_on_last_del);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(flush_on_last_del)<wbr>;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(flush_on_last_<wbr>del, FLUSH_DI=
SABLED);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(flush_on_last_<wbr>del, DEFAULT_=
FLUSH);<br>
=C2=A0out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: flush_on_last_del =3D %s %=
s&quot;, mp-&gt;alias,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mp-&gt;flush_on_la=
st_del =3D=3D FLUSH_ENABLED)? &quot;yes&quot; : &quot;no&quot;, origin);<br=
>
--<br>
2.10.1<br>
<br>
</div></div></blockquote></div><br></div>

--001a1141277c66cfcd053f319a71--


--===============0016335808728681861==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0016335808728681861==--
