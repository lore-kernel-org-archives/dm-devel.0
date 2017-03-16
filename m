From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: clean up libdmmp/Makefile
Date: Thu, 16 Mar 2017 07:44:54 +0100
Message-ID: <CABr-GndXfiJbp7W9HPLXeEhHwagM7_nh_4_z4U=kbLrYjf5-qA@mail.gmail.com>
References: <20170313164731.2437-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5905608655184564113=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170313164731.2437-1-xose.vazquez@gmail.com>
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
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5905608655184564113==
Content-Type: multipart/alternative; boundary=001a1138f4041328fb054ad366bd

--001a1138f4041328fb054ad366bd
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.

On Mon, Mar 13, 2017 at 5:47 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Replace LDFLAGS with LIBDEPS, build libdmmp shared library without CFLAGS
>
> Cc: Gris Ge <fge@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/Makefile | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index c98ae67..aaff285 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -9,21 +9,22 @@ LIBDMMP_VERSION=0.1.0
>  SONAME=$(LIBDMMP_VERSION)
>  DEVLIB = libdmmp.so
>  LIBS = $(DEVLIB).$(SONAME)
> -LIBDEPS = -pthread
>  PKGFILE = libdmmp.pc
>  EXTRA_MAN_FILES = libdmmp.h.3
>  HEADERS = libdmmp/libdmmp.h
> +
>  OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
>
>  CFLAGS += -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
>           $(shell pkg-config --cflags json-c)
> -LDFLAGS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd
> +
> +LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd
> -pthread
>
>  all: $(LIBS) doc
>
> -$(LIBS): $(OBJS)
> -       $(CC) $(LDFLAGS) $(SHARED_FLAGS) \
> -       -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
> +$(LIBS):
> +       $(CC) -c $(CFLAGS) *.c
> +       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS)
> $(LIBDEPS)
>         $(LN) $@ $(DEVLIB)
>
>  install:
> --
> 2.12.0
>
>

--001a1138f4041328fb054ad366bd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Mar 13, 2017 at 5:47 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Replace LDFLAGS with LIBDEPS, build libdmmp shared libr=
ary without CFLAGS<br>
<br>
Cc: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com</a>&gt;<br=
>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libdmmp/Makefile | 11 ++++++-----<br>
=C2=A01 file changed, 6 insertions(+), 5 deletions(-)<br>
<br>
diff --git a/libdmmp/Makefile b/libdmmp/Makefile<br>
index c98ae67..aaff285 100644<br>
--- a/libdmmp/Makefile<br>
+++ b/libdmmp/Makefile<br>
@@ -9,21 +9,22 @@ LIBDMMP_VERSION=3D0.1.0<br>
=C2=A0SONAME=3D$(LIBDMMP_VERSION)<br>
=C2=A0DEVLIB =3D libdmmp.so<br>
=C2=A0LIBS =3D $(DEVLIB).$(SONAME)<br>
-LIBDEPS =3D -pthread<br>
=C2=A0PKGFILE =3D libdmmp.pc<br>
=C2=A0EXTRA_MAN_FILES =3D libdmmp.h.3<br>
=C2=A0HEADERS =3D libdmmp/libdmmp.h<br>
+<br>
=C2=A0OBJS =3D libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_m=
isc.o<br>
<br>
=C2=A0CFLAGS +=3D -fvisibility=3Dhidden -I$(libdmmpdir) -I$(mpathcmddir) \<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(shell pkg-config --cflags json-c)<br>
-LDFLAGS +=3D $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd=
<br>
+<br>
+LIBDEPS +=3D $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd=
 -pthread<br>
<br>
=C2=A0all: $(LIBS) doc<br>
<br>
-$(LIBS): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) \<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0-Wl,-soname=3D$@ $(CFLAGS) -o $@ $(OBJS) $(LIBD=
EPS)<br>
+$(LIBS):<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) -c $(CFLAGS) *.c<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D=
$@ -o $@ $(OBJS) $(LIBDEPS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $@ $(DEVLIB)<br>
<br>
=C2=A0install:<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a1138f4041328fb054ad366bd--


--===============5905608655184564113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5905608655184564113==--
