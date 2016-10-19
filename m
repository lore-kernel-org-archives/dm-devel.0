From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace static and define
 default values for config options
Date: Wed, 19 Oct 2016 20:21:11 +0200
Message-ID: <CABr-GnfZzsmqSVwKzZA92YGRouw2Hx3ZJ-1SYU3GXZD-Fzzc5w@mail.gmail.com>
References: <20161019181617.9147-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1300650974270303045=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161019181617.9147-1-xose.vazquez@gmail.com>
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

--===============1300650974270303045==
Content-Type: multipart/alternative; boundary=001a11401702ab86b2053f3bdfc2

--001a11401702ab86b2053f3bdfc2
Content-Type: text/plain; charset=UTF-8

Merged.

On Wed, Oct 19, 2016 at 8:16 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Replace "const" by PRIO_CONST.
> Replace static force_sync and partition_delim values, and define
> DEFAULT_FORCE_SYNC and DEFAULT_PARTITION_DELIM
>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/config.c   | 4 ++--
>  libmultipath/defaults.h | 4 +++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 92e4deb..ed51afb 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -606,8 +606,8 @@ load_config (char * file)
>         conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
>         conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
>         conf->detect_prio = DEFAULT_DETECT_PRIO;
> -       conf->force_sync = 0;
> -       conf->partition_delim = NULL;
> +       conf->force_sync = DEFAULT_FORCE_SYNC;
> +       conf->partition_delim = DEFAULT_PARTITION_DELIM;
>         conf->processed_main_config = 0;
>         conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
>         conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index e9581a6..9af9a9a 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -28,11 +28,13 @@
>  #define DEFAULT_RETRIGGER_DELAY        10
>  #define DEFAULT_RETRIGGER_TRIES        3
>  #define DEFAULT_UEV_WAIT_TIMEOUT 30
> -#define DEFAULT_PRIO           "const"
> +#define DEFAULT_PRIO           PRIO_CONST
>  #define DEFAULT_PRIO_ARGS      ""
>  #define DEFAULT_CHECKER                TUR
>  #define DEFAULT_FLUSH          FLUSH_DISABLED
>  #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
> +#define DEFAULT_FORCE_SYNC     0
> +#define DEFAULT_PARTITION_DELIM        NULL
>
>  #define DEFAULT_CHECKINT       5
>  #define MAX_CHECKINT(a)                (a << 2)
> --
> 2.10.1
>
>

--001a11401702ab86b2053f3bdfc2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Oct 19, 2016 at 8:16 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Replace &quot;const&quot; by PRIO_CONST.<br>
Replace static force_sync and partition_delim values, and define<br>
DEFAULT_FORCE_SYNC and DEFAULT_PARTITION_DELIM<br>
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
=C2=A0libmultipath/config.c=C2=A0 =C2=A0| 4 ++--<br>
=C2=A0libmultipath/defaults.h | 4 +++-<br>
=C2=A02 files changed, 5 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index 92e4deb..ed51afb 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -606,8 +606,8 @@ load_config (char * file)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;fast_io_fail =3D DEFAULT_FAST_IO_FAIL;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;retain_hwhandler =3D DEFAULT_RETAIN_HW=
HANDLER;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;detect_prio =3D DEFAULT_DETECT_PRIO;<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;force_sync =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;partition_delim =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;force_sync =3D DEFAULT_FORCE_SYNC;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;partition_delim =3D DEFAULT_PARTITION_=
DELIM;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;processed_main_config =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;find_multipaths =3D DEFAULT_FIND_MULTI=
PATHS;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;uxsock_timeout =3D DEFAULT_REPLY_TIMEO=
UT;<br>
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h<br>
index e9581a6..9af9a9a 100644<br>
--- a/libmultipath/defaults.h<br>
+++ b/libmultipath/defaults.h<br>
@@ -28,11 +28,13 @@<br>
=C2=A0#define DEFAULT_RETRIGGER_DELAY=C2=A0 =C2=A0 =C2=A0 =C2=A0 10<br>
=C2=A0#define DEFAULT_RETRIGGER_TRIES=C2=A0 =C2=A0 =C2=A0 =C2=A0 3<br>
=C2=A0#define DEFAULT_UEV_WAIT_TIMEOUT 30<br>
-#define DEFAULT_PRIO=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;const&q=
uot;<br>
+#define DEFAULT_PRIO=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PRIO_CONST<br=
>
=C2=A0#define DEFAULT_PRIO_ARGS=C2=A0 =C2=A0 =C2=A0 &quot;&quot;<br>
=C2=A0#define DEFAULT_CHECKER=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 TUR<br>
=C2=A0#define DEFAULT_FLUSH=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FLUSH_DISABLE=
D<br>
=C2=A0#define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF<br>
+#define DEFAULT_FORCE_SYNC=C2=A0 =C2=A0 =C2=A00<br>
+#define DEFAULT_PARTITION_DELIM=C2=A0 =C2=A0 =C2=A0 =C2=A0 NULL<br>
<br>
=C2=A0#define DEFAULT_CHECKINT=C2=A0 =C2=A0 =C2=A0 =C2=A05<br>
=C2=A0#define MAX_CHECKINT(a)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (a &lt;&lt; 2)<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11401702ab86b2053f3bdfc2--


--===============1300650974270303045==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1300650974270303045==--
