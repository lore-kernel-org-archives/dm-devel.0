From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 03/12] enable gcc format-security check
Date: Tue, 1 Jul 2014 20:48:36 +0200
Message-ID: <CABr-GndLda8XMxN5h3PJ7gwvMutkaPGf2mhAxJq4W_+3FBbexw@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-4-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6786205033069124915=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-4-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6786205033069124915==
Content-Type: multipart/alternative; boundary=089e0153821c2674fe04fd263953

--089e0153821c2674fe04fd263953
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> -Wformat-security warns about format-strigs that represent possible
> security problems.  This is check is now enabled for fedora builds, and it
> seems like a reasonable thing to always be checking.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile.inc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile.inc b/Makefile.inc
> index 0669d32..1486721 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -46,7 +46,7 @@ GZIP        = gzip -9 -c
>  INSTALL_PROGRAM = install
>
>  ifndef RPM_OPT_FLAGS
> -       RPM_OPT_FLAGS = -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2
> -fexceptions -fstack-protector --param=ssp-buffer-size=4
> +       RPM_OPT_FLAGS = -O2 -g -pipe -Wformat-security -Wall
> -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong
> --param=ssp-buffer-size=4
>  endif
>
>  OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
> --
> 1.8.3.1
>
>

--089e0153821c2674fe04fd263953
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Applied.<br></div>Thanks.<br></div><div class=3D"gmai=
l_extra"><br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:13 AM=
, Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redha=
t.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">-Wformat-security warns about format-strigs =
that represent possible<br>
security problems. =C2=A0This is check is now enabled for fedora builds, an=
d it<br>
seems like a reasonable thing to always be checking.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0Makefile.inc | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/Makefile.inc b/Makefile.inc<br>
index 0669d32..1486721 100644<br>
--- a/Makefile.inc<br>
+++ b/Makefile.inc<br>
@@ -46,7 +46,7 @@ GZIP =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D gzip -9 -c<br>
=C2=A0INSTALL_PROGRAM =3D install<br>
<br>
=C2=A0ifndef RPM_OPT_FLAGS<br>
- =C2=A0 =C2=A0 =C2=A0 RPM_OPT_FLAGS =3D -O2 -g -pipe -Wall -Wp,-D_FORTIFY_=
SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4<br>
+ =C2=A0 =C2=A0 =C2=A0 RPM_OPT_FLAGS =3D -O2 -g -pipe -Wformat-security -Wa=
ll -Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector-strong --param=
=3Dssp-buffer-size=3D4<br>
=C2=A0endif<br>
<br>
=C2=A0OPTFLAGS =C2=A0 =C2=A0 =3D $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototy=
pes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--089e0153821c2674fe04fd263953--


--===============6786205033069124915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6786205033069124915==--
