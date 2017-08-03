From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: delete libdmmp/docs/man
 directory in make clean
Date: Thu, 3 Aug 2017 08:40:50 +0200
Message-ID: <CABr-GnfVRUF7FTjEtrQyA=3PMAhyJSugQG_FYiH3JzC=85cNkA@mail.gmail.com>
References: <20170624180613.11652-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0643382469428093837=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170624180613.11652-1-xose.vazquez@gmail.com>
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

--===============0643382469428093837==
Content-Type: multipart/alternative; boundary="001a113c58584ca0650555d3a99b"

--001a113c58584ca0650555d3a99b
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Sat, Jun 24, 2017 at 8:06 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> CC: Gris Ge <fge@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index bffc573..cdd26ed 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -57,7 +57,7 @@ uninstall:
>
>  clean:
>         $(RM) core *.a *.o *.gz *.so *.so.*
> -       $(RM) docs/man/*.3.gz
> +       $(RM) -r docs/man
>         $(MAKE) -C test clean
>
>  check: all
> --
> 2.13.1
>

--001a113c58584ca0650555d3a99b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, Jun 24, 2017 at 8:06 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">CC: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@re=
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
index bffc573..cdd26ed 100644<br>
--- a/libdmmp/Makefile<br>
+++ b/libdmmp/Makefile<br>
@@ -57,7 +57,7 @@ uninstall:<br>
<br>
=C2=A0clean:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) core *.a *.o *.gz *.so *.so.*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) docs/man/*.3.gz<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) -r docs/man<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(MAKE) -C test clean<br>
<br>
=C2=A0check: all<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.1<br>
</font></span></blockquote></div><br></div>

--001a113c58584ca0650555d3a99b--


--===============0643382469428093837==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0643382469428093837==--
