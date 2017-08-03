From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: fix unit to seconds in log
 message for checker timeout
Date: Thu, 3 Aug 2017 08:44:03 +0200
Message-ID: <CABr-GndUJ9wDQvmqOm8v505jNK=cRDqaqcFcCDD6A9gqkAYAmQ@mail.gmail.com>
References: <20170627151147.11776-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0252286637390910361=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170627151147.11776-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0252286637390910361==
Content-Type: multipart/alternative; boundary="001a113d29d4d02b090555d3b42b"

--001a113d29d4d02b090555d3b42b
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Tue, Jun 27, 2017 at 5:11 PM, Martin Wilck <mwilck@suse.com> wrote:

> checker_timeout is in seconds, not milliseconds, since 905281da
> "Specify checker_timeout in seconds". Fix the log messages.
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/propsel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 27f39517..4ac7edcd 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -333,11 +333,11 @@ out:
>                                 pp->dev, c->timeout);
>         }
>         else if (sysfs_get_timeout(pp, &c->timeout) > 0)
> -               condlog(3, "%s: checker timeout = %u ms (setting: kernel
> sysfs)",
> +               condlog(3, "%s: checker timeout = %u s (setting: kernel
> sysfs)",
>                                 pp->dev, c->timeout);
>         else {
>                 c->timeout = DEF_TIMEOUT;
> -               condlog(3, "%s: checker timeout = %u ms (setting:
> multipath internal)",
> +               condlog(3, "%s: checker timeout = %u s (setting: multipath
> internal)",
>                                 pp->dev, c->timeout);
>         }
>         return 0;
> --
> 2.13.1
>
>

--001a113d29d4d02b090555d3b42b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Jun 27, 2017 at 5:11 PM, Martin Wilc=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank=
">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">c=
hecker_timeout is in seconds, not milliseconds, since 905281da<br>
&quot;Specify checker_timeout in seconds&quot;. Fix the log messages.<br>
<br>
Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@s=
use.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/propsel.c | 4 ++--<br>
=C2=A01 file changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index 27f39517..4ac7edcd 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -333,11 +333,11 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, c-&gt;timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (sysfs_get_timeout(pp, &amp;c-&gt;timeo=
ut) &gt; 0)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s=
: checker timeout =3D %u ms (setting: kernel sysfs)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s=
: checker timeout =3D %u s (setting: kernel sysfs)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, c-&gt;timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;timeout =3D D=
EF_TIMEOUT;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s=
: checker timeout =3D %u ms (setting: multipath internal)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s=
: checker timeout =3D %u s (setting: multipath internal)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, c-&gt;timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113d29d4d02b090555d3b42b--


--===============0252286637390910361==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0252286637390910361==--
