From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: build objects for libdmmp
 and libmpathpersist independently
Date: Thu, 23 Mar 2017 09:33:59 +0100
Message-ID: <CABr-Gnea5rm6_goSE97PZiJEcdZ6-ZTgUzYdNXbX2nzou-8Xsw@mail.gmail.com>
References: <20170317152146.10884-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1335032898591998189=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170317152146.10884-1-xose.vazquez@gmail.com>
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

--===============1335032898591998189==
Content-Type: multipart/alternative; boundary=f4030437951c170794054b61bdfe

--f4030437951c170794054b61bdfe
Content-Type: text/plain; charset=UTF-8

Merged,
Thanks.

On Fri, Mar 17, 2017 at 4:21 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> libdmmp:
> cc -c -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath
> -I../libmpathpersist -I../libmpathcmd *.c
> new:
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath
> -I../libmpathpersist -I../libmpathcmd -c -o mpath_persist.o mpath_persist.c
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath
> -I../libmpathpersist -I../libmpathcmd -c -o mpath_updatepr.o
> mpath_updatepr.c
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath
> -I../libmpathpersist -I../libmpathcmd -c -o mpath_pr_ioctl.o
> mpath_pr_ioctl.c
>
> libmpathpersist:
> cc -c -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden
> -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c *.c
> new:
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden
> -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp.o
> libdmmp.c
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden
> -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_mp.o
> libdmmp_mp.c
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden
> -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_pg.o
> libdmmp_pg.c
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden
> -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_path.o
> libdmmp_path.c
> cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
> -Werror=implicit-function-declaration -Werror=format-security
> -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
> -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
> -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden
> -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_misc.o
> libdmmp_misc.c
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/Makefile         | 3 +--
>  libmpathpersist/Makefile | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index c7db054..082078a 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -22,8 +22,7 @@ LIBDEPS += $(shell pkg-config --libs json-c)
> -L$(mpathcmddir) -lmpathcmd -lpthre
>
>  all: $(LIBS) doc
>
> -$(LIBS):
> -       $(CC) -c $(CFLAGS) *.c
> +$(LIBS): $(OBJS)
>         $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS)
> $(LIBDEPS)
>         $(LN) $@ $(DEVLIB)
>
> diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
> index 6ef5bab..96da639 100644
> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -13,8 +13,7 @@ OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
>
>  all: $(LIBS)
>
> -$(LIBS):
> -       $(CC) -c $(CFLAGS) *.c
> +$(LIBS): $(OBJS)
>         $(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@
> $(OBJS)
>         $(LN) $(LIBS) $(DEVLIB)
>         $(GZIP) mpath_persistent_reserve_in.3 >
> mpath_persistent_reserve_in.3.gz
> --
> 2.12.0
>
>

--f4030437951c170794054b61bdfe
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Mar 17, 2017 at 4:21 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">libdmmp:<br>
cc -c -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werro=
r=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-=
compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fst=
ack-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&q=
uot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -I../libmultipath -I../libmp=
athpersist -I../libmpathcmd *.c<br>
new:<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -I../libmultipath -I../libmpa=
thpersist -I../libmpathcmd -c -o mpath_persist.o mpath_persist.c<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -I../libmultipath -I../libmpa=
thpersist -I../libmpathcmd -c -o mpath_updatepr.o mpath_updatepr.c<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -I../libmultipath -I../libmpa=
thpersist -I../libmpathcmd -c -o mpath_pr_ioctl.o mpath_pr_ioctl.c<br>
<br>
libmpathpersist:<br>
cc -c -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werro=
r=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-=
compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fst=
ack-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&q=
uot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -fvisibility=3Dhidden -I../l=
ibdmmp -I../libmpathcmd -I/usr/include/json-c -c *.c<br>
new:<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -fvisibility=3Dhidden -I../li=
bdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp.o libdmmp.c<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -fvisibility=3Dhidden -I../li=
bdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_mp.o libdmmp_mp.=
c<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -fvisibility=3Dhidden -I../li=
bdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_pg.o libdmmp_pg.=
c<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -fvisibility=3Dhidden -I../li=
bdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_path.o libdmmp_p=
ath.c<br>
cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Dimplicit-int -Werror=
=3Dimplicit-function-<wbr>declaration -Werror=3Dformat-security -Wno-sign-c=
ompare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=3D2 -fsta=
ck-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB_STRING=3D\&qu=
ot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -fvisibility=3Dhidden -I../li=
bdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_misc.o libdmmp_m=
isc.c<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libdmmp/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 3 +--<br>
=C2=A0libmpathpersist/Makefile | 3 +--<br>
=C2=A02 files changed, 2 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/libdmmp/Makefile b/libdmmp/Makefile<br>
index c7db054..082078a 100644<br>
--- a/libdmmp/Makefile<br>
+++ b/libdmmp/Makefile<br>
@@ -22,8 +22,7 @@ LIBDEPS +=3D $(shell pkg-config --libs json-c) -L$(mpathc=
mddir) -lmpathcmd -lpthre<br>
<br>
=C2=A0all: $(LIBS) doc<br>
<br>
-$(LIBS):<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) -c $(CFLAGS) *.c<br>
+$(LIBS): $(OBJS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D=
$@ -o $@ $(OBJS) $(LIBDEPS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $@ $(DEVLIB)<br>
<br>
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile<br>
index 6ef5bab..96da639 100644<br>
--- a/libmpathpersist/Makefile<br>
+++ b/libmpathpersist/Makefile<br>
@@ -13,8 +13,7 @@ OBJS =3D mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.=
o<br>
<br>
=C2=A0all: $(LIBS)<br>
<br>
-$(LIBS):<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) -c $(CFLAGS) *.c<br>
+$(LIBS): $(OBJS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl=
,-soname=3D$@ -o $@ $(OBJS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LN) $(LIBS) $(DEVLIB)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) mpath_persistent_reserve_in.3 &gt; mpat=
h_persistent_reserve_in.3.<wbr>gz<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
</font></span></blockquote></div><br></div>

--f4030437951c170794054b61bdfe--


--===============1335032898591998189==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1335032898591998189==--
