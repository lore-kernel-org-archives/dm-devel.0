From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace <wait.h> with
	<sys/wait.h>
Date: Fri, 22 Jul 2016 11:41:22 +0200
Message-ID: <CABr-GneEmUSpB8LnnDPxk7hTANHJkqKqXSBW+6HbmreRK1q3Ew@mail.gmail.com>
References: <1469138475-24059-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7851776187636284384=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469138475-24059-1-git-send-email-xose.vazquez@gmail.com>
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

--===============7851776187636284384==
Content-Type: multipart/alternative; boundary=001a114109cec7b6860538363c7f

--001a114109cec7b6860538363c7f
Content-Type: text/plain; charset=UTF-8

I merged all the pending 'include'-related patches.
Thanks.

On Fri, Jul 22, 2016 at 12:01 AM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> The standard place of wait.h is under /usr/include/sys/
> Spotted by musl libc.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1799cbe..337ec87 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -7,7 +7,7 @@
>  #include <unistd.h>
>  #include <sys/stat.h>
>  #include <libdevmapper.h>
> -#include <wait.h>
> +#include <sys/wait.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <fcntl.h>
> --
> 2.7.4
>
>

--001a114109cec7b6860538363c7f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I merged all the pending &#39;include&#39;-related patches=
.<div>Thanks.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">On Fri, Jul 22, 2016 at 12:01 AM, Xose Vazquez Perez <span dir=3D"l=
tr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.va=
zquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">The=
 standard place of wait.h is under /usr/include/sys/<br>
Spotted by musl libc.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 1799cbe..337ec87 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -7,7 +7,7 @@<br>
=C2=A0#include &lt;unistd.h&gt;<br>
=C2=A0#include &lt;sys/stat.h&gt;<br>
=C2=A0#include &lt;libdevmapper.h&gt;<br>
-#include &lt;wait.h&gt;<br>
+#include &lt;sys/wait.h&gt;<br>
=C2=A0#include &lt;sys/mman.h&gt;<br>
=C2=A0#include &lt;sys/types.h&gt;<br>
=C2=A0#include &lt;fcntl.h&gt;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114109cec7b6860538363c7f--


--===============7851776187636284384==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7851776187636284384==--
