From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: fix a format warning in
	multipathd.8
Date: Wed, 21 Jun 2017 12:27:12 +0200
Message-ID: <CABr-GneZqaYOnPD1tDOWcDHpw+cqyJ+m7tq4AoKrGZiwRcB5cA@mail.gmail.com>
References: <20170526161920.8407-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6224279903945947999=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170526161920.8407-1-xose.vazquez@gmail.com>
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

--===============6224279903945947999==
Content-Type: multipart/alternative; boundary="94eb2c11f8a2b0b26d055275cf86"

--94eb2c11f8a2b0b26d055275cf86
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Fri, May 26, 2017 at 6:19 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> warning: macro `list' not defined
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipathd/multipathd.8 | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> index 4c765af..2615728 100644
> --- a/multipathd/multipathd.8
> +++ b/multipathd/multipathd.8
> @@ -121,8 +121,7 @@ Show the current multipath topology. Same as
> '\fImultipath \-ll\fR'.
>  .TP
>  .B list|show map|multipath $map topology
>  Show topology of a single multipath device specified by $map, for example
> -36005076303ffc56200000000000010aa. This map could be obtained from
> -'\fIlist maps\fR'.
> +36005076303ffc56200000000000010aa. This map could be obtained from
> '\fIlist maps\fR'.
>  .
>  .TP
>  .B list|show wildcards
> --
> 2.13.0
>
>

--94eb2c11f8a2b0b26d055275cf86
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, May 26, 2017 at 6:19 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">warning: macro `list&#39; not defined<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipathd/multipathd.8 | 3 +--<br>
=C2=A01 file changed, 1 insertion(+), 2 deletions(-)<br>
<br>
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8<br>
index 4c765af..2615728 100644<br>
--- a/multipathd/multipathd.8<br>
+++ b/multipathd/multipathd.8<br>
@@ -121,8 +121,7 @@ Show the current multipath topology. Same as &#39;\fImu=
ltipath \-ll\fR&#39;.<br>
=C2=A0.TP<br>
=C2=A0.B list|show map|multipath $map topology<br>
=C2=A0Show topology of a single multipath device specified by $map, for exa=
mple<br>
-<wbr>36005076303ffc5620000000000001<wbr>0aa. This map could be obtained fr=
om<br>
-&#39;\fIlist maps\fR&#39;.<br>
+<wbr>36005076303ffc5620000000000001<wbr>0aa. This map could be obtained fr=
om &#39;\fIlist maps\fR&#39;.<br>
=C2=A0.<br>
=C2=A0.TP<br>
=C2=A0.B list|show wildcards<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.0<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c11f8a2b0b26d055275cf86--


--===============6224279903945947999==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6224279903945947999==--
