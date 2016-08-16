From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: use "+=" instead of only
 "=" for variables in Makefile
Date: Tue, 16 Aug 2016 09:42:50 +0200
Message-ID: <CABr-GnfKT+hBF7XJBfuO81EKxTDeuMURpO6V_6Q5zp1wzxrfpA@mail.gmail.com>
References: <1471023901-12515-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2593921681837510244=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471023901-12515-1-git-send-email-xose.vazquez@gmail.com>
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

--===============2593921681837510244==
Content-Type: multipart/alternative; boundary=001a1142c2f6f0a334053a2b7ebf

--001a1142c2f6f0a334053a2b7ebf
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Fri, Aug 12, 2016 at 7:45 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  kpartx/Makefile       | 2 +-
>  libmultipath/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 6f32680..8af0dc6 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -5,7 +5,7 @@ include ../Makefile.inc
>
>  CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
>
> -LDFLAGS = -ldevmapper
> +LDFLAGS += -ldevmapper
>
>  LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie'
> /usr/include/libdevmapper.h)
>
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 3a20f8e..92f130c 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -9,7 +9,7 @@ LIBS = $(DEVLIB).$(SONAME)
>
>  CFLAGS += -I$(mpathcmddir)
>
> -LIBDEPS = -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
> +LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
>
>  ifdef SYSTEMD
>         CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
> --
> 2.7.4
>
>

--001a1142c2f6f0a334053a2b7ebf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Fri, Aug 12, 2016 at 7:45 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe=
.varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
=C2=A0libmultipath/Makefile | 2 +-<br>
=C2=A02 files changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index 6f32680..8af0dc6 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -5,7 +5,7 @@ include ../Makefile.inc<br>
<br>
=C2=A0CFLAGS +=3D -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64<br>
<br>
-LDFLAGS =3D -ldevmapper<br>
+LDFLAGS +=3D -ldevmapper<br>
<br>
=C2=A0LIBDM_API_COOKIE =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+dm_tas=
k_<wbr>set_cookie&#39; /usr/include/libdevmapper.h)<br>
<br>
diff --git a/libmultipath/Makefile b/libmultipath/Makefile<br>
index 3a20f8e..92f130c 100644<br>
--- a/libmultipath/Makefile<br>
+++ b/libmultipath/Makefile<br>
@@ -9,7 +9,7 @@ LIBS =3D $(DEVLIB).$(SONAME)<br>
<br>
=C2=A0CFLAGS +=3D -I$(mpathcmddir)<br>
<br>
-LIBDEPS =3D -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd<=
br>
+LIBDEPS +=3D -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd=
<br>
<br>
=C2=A0ifdef SYSTEMD<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DUSE_SYSTEMD=3D$(SYSTEMD)<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142c2f6f0a334053a2b7ebf--


--===============2593921681837510244==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2593921681837510244==--
