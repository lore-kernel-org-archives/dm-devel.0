From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/5] multipath-tools: replace LDFLAGS with
 LIBDEPS for groups of libraries in Makefiles
Date: Tue, 16 Aug 2016 15:39:34 +0200
Message-ID: <CABr-GncpYQP=K2wAGb-mFKg_T54ygSMWNUUDywSPPP3sJqXP8g@mail.gmail.com>
References: <1471351133-7892-1-git-send-email-xose.vazquez@gmail.com>
	<1471351133-7892-2-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0750580309897837358=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471351133-7892-2-git-send-email-xose.vazquez@gmail.com>
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

--===============0750580309897837358==
Content-Type: multipart/alternative; boundary=001a114102a4ba569b053a307a9a

--001a114102a4ba569b053a307a9a
Content-Type: text/plain; charset=UTF-8

This one was not forgotten.
I was waiting for follow-ons on the discussion with Bart.
Do you have a position on the opportunity to align on the variable name
used by autoconf ?

The other patches of the set are now merged.
Thanks.

On Tue, Aug 16, 2016 at 2:38 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  kpartx/Makefile       | 4 ++--
>  mpathpersist/Makefile | 4 ++--
>  multipath/Makefile    | 4 ++--
>  multipathd/Makefile   | 8 ++++----
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 8af0dc6..853288f 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -5,7 +5,7 @@ include ../Makefile.inc
>
>  CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
>
> -LDFLAGS += -ldevmapper
> +LIBDEPS += -ldevmapper
>
>  LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie'
> /usr/include/libdevmapper.h)
>
> @@ -21,7 +21,7 @@ EXEC = kpartx
>  all: $(EXEC)
>
>  $(EXEC): $(OBJS)
> -       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)
> +       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>
>  install: $(EXEC) $(EXEC).8
> diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
> index b6ab730..7921619 100644
> --- a/mpathpersist/Makefile
> +++ b/mpathpersist/Makefile
> @@ -2,7 +2,7 @@ include ../Makefile.inc
>
>  CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
>
> -LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
> +LIBDEPS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
>            -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
>
>  EXEC = mpathpersist
> @@ -12,7 +12,7 @@ OBJS = main.o
>  all: $(EXEC)
>
>  $(EXEC): $(OBJS)
> -       $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
> +       $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>
>  install:
> diff --git a/multipath/Makefile b/multipath/Makefile
> index b125ae3..f296add 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -5,7 +5,7 @@ include ../Makefile.inc
>
>  CFLAGS += -I$(multipathdir) -I$(mpathcmddir)
>
> -LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath
> -ludev \
> +LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath
> -ludev \
>            -L$(mpathcmddir) -lmpathcmd
>
>  EXEC = multipath
> @@ -15,7 +15,7 @@ OBJS = main.o
>  all: $(EXEC)
>
>  $(EXEC): $(OBJS)
> -       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)
> +       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>         $(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
>
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 03d7815..8524efa 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -8,16 +8,16 @@ include ../Makefile.inc
>  #CFLAGS += -DLOGDBG
>  CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
>
> -LDFLAGS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir)
> \
> +LIBDEPS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir)
> \
>            -lmpathpersist -L$(mpathcmddir) -lmpathcmd -lurcu -lpthread \
>            -ldevmapper -lreadline
>
>  ifdef SYSTEMD
>         CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
>         ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
> -               LDFLAGS += -lsystemd
> +               LIBDEPS += -lsystemd
>         else
> -               LDFLAGS += -lsystemd-daemon
> +               LIBDEPS += -lsystemd-daemon
>         endif
>  endif
>
> @@ -28,7 +28,7 @@ EXEC = multipathd
>  all : $(EXEC)
>
>  $(EXEC): $(OBJS)
> -       $(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC)
> +       $(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>
>  install:
> --
> 2.7.4
>
>

--001a114102a4ba569b053a307a9a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>This one was not forgotten.</div>I was waiting for fo=
llow-ons on the discussion with Bart.<div>Do you have a position on the opp=
ortunity to align on the variable name used by autoconf ?</div><div><br></d=
iv><div>The other patches of the set are now merged.</div><div>Thanks.</div=
></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Au=
g 16, 2016 at 2:38 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"=
mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Cc: Christophe Varoqui=
 &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com">christophe.varoqui@o=
pensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0| 4 ++--<br>
=C2=A0mpathpersist/Makefile | 4 ++--<br>
=C2=A0multipath/Makefile=C2=A0 =C2=A0 | 4 ++--<br>
=C2=A0multipathd/Makefile=C2=A0 =C2=A0| 8 ++++----<br>
=C2=A04 files changed, 10 insertions(+), 10 deletions(-)<br>
<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index 8af0dc6..853288f 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -5,7 +5,7 @@ include ../Makefile.inc<br>
<br>
=C2=A0CFLAGS +=3D -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64<br>
<br>
-LDFLAGS +=3D -ldevmapper<br>
+LIBDEPS +=3D -ldevmapper<br>
<br>
=C2=A0LIBDM_API_COOKIE =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+dm_tas=
k_<wbr>set_cookie&#39; /usr/include/libdevmapper.h)<br>
<br>
@@ -21,7 +21,7 @@ EXEC =3D kpartx<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $=
(LIBDEPS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install: $(EXEC) $(EXEC).8<br>
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile<br>
index b6ab730..7921619 100644<br>
--- a/mpathpersist/Makefile<br>
+++ b/mpathpersist/Makefile<br>
@@ -2,7 +2,7 @@ include ../Makefile.inc<br>
<br>
=C2=A0CFLAGS +=3D -I$(multipathdir) -I$(mpathpersistdir)<br>
<br>
-LDFLAGS +=3D -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \<b=
r>
+LIBDEPS +=3D -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-L$(multipathdir) -L$(mpathcmddir)=
 -lmpathcmd -lmultipath -ludev<br>
<br>
=C2=A0EXEC =3D mpathpersist<br>
@@ -12,7 +12,7 @@ OBJS =3D main.o<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $=
(LIBDEPS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install:<br>
diff --git a/multipath/Makefile b/multipath/Makefile<br>
index b125ae3..f296add 100644<br>
--- a/multipath/Makefile<br>
+++ b/multipath/Makefile<br>
@@ -5,7 +5,7 @@ include ../Makefile.inc<br>
<br>
=C2=A0CFLAGS +=3D -I$(multipathdir) -I$(mpathcmddir)<br>
<br>
-LDFLAGS +=3D -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -lud=
ev \<br>
+LIBDEPS +=3D -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -lud=
ev \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-L$(mpathcmddir) -lmpathcmd<br>
<br>
=C2=A0EXEC =3D multipath<br>
@@ -15,7 +15,7 @@ OBJS =3D main.o<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $=
(LIBDEPS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).conf.5 &gt; $(EXEC).conf.5.gz<b=
r>
<br>
diff --git a/multipathd/Makefile b/multipathd/Makefile<br>
index 03d7815..8524efa 100644<br>
--- a/multipathd/Makefile<br>
+++ b/multipathd/Makefile<br>
@@ -8,16 +8,16 @@ include ../Makefile.inc<br>
=C2=A0#CFLAGS +=3D -DLOGDBG<br>
=C2=A0CFLAGS +=3D -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)<b=
r>
<br>
-LDFLAGS +=3D -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir=
) \<br>
+LIBDEPS +=3D -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir=
) \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-lmpathpersist -L$(mpathcmddir) -l=
mpathcmd -lurcu -lpthread \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-ldevmapper -lreadline<br>
<br>
=C2=A0ifdef SYSTEMD<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DUSE_SYSTEMD=3D$(SYSTEMD)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ifeq ($(shell test $(SYSTEMD) -gt 209 &amp;&amp=
; echo 1), 1)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LDFLAGS +=3D -lsyst=
emd<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LIBDEPS +=3D -lsyst=
emd<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LDFLAGS +=3D -lsyst=
emd-daemon<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LIBDEPS +=3D -lsyst=
emd-daemon<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 endif<br>
=C2=A0endif<br>
<br>
@@ -28,7 +28,7 @@ EXEC =3D multipathd<br>
=C2=A0all : $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $=
(LIBDEPS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install:<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114102a4ba569b053a307a9a--


--===============0750580309897837358==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0750580309897837358==--
