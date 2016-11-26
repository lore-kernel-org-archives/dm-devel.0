From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: ensure dev_loss_tmo will be
 update to MAX_DEV_LOSS_TMO if no_path_retry set to queue
Date: Sat, 26 Nov 2016 10:05:10 +0100
Message-ID: <CABr-GndR+JcGnobdqYNiN3jCLMKhLjHfrBFjHfjnrO0icAkJYA@mail.gmail.com>
References: <1480055764-11124-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5386402753195583397=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1480055764-11124-1-git-send-email-peng.liang5@zte.com.cn>
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

--===============5386402753195583397==
Content-Type: multipart/alternative; boundary=001a113d972431997605423089fa

--001a113d972431997605423089fa
Content-Type: text/plain; charset=UTF-8

Applied, thanks.

On Fri, Nov 25, 2016 at 7:36 AM, <peng.liang5@zte.com.cn> wrote:

> From: PengLiang <peng.liang5@zte.com.cn>
>
> If no_path_retry set to queue, we should make sure dev_loss_tmo update to
> MAX_DEV_LOSS_TMO.
> But, it will be limit to 600 if fast_io_fail_tmo set to off or 0 meanwhile.
>
> Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
> ---
>  libmultipath/discovery.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index aaa915c..05b0842 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -608,7 +608,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path
> *pp)
>                                 goto out;
>                         }
>                 }
> -       } else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO) {
> +       } else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO &&
> +               mpp->no_path_retry != NO_PATH_RETRY_QUEUE) {
>                 condlog(3, "%s: limiting dev_loss_tmo to %d, since "
>                         "fast_io_fail is not set",
>                         rport_id, DEFAULT_DEV_LOSS_TMO);
> --
> 2.8.1.windows.1
>
>

--001a113d972431997605423089fa
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied, thanks.</div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Fri, Nov 25, 2016 at 7:36 AM,  <span dir=3D"ltr">&=
lt;<a href=3D"mailto:peng.liang5@zte.com.cn" target=3D"_blank">peng.liang5@=
zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">From: Pe=
ngLiang &lt;<a href=3D"mailto:peng.liang5@zte.com.cn">peng.liang5@zte.com.c=
n</a>&gt;<br>
<br>
If no_path_retry set to queue, we should make sure dev_loss_tmo update to M=
AX_DEV_LOSS_TMO.<br>
But, it will be limit to 600 if fast_io_fail_tmo set to off or 0 meanwhile.=
<br>
<br>
Signed-off-by: PengLiang &lt;<a href=3D"mailto:peng.liang5@zte.com.cn">peng=
.liang5@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/discovery.c | 3 ++-<br>
=C2=A01 file changed, 2 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index aaa915c..05b0842 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -608,7 +608,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path =
*pp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (mpp-&gt;dev_loss &gt; DEFAULT_DEV_LO=
SS_TMO) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (mpp-&gt;dev_loss &gt; DEFAULT_DEV_LO=
SS_TMO &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;no_path_ret=
ry !=3D NO_PATH_RETRY_QUEUE) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s=
: limiting dev_loss_tmo to %d, since &quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &quot;fast_io_fail is not set&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rport_id, DEFAULT_DEV_LOSS_TMO);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113d972431997605423089fa--


--===============5386402753195583397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5386402753195583397==--
