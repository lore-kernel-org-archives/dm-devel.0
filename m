From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace multipath
	configuration output
Date: Wed, 12 Apr 2017 09:35:37 +0200
Message-ID: <CABr-Gnee6+q-wco7662ptvYuUKWHgdQbEC=zFYQCi_cUHGQ+EQ@mail.gmail.com>
References: <20170408133042.4478-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8776622774873486063=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170408133042.4478-1-xose.vazquez@gmail.com>
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

--===============8776622774873486063==
Content-Type: multipart/alternative; boundary=94eb2c04f89a2d2c23054cf341ab

--94eb2c04f89a2d2c23054cf341ab
Content-Type: text/plain; charset=UTF-8

Merged,
thanks.

On Sat, Apr 8, 2017 at 3:30 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/propsel.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index dd10ceb..5f70d86 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -162,7 +162,7 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
>
>         if (conf->pgpolicy_flag > 0) {
>                 mp->pgpolicy = conf->pgpolicy_flag;
> -               origin = "(cmd line flag)";
> +               origin = "(setting: multipath command line [-p] flag)";
>                 goto out;
>         }
>         mp_set_mpe(pgpolicy);
> @@ -251,18 +251,18 @@ int select_alias(struct config *conf, struct
> multipath * mp)
>                                 mp->alias_old, mp->alias_prefix,
>                                 conf->bindings_read_only);
>                 memset (mp->alias_old, 0, WWID_SIZE);
> -               origin = "(using existing alias)";
> +               origin = "(setting: using existing alias)";
>         }
>
>         if (mp->alias == NULL) {
>                 mp->alias = get_user_friendly_alias(mp->wwid,
>                                 conf->bindings_file, mp->alias_prefix,
> conf->bindings_read_only);
> -               origin = "(user_friendly_name)";
> +               origin = "(setting: user_friendly_name)";
>         }
>  out:
>         if (mp->alias == NULL) {
>                 mp->alias = STRDUP(mp->wwid);
> -               origin = "(default to wwid)";
> +               origin = "(setting: default to WWID)";
>         }
>         if (mp->alias)
>                 condlog(3, "%s: alias = %s %s", mp->wwid, mp->alias,
> origin);
> @@ -565,7 +565,7 @@ int select_retain_hwhandler(struct config *conf,
> struct multipath *mp)
>
>         if (!VERSION_GE(conf->version, minv_dm_retain)) {
>                 mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
> -               origin = "(requires kernel version >= 1.5.0)";
> +               origin = "(setting: WARNING, requires kernel version >=
> 1.5.0)";
>                 goto out;
>         }
>         mp_set_ovr(retain_hwhandler);
> @@ -614,7 +614,7 @@ int select_deferred_remove(struct config *conf, struct
> multipath *mp)
>
>  #ifndef LIBDM_API_DEFERRED
>         mp->deferred_remove = DEFERRED_REMOVE_OFF;
> -       origin = "(not compiled with support)";
> +       origin = "(setting: WARNING, not compiled with support)";
>         goto out;
>  #endif
>         if (mp->deferred_remove == DEFERRED_REMOVE_IN_PROGRESS) {
> --
> 2.12.2
>
>

--94eb2c04f89a2d2c23054cf341ab
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, Apr 8, 2017 at 3:30 PM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.v=
aroqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/propsel.c | 12 ++++++------<br>
=C2=A01 file changed, 6 insertions(+), 6 deletions(-)<br>
<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index dd10ceb..5f70d86 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -162,7 +162,7 @@ int select_pgpolicy(struct config *conf, struct multipa=
th * mp)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;pgpolicy_flag &gt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;pgpolicy =3D=
 conf-&gt;pgpolicy_flag;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(c=
md line flag)&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(s=
etting: multipath command line [-p] flag)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(pgpolicy);<br>
@@ -251,18 +251,18 @@ int select_alias(struct config *conf, struct multipat=
h * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;alias_old, mp-&gt;alias_prefi=
x,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;bindings_read_only);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset (mp-&gt;alia=
s_old, 0, WWID_SIZE);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(u=
sing existing alias)&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(s=
etting: using existing alias)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;alias =3D=3D NULL) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;alias =3D ge=
t_user_friendly_alias(mp-&gt;<wbr>wwid,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;bindings_file, mp-&gt;alias=
_prefix, conf-&gt;bindings_read_only);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(u=
ser_friendly_name)&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(s=
etting: user_friendly_name)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;alias =3D=3D NULL) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;alias =3D ST=
RDUP(mp-&gt;wwid);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(d=
efault to wwid)&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(s=
etting: default to WWID)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;alias)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s=
: alias =3D %s %s&quot;, mp-&gt;wwid, mp-&gt;alias, origin);<br>
@@ -565,7 +565,7 @@ int select_retain_hwhandler(struct config *conf, struct=
 multipath *mp)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!VERSION_GE(conf-&gt;version, minv_dm_retai=
n)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;retain_hwhan=
dler =3D RETAIN_HWHANDLER_OFF;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(r=
equires kernel version &gt;=3D 1.5.0)&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(s=
etting: WARNING, requires kernel version &gt;=3D 1.5.0)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_ovr(retain_hwhandler);<br>
@@ -614,7 +614,7 @@ int select_deferred_remove(struct config *conf, struct =
multipath *mp)<br>
<br>
=C2=A0#ifndef LIBDM_API_DEFERRED<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;deferred_remove =3D DEFERRED_REMOVE_OFF;=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(not compiled with support)&qu=
ot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(setting: WARNING, not compile=
d with support)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0#endif<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;deferred_remove =3D=3D DEFERRED_REMO=
VE_IN_PROGRESS) {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.2<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c04f89a2d2c23054cf341ab--


--===============8776622774873486063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8776622774873486063==--
