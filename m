From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: space \ at Makefile.inc
Date: Wed, 19 Oct 2016 08:08:40 +0200
Message-ID: <CABr-GncgR6DHD-z3hRF9SawH8uydC8e6hQs7R7Y7-nhVKLzYsw@mail.gmail.com>
References: <20161018224941.4451-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7993439726646747482=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161018224941.4451-1-xose.vazquez@gmail.com>
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

--===============7993439726646747482==
Content-Type: multipart/alternative; boundary=94eb2c0dbca803223f053f31a4c2

--94eb2c0dbca803223f053f31a4c2
Content-Type: text/plain; charset=UTF-8

Merged.

On Wed, Oct 19, 2016 at 12:49 AM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  Makefile.inc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile.inc b/Makefile.inc
> index be6b2bc..1cc8f44 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -62,7 +62,7 @@ LN            = ln -sf
>  INSTALL_PROGRAM        = install
>
>  OPTFLAGS       = -O2 -g -pipe -Wall -Wextra -Wformat=2 \
> -                 -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered\
> +                 -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
>                   -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector \
>                   --param=ssp-buffer-size=4
>
> --
> 2.10.1
>
>

--94eb2c0dbca803223f053f31a4c2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Oct 19, 2016 at 12:49 AM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.c=
om">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0Makefile.inc | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/Makefile.inc b/Makefile.inc<br>
index be6b2bc..1cc8f44 100644<br>
--- a/Makefile.inc<br>
+++ b/Makefile.inc<br>
@@ -62,7 +62,7 @@ LN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D ln -sf<br=
>
=C2=A0INSTALL_PROGRAM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D install<br>
<br>
=C2=A0OPTFLAGS=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D -O2 -g -pipe -Wall -Wextra -Wf=
ormat=3D2 \<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Wno-sign-co=
mpare -Wno-unused-parameter -Wno-clobbered\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Wno-sign-co=
mpare -Wno-unused-parameter -Wno-clobbered \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Wp,-D_FORTI=
FY_SOURCE=3D2 -fstack-protector \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 --param=3Dss=
p-buffer-size=3D4<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c0dbca803223f053f31a4c2--


--===============7993439726646747482==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7993439726646747482==--
