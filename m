From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: arrange compilation options
	for shared libs/objects
Date: Thu, 23 Mar 2017 09:35:19 +0100
Message-ID: <CABr-GncoNan5AAfb4TpVGPTWyUakcOOFoFQut5vj2+42rBpxiw@mail.gmail.com>
References: <20170318174500.15268-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1688544930907205889=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170318174500.15268-1-xose.vazquez@gmail.com>
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

--===============1688544930907205889==
Content-Type: multipart/alternative; boundary=94eb2c12f968d9abf3054b61c1b9

--94eb2c12f968d9abf3054b61c1b9
Content-Type: text/plain; charset=UTF-8

Merged,
Thanks.

On Sat, Mar 18, 2017 at 6:45 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/Makefile                   | 2 +-
>  libmpathcmd/Makefile               | 2 +-
>  libmpathpersist/Makefile           | 2 +-
>  libmultipath/Makefile              | 2 +-
>  libmultipath/checkers/Makefile     | 6 +++---
>  libmultipath/prioritizers/Makefile | 4 ++--
>  6 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 082078a..8640bf6 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -23,7 +23,7 @@ LIBDEPS += $(shell pkg-config --libs json-c)
> -L$(mpathcmddir) -lmpathcmd -lpthre
>  all: $(LIBS) doc
>
>  $(LIBS): $(OBJS)
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS)
> $(LIBDEPS)
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS)
> -o $@
>         $(LN) $@ $(DEVLIB)
>
>  install:
> diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
> index b8e29cb..b6c349a 100644
> --- a/libmpathcmd/Makefile
> +++ b/libmpathcmd/Makefile
> @@ -9,7 +9,7 @@ OBJS = mpath_cmd.o
>  all: $(LIBS)
>
>  $(LIBS): $(OBJS)
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS)
> $(LIBDEPS)
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS)
> -o $@
>         $(LN) $@ $(DEVLIB)
>
>  install: $(LIBS)
> diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
> index 96da639..ee4a421 100644
> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -14,7 +14,7 @@ OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
>  all: $(LIBS)
>
>  $(LIBS): $(OBJS)
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@
> $(OBJS)
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS)
> -o $@
>         $(LN) $(LIBS) $(DEVLIB)
>         $(GZIP) mpath_persistent_reserve_in.3 >
> mpath_persistent_reserve_in.3.gz
>         $(GZIP) mpath_persistent_reserve_out.3 >
> mpath_persistent_reserve_out.3.gz
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 1f5ec25..c5f4052 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -47,7 +47,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
>  all: $(LIBS)
>
>  $(LIBS): $(OBJS)
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS)
> $(LIBDEPS)
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS)
> -o $@
>         $(LN) $@ $(DEVLIB)
>
>  install:
> diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/
> Makefile
> index 11ab76f..3b8e27c 100644
> --- a/libmultipath/checkers/Makefile
> +++ b/libmultipath/checkers/Makefile
> @@ -19,13 +19,13 @@ LIBS= \
>  all: $(LIBS)
>
>  libcheckrbd.so: rbd.o
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^ -lrados -ludev
>
>  libcheckdirectio.so: libsg.o directio.o
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^ -laio
>
>  libcheck%.so: libsg.o %.o
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^
>
>  install:
>         $(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
> diff --git a/libmultipath/prioritizers/Makefile
> b/libmultipath/prioritizers/Makefile
> index 36b42e4..8a5561a 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -23,10 +23,10 @@ LIBS = \
>  all: $(LIBS)
>
>  libprioalua.so: alua.o alua_rtpg.o
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^
>
>  libprio%.so: %.o
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +       $(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^
>
>  install: $(LIBS)
>         $(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
> --
> 2.12.0
>
>

--94eb2c12f968d9abf3054b61c1b9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, Mar 18, 2017 at 6:45 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.=
varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libdmmp/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0| 2 +-<br>
=C2=A0libmpathcmd/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 2 +-<br>
=C2=A0libmpathpersist/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 =
+-<br>
=C2=A0libmultipath/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 | 2 +-<br>
=C2=A0libmultipath/checkers/Makefile=C2=A0 =C2=A0 =C2=A0| 6 +++---<br>
=C2=A0libmultipath/prioritizers/<wbr>Makefile | 4 ++--<br>
=C2=A06 files changed, 9 insertions(+), 9 deletions(-)<br>
<br>
diff --git a/libdmmp/Makefile b/libdmmp/Makefile<br>
index 082078a..8640bf6 100644<br>
--- a/libdmmp/Makefile<br>
+++ b/libdmmp/Makefile<br>
@@ -23,7 +23,7 @@ LIBDEPS +=3D $(shell pkg-config --libs json-c) -L$(mpathc=
mddir) -lmpathcmd -lpthre<br>
=C2=A0all: $(LIBS) doc<br>
<br>
=C2=A0$(LIBS): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D=
$@ -o $@ $(OBJS) $(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ $(OBJS) -o $@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $@ $(DEVLIB)<br>
<br>
=C2=A0install:<br>
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile<br>
index b8e29cb..b6c349a 100644<br>
--- a/libmpathcmd/Makefile<br>
+++ b/libmpathcmd/Makefile<br>
@@ -9,7 +9,7 @@ OBJS =3D mpath_cmd.o<br>
=C2=A0all: $(LIBS)<br>
<br>
=C2=A0$(LIBS): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D=
$@ -o $@ $(OBJS) $(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ $(OBJS) -o $@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $@ $(DEVLIB)<br>
<br>
=C2=A0install: $(LIBS)<br>
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile<br>
index 96da639..ee4a421 100644<br>
--- a/libmpathpersist/Makefile<br>
+++ b/libmpathpersist/Makefile<br>
@@ -14,7 +14,7 @@ OBJS =3D mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.=
o<br>
=C2=A0all: $(LIBS)<br>
<br>
=C2=A0$(LIBS): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ -o $@ $(OBJS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ $(OBJS) -o $@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $(LIBS) $(DEVLIB)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) mpath_persistent_reserve_in.3 &gt; mpat=
h_persistent_reserve_in.3.<wbr>gz<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) mpath_persistent_reserve_out.3 &gt; mpa=
th_persistent_reserve_out.<wbr>3.gz<br>
diff --git a/libmultipath/Makefile b/libmultipath/Makefile<br>
index 1f5ec25..c5f4052 100644<br>
--- a/libmultipath/Makefile<br>
+++ b/libmultipath/Makefile<br>
@@ -47,7 +47,7 @@ OBJS =3D memory.o parser.o vector.o devmapper.o callout.o=
 \<br>
=C2=A0all: $(LIBS)<br>
<br>
=C2=A0$(LIBS): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D=
$@ -o $@ $(OBJS) $(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ $(OBJS) -o $@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $@ $(DEVLIB)<br>
<br>
=C2=A0install:<br>
diff --git a/libmultipath/checkers/<wbr>Makefile b/libmultipath/checkers/<w=
br>Makefile<br>
index 11ab76f..3b8e27c 100644<br>
--- a/libmultipath/checkers/<wbr>Makefile<br>
+++ b/libmultipath/checkers/<wbr>Makefile<br>
@@ -19,13 +19,13 @@ LIBS=3D \<br>
=C2=A0all: $(LIBS)<br>
<br>
=C2=A0libcheckrbd.so: rbd.o<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrad=
os -ludev<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^ -lrad=
os -ludev<br>
<br>
=C2=A0libcheckdirectio.so: libsg.o directio.o<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^ -laio=
<br>
<br>
=C2=A0libcheck%.so: libsg.o %.o<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^<br>
<br>
=C2=A0install:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(l=
ibdir)<br>
diff --git a/libmultipath/prioritizers/<wbr>Makefile b/libmultipath/priorit=
izers/<wbr>Makefile<br>
index 36b42e4..8a5561a 100644<br>
--- a/libmultipath/prioritizers/<wbr>Makefile<br>
+++ b/libmultipath/prioritizers/<wbr>Makefile<br>
@@ -23,10 +23,10 @@ LIBS =3D \<br>
=C2=A0all: $(LIBS)<br>
<br>
=C2=A0libprioalua.so: alua.o alua_rtpg.o<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^<br>
<br>
=C2=A0libprio%.so: %.o<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^<br>
<br>
=C2=A0install: $(LIBS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR=
)$(libdir)<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c12f968d9abf3054b61c1b9--


--===============1688544930907205889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1688544930907205889==--
