From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix typo that breaks failure path
Date: Fri, 22 Jul 2016 11:59:49 +0200
Message-ID: <CABr-GndZBw7edOp=H-rhcSShaE=2oeLBj-Q2TauW5ASXQ9gOpQ@mail.gmail.com>
References: <1469134780-13163-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0800159088020618667=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469134780-13163-1-git-send-email-bmarzins@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0800159088020618667==
Content-Type: multipart/alternative; boundary=001a114109cedbd9f20538367ef7

--001a114109cedbd9f20538367ef7
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Thu, Jul 21, 2016 at 10:59 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> There wasn't supposed to be a semicolon after the "else" when checking
> paths in checkerloop().
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index c129298..d90d856 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1790,7 +1790,7 @@ checkerloop (void *ap)
>                                         vector_del_slot(vecs->pathvec, i);
>                                         free_path(pp);
>                                         i--;
> -                               } else;
> +                               } else
>                                         num_paths += rc;
>                         }
>                         lock_cleanup_pop(vecs->lock);
> --
> 1.8.3.1
>
>

--001a114109cedbd9f20538367ef7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, Jul 21, 2016 at 10:59 PM, Benjamin M=
arzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" targe=
t=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">There wasn&#39;t supposed to be a semicolon after the &quot;e=
lse&quot; when checking<br>
paths in checkerloop().<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index c129298..d90d856 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1790,7 +1790,7 @@ checkerloop (void *ap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vector_d=
el_slot(vecs-&gt;pathvec, i);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_pat=
h(pp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i--;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_path=
s +=3D rc;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 lock_cleanup_pop(vecs-&gt;lock);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a114109cedbd9f20538367ef7--


--===============0800159088020618667==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0800159088020618667==--
