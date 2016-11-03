From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: safe limit max_fds
Date: Thu, 3 Nov 2016 14:15:48 +0100
Message-ID: <CABr-Gneo0Z1jk=FFBk9p6LMEwXZC1TH9wda3Fq=39npN1igLXQ@mail.gmail.com>
References: <1477560172-8256-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7493584957040602951=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477560172-8256-1-git-send-email-peng.liang5@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: peng.liang5@zte.com.cn
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7493584957040602951==
Content-Type: multipart/alternative; boundary=001a113d972431ac400540655bb7

--001a113d972431ac400540655bb7
Content-Type: text/plain; charset=UTF-8

Hi PengLiang,

As no objection was raised, I'll merge this patch.
Can you resend with the necessary man page update explaining the new policy
for max_fds ?

Thanks.



On Thu, Oct 27, 2016 at 11:22 AM, <peng.liang5@zte.com.cn> wrote:

> From: PengLiang <peng.liang5@zte.com.cn>
>
> If user config the max_fds too small to less than actual open files of
> multipath,
> it will occur the error like "/lib/superpath/libchecktur.so: cannot open
> shared
> object file: Too many open files".
> So set a safe limit to 4096 when user config max_fds less than 4096.
>
> Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
> ---
>  libmultipath/dict.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 7c21e72..7291e0e 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -733,6 +733,9 @@ max_fds_handler(struct config *conf, vector strvec)
>         if (conf->max_fds > max_fds)
>                 conf->max_fds = max_fds;
>
> +       if (conf->max_fds < 4096)
> +               conf->max_fds = 4096;
> +
>         FREE(buff);
>
>         return r;
> --
> 2.8.1.windows.1
>
>

--001a113d972431ac400540655bb7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi PengLiang,<div><br></div><div>As no objection was raise=
d, I&#39;ll merge this patch.</div><div>Can you resend with the necessary m=
an page update explaining the new policy for max_fds ?</div><div><br></div>=
<div>Thanks.<br><div><br></div><div><br></div></div></div><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">On Thu, Oct 27, 2016 at 11:22 AM, =
 <span dir=3D"ltr">&lt;<a href=3D"mailto:peng.liang5@zte.com.cn" target=3D"=
_blank">peng.liang5@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">From: PengLiang &lt;<a href=3D"mailto:peng.liang5@zte.com.cn"=
>peng.liang5@zte.com.cn</a>&gt;<br>
<br>
If user config the max_fds too small to less than actual open files of mult=
ipath,<br>
it will occur the error like &quot;/lib/superpath/libchecktur.<wbr>so: cann=
ot open shared<br>
object file: Too many open files&quot;.<br>
So set a safe limit to 4096 when user config max_fds less than 4096.<br>
<br>
Signed-off-by: PengLiang &lt;<a href=3D"mailto:peng.liang5@zte.com.cn">peng=
.liang5@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/dict.c | 3 +++<br>
=C2=A01 file changed, 3 insertions(+)<br>
<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index 7c21e72..7291e0e 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -733,6 +733,9 @@ max_fds_handler(struct config *conf, vector strvec)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;max_fds &gt; max_fds)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;max_fds =
=3D max_fds;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;max_fds &lt; 4096)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;max_fds =
=3D 4096;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(buff);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113d972431ac400540655bb7--


--===============7493584957040602951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7493584957040602951==--
