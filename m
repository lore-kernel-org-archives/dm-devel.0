From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: remove unnecessary condition
	in checker_repair
Date: Sun, 20 Nov 2016 14:37:33 +0100
Message-ID: <CABr-Gnfbi6T03Rw=g2WufrX5La6958gNtwfeOi0VM7L9VoPXXg@mail.gmail.com>
References: <1478509055-7648-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1248102147589771617=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478509055-7648-1-git-send-email-peng.liang5@zte.com.cn>
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

--===============1248102147589771617==
Content-Type: multipart/alternative; boundary=94eb2c1ab7b84542000541bba46d

--94eb2c1ab7b84542000541bba46d
Content-Type: text/plain; charset=UTF-8

Merged,
thanks.

On Mon, Nov 7, 2016 at 9:57 AM, <peng.liang5@zte.com.cn> wrote:

> From: PengLiang <peng.liang5@zte.com.cn>
>
> The checker's validity is an unnecessary checking. It will be checked in
> checker_selected.
>
> Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
> ---
>  libmultipath/checkers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index fd999b0..05e024f 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -213,7 +213,7 @@ void checker_put (struct checker * dst)
>
>  void checker_repair (struct checker * c)
>  {
> -       if (!c || !checker_selected(c))
> +       if (!checker_selected(c))
>                 return;
>
>         c->message[0] = '\0';
> --
> 2.8.1.windows.1
>
>
>

--94eb2c1ab7b84542000541bba46d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Nov 7, 2016 at 9:57 AM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:peng.liang5@zte.com.cn" target=3D"_blank">pe=
ng.liang5@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">From: PengLiang &lt;<a href=3D"mailto:peng.liang5@zte.com.cn">peng.liang5=
@zte.com.cn</a>&gt;<br>
<br>
The checker&#39;s validity is an unnecessary checking. It will be checked i=
n checker_selected.<br>
<br>
Signed-off-by: PengLiang &lt;<a href=3D"mailto:peng.liang5@zte.com.cn">peng=
.liang5@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/checkers.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c<br>
index fd999b0..05e024f 100644<br>
--- a/libmultipath/checkers.c<br>
+++ b/libmultipath/checkers.c<br>
@@ -213,7 +213,7 @@ void checker_put (struct checker * dst)<br>
<br>
=C2=A0void checker_repair (struct checker * c)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!c || !checker_selected(c))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!checker_selected(c))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;message[0] =3D &#39;\0&#39;;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1ab7b84542000541bba46d--


--===============1248102147589771617==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1248102147589771617==--
