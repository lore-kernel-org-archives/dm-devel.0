From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add missing "-l" flag for
	pthread in libdmmp/Makefile
Date: Thu, 23 Mar 2017 09:32:47 +0100
Message-ID: <CABr-GnfcKtr0zjeLGJ_nTBDT-=q03mEKPzLTEuidYjWTN8fHcg@mail.gmail.com>
References: <20170317141523.6421-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3314585174278642260=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170317141523.6421-1-xose.vazquez@gmail.com>
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

--===============3314585174278642260==
Content-Type: multipart/alternative; boundary=001a1137a09ac98bf4054b61b86a

--001a1137a09ac98bf4054b61b86a
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks

On Fri, Mar 17, 2017 at 3:15 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Gris Ge <fge@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index aaff285..c7db054 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -18,7 +18,7 @@ OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o
> libdmmp_path.o libdmmp_misc.o
>  CFLAGS += -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
>           $(shell pkg-config --cflags json-c)
>
> -LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd
> -pthread
> +LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd
> -lpthread
>
>  all: $(LIBS) doc
>
> --
> 2.12.0
>
>

--001a1137a09ac98bf4054b61b86a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Mar 17, 2017 at 3:15 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">Cc: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@re=
dhat.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libdmmp/Makefile | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libdmmp/Makefile b/libdmmp/Makefile<br>
index aaff285..c7db054 100644<br>
--- a/libdmmp/Makefile<br>
+++ b/libdmmp/Makefile<br>
@@ -18,7 +18,7 @@ OBJS =3D libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path=
.o libdmmp_misc.o<br>
=C2=A0CFLAGS +=3D -fvisibility=3Dhidden -I$(libdmmpdir) -I$(mpathcmddir) \<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(shell pkg-config --cflags json-c)<br>
<br>
-LIBDEPS +=3D $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd=
 -pthread<br>
+LIBDEPS +=3D $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd=
 -lpthread<br>
<br>
=C2=A0all: $(LIBS) doc<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.12.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a1137a09ac98bf4054b61b86a--


--===============3314585174278642260==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3314585174278642260==--
