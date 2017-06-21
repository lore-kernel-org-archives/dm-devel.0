From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add limits.h to
	kpartx/lopart.c
Date: Wed, 21 Jun 2017 12:34:09 +0200
Message-ID: <CABr-Gndpty57XqnCUSPFCOZaKP+77ZiOKHbcZukuz=i=MN3Z3g@mail.gmail.com>
References: <20170517235844.11576-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8048914778602711332=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517235844.11576-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============8048914778602711332==
Content-Type: multipart/alternative; boundary="001a11c10ec2967bf5055275e895"

--001a11c10ec2967bf5055275e895
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged,
Thanks.

On Thu, May 18, 2017 at 1:58 AM, Xose Vazquez Perez <xose.vazquez@gmail.com=
>
wrote:

> musl libc complains of
> lopart.c:76:12: error: =E2=80=98PATH_MAX=E2=80=99 undeclared (first use i=
n this function)
>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  kpartx/lopart.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kpartx/lopart.c b/kpartx/lopart.c
> index 7005445..4e6dab4 100644
> --- a/kpartx/lopart.c
> +++ b/kpartx/lopart.c
> @@ -29,6 +29,7 @@
>  #include <dirent.h>
>  #include <sys/sysmacros.h>
>  #include <linux/loop.h>
> +#include <limits.h>
>
>  #include "lopart.h"
>  #include "xstrncpy.h"
> --
> 2.13.0
>
>

--001a11c10ec2967bf5055275e895
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, May 18, 2017 at 1:58 AM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">musl libc complains of<br>
lopart.c:76:12: error: =E2=80=98PATH_MAX=E2=80=99 undeclared (first use in =
this function)<br>
<br>
Cc: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>=
&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0kpartx/lopart.c | 1 +<br>
=C2=A01 file changed, 1 insertion(+)<br>
<br>
diff --git a/kpartx/lopart.c b/kpartx/lopart.c<br>
index 7005445..4e6dab4 100644<br>
--- a/kpartx/lopart.c<br>
+++ b/kpartx/lopart.c<br>
@@ -29,6 +29,7 @@<br>
=C2=A0#include &lt;dirent.h&gt;<br>
=C2=A0#include &lt;sys/sysmacros.h&gt;<br>
=C2=A0#include &lt;linux/loop.h&gt;<br>
+#include &lt;limits.h&gt;<br>
<br>
=C2=A0#include &quot;lopart.h&quot;<br>
=C2=A0#include &quot;xstrncpy.h&quot;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c10ec2967bf5055275e895--


--===============8048914778602711332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8048914778602711332==--
