From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Typo in condlog in
	select_flush_on_last_del
Date: Tue, 2 Sep 2014 21:04:49 +0200
Message-ID: <CABr-Gnev4ZdNBz1OWxWQG1Ejqujq6nqwgnAMKNMQkvdng_giMg@mail.gmail.com>
References: <1409653660-21574-1-git-send-email-rep.dot.nop@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8234268497390517611=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1409653660-21574-1-git-send-email-rep.dot.nop@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8234268497390517611==
Content-Type: multipart/alternative; boundary=047d7b34340c265f71050219cb76

--047d7b34340c265f71050219cb76
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.


On Tue, Sep 2, 2014 at 12:27 PM, Bernhard Reutner-Fischer <
rep.dot.nop@gmail.com> wrote:

> s/controler/controller/g
>
> Signed-off-by: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
> ---
>  libmultipath/propsel.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index ee6cea6..e23d65c 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -630,7 +630,7 @@ select_flush_on_last_del(struct multipath *mp)
>         }
>         if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
>                 mp->flush_on_last_del = mp->hwe->flush_on_last_del;
> -               condlog(3, "%s: flush_on_last_del = %i (controler
> setting)",
> +               condlog(3, "%s: flush_on_last_del = %i (controller
> setting)",
>                         mp->alias, mp->flush_on_last_del);
>                 return 0;
>         }
> --
> 1.7.10.4
>
>

--047d7b34340c265f71050219cb76
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Tue, Sep 2, 2014 at 12:27 PM, Bernha=
rd Reutner-Fischer <span dir=3D"ltr">&lt;<a href=3D"mailto:rep.dot.nop@gmai=
l.com" target=3D"_blank">rep.dot.nop@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">s/controler/controller/g<br>
<br>
Signed-off-by: Bernhard Reutner-Fischer &lt;<a href=3D"mailto:rep.dot.nop@g=
mail.com">rep.dot.nop@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/propsel.c |=C2=A0 =C2=A0 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index ee6cea6..e23d65c 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -630,7 +630,7 @@ select_flush_on_last_del(struct multipath *mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;hwe &amp;&amp; mp-&gt;hwe-&gt;flush_=
on_last_del !=3D FLUSH_UNDEF) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;flush_on_las=
t_del =3D mp-&gt;hwe-&gt;flush_on_last_del;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s=
: flush_on_last_del =3D %i (controler setting)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s=
: flush_on_last_del =3D %i (controller setting)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 mp-&gt;alias, mp-&gt;flush_on_last_del);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.7.10.4<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b34340c265f71050219cb76--


--===============8234268497390517611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8234268497390517611==--
