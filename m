From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add missing group of
	options in Makefiles
Date: Tue, 16 Aug 2016 09:43:10 +0200
Message-ID: <CABr-GndjM6kN4+Vn17QmaU6Kcz76mNYChROZOwHRDfOvRNeo_g@mail.gmail.com>
References: <1471021927-8662-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9192720688731291780=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471021927-8662-1-git-send-email-xose.vazquez@gmail.com>
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

--===============9192720688731291780==
Content-Type: multipart/alternative; boundary=001a114102a4182a18053a2b80f9

--001a114102a4182a18053a2b80f9
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Fri, Aug 12, 2016 at 7:12 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> And remove "-g", it's already in OPTFLAG
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  kpartx/Makefile          | 2 +-
>  libmpathpersist/Makefile | 2 +-
>  mpathpersist/Makefile    | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 75b7606..6f32680 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -21,7 +21,7 @@ EXEC = kpartx
>  all: $(EXEC)
>
>  $(EXEC): $(OBJS)
> -       $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
> +       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)
>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>
>  install: $(EXEC) $(EXEC).8
> diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
> index 1c4b2e1..6e43427 100644
> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -15,7 +15,7 @@ all: $(LIBS)
>
>  $(LIBS):
>         $(CC) -c $(CFLAGS) *.c
> -       $(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@
> $(OBJS)
> +       $(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@
> $(CFLAGS) -o $@ $(OBJS)
>         $(LN) $(LIBS) $(DEVLIB)
>         $(GZIP) mpath_persistent_reserve_in.3 >
> mpath_persistent_reserve_in.3.gz
>         $(GZIP) mpath_persistent_reserve_out.3 >
> mpath_persistent_reserve_out.3.gz
> diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
> index d545514..b6ab730 100644
> --- a/mpathpersist/Makefile
> +++ b/mpathpersist/Makefile
> @@ -12,7 +12,7 @@ OBJS = main.o
>  all: $(EXEC)
>
>  $(EXEC): $(OBJS)
> -       $(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
> +       $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>
>  install:
> --
> 2.7.4
>
>

--001a114102a4182a18053a2b80f9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Fri, Aug 12, 2016 at 7:12 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">And remove &quot;-g&quot;, it&#39;s already in OPTFLAG<=
br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<br>
=C2=A0libmpathpersist/Makefile | 2 +-<br>
=C2=A0mpathpersist/Makefile=C2=A0 =C2=A0 | 2 +-<br>
=C2=A03 files changed, 3 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index 75b7606..6f32680 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -21,7 +21,7 @@ EXEC =3D kpartx<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install: $(EXEC) $(EXEC).8<br>
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile<br>
index 1c4b2e1..6e43427 100644<br>
--- a/libmpathpersist/Makefile<br>
+++ b/libmpathpersist/Makefile<br>
@@ -15,7 +15,7 @@ all: $(LIBS)<br>
<br>
=C2=A0$(LIBS):<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(CC) -c $(CFLAGS) *.c<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=3D=
$@ $(CFLAGS) -o $@ $(OBJS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ $(CFLAGS) -o $@ $(OBJS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $(LIBS) $(DEVLIB)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) mpath_persistent_reserve_in.3 &gt; mpat=
h_persistent_reserve_in.3.<wbr>gz<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) mpath_persistent_reserve_out.3 &gt; mpa=
th_persistent_reserve_out.<wbr>3.gz<br>
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile<br>
index d545514..b6ab730 100644<br>
--- a/mpathpersist/Makefile<br>
+++ b/mpathpersist/Makefile<br>
@@ -12,7 +12,7 @@ OBJS =3D main.o<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS=
)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install:<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114102a4182a18053a2b80f9--


--===============9192720688731291780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9192720688731291780==--
