From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: clarify no_path_retry in
	multipath.conf.5
Date: Wed, 19 Oct 2016 08:06:40 +0200
Message-ID: <CABr-GncE+QSO3XEJr0igix112=oLpOsggDD3oS6FKD-CPB4gNg@mail.gmail.com>
References: <20161017211815.2581-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0254730327617210318=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161017211815.2581-1-xose.vazquez@gmail.com>
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

--===============0254730327617210318==
Content-Type: multipart/alternative; boundary=001a11401702d8015b053f319cac

--001a11401702d8015b053f319cac
Content-Type: text/plain; charset=UTF-8

Merged.

On Mon, Oct 17, 2016 at 11:18 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> no_path_retry    Specify what to do when all paths are down. Possible
> values are:
>
>     value > 0   number of retries until disable I/O queueing.
>
>     fail        for immediate failure (no I/O queueing).
>
>     queue       for never stop I/O queueing. Similar to queue_if_no_path.
>
>     See KNOWN ISSUES.
>
>     Default value is: fail
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 367688e..4ab2917 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -498,14 +498,21 @@ Default value is: \fBuniform\fR
>  .
>  .TP
>  .B no_path_retry
> -Specify the number of retries until disable queueing, or
> +Specify what to do when all paths are down. Possible values are:
> +.RS
> +.TP 12
> +.I value > 0
> +number of retries until disable I/O queueing.
> +.TP
>  .I fail
> -for immediate failure (no queueing),
> +for immediate failure (no I/O queueing).
> +.TP
>  .I queue
> -for never stop queueing. If unset no queueing is attempted. See KNOWN
> ISSUES.
> -.RS
> +for never stop I/O queueing. Similar to \fIqueue_if_no_path\fR.
>  .TP
> -Default value is: \fB<unset>\fR
> +See KNOWN ISSUES.
> +.TP
> +Default value is: \fBfail\fR
>  .RE
>  .
>  .
> --
> 2.10.1
>
>

--001a11401702d8015b053f319cac
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Mon, Oct 17, 2016 at 11:18 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">no_path_retry=C2=A0 =C2=A0 Specify what to do when all paths are down. Po=
ssible values are:<br>
<br>
=C2=A0 =C2=A0 value &gt; 0=C2=A0 =C2=A0number of retries until disable I/O =
queueing.<br>
<br>
=C2=A0 =C2=A0 fail=C2=A0 =C2=A0 =C2=A0 =C2=A0 for immediate failure (no I/O=
 queueing).<br>
<br>
=C2=A0 =C2=A0 queue=C2=A0 =C2=A0 =C2=A0 =C2=A0for never stop I/O queueing. =
Similar to queue_if_no_path.<br>
<br>
=C2=A0 =C2=A0 See KNOWN ISSUES.<br>
<br>
=C2=A0 =C2=A0 Default value is: fail<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 17 ++++++++++++-----<br>
=C2=A01 file changed, 12 insertions(+), 5 deletions(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 367688e..4ab2917 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -498,14 +498,21 @@ Default value is: \fBuniform\fR<br>
=C2=A0.<br>
=C2=A0.TP<br>
=C2=A0.B no_path_retry<br>
-Specify the number of retries until disable queueing, or<br>
+Specify what to do when all paths are down. Possible values are:<br>
+.RS<br>
+.TP 12<br>
+.I value &gt; 0<br>
+number of retries until disable I/O queueing.<br>
+.TP<br>
=C2=A0.I fail<br>
-for immediate failure (no queueing),<br>
+for immediate failure (no I/O queueing).<br>
+.TP<br>
=C2=A0.I queue<br>
-for never stop queueing. If unset no queueing is attempted. See KNOWN ISSU=
ES.<br>
-.RS<br>
+for never stop I/O queueing. Similar to \fIqueue_if_no_path\fR.<br>
=C2=A0.TP<br>
-Default value is: \fB&lt;unset&gt;\fR<br>
+See KNOWN ISSUES.<br>
+.TP<br>
+Default value is: \fBfail\fR<br>
=C2=A0.RE<br>
=C2=A0.<br>
=C2=A0.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11401702d8015b053f319cac--


--===============0254730327617210318==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0254730327617210318==--
