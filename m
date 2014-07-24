From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 09/12] orphan paths on failed add
Date: Thu, 24 Jul 2014 10:45:14 +0200
Message-ID: <CABr-GncBUJy72Dv4FpU0K=P=FesNZyJq1z0vu-kbjwPdJUrrKw@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-10-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1624865946414003185=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-10-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1624865946414003185==
Content-Type: multipart/alternative; boundary=047d7b2e14a5af6b2404feec79bb

--047d7b2e14a5af6b2404feec79bb
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks


On Mon, Jun 30, 2014 at 7:14 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> When multipathd tries to add a path but fails doing the table reload, it
> wasn't orphaning the path.  This can cause problems later if multipathd
> tries to switch the pathgroup of this path which isn't actually part of
> the multipath device.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 337bfe9..3afed62 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -561,7 +561,7 @@ rescan:
>                 return 0;
>         }
>         else
> -               return 1;
> +               goto fail;
>
>  fail_map:
>         remove_map(mpp, vecs, 1);
> --
> 1.8.3.1
>
>

--047d7b2e14a5af6b2404feec79bb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks</div></div><div class=3D"gmail_extra">=
<br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:14 AM, Benjami=
n Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" ta=
rget=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">When multipathd tries to add a path but fail=
s doing the table reload, it<br>
wasn&#39;t orphaning the path. =C2=A0This can cause problems later if multi=
pathd<br>
tries to switch the pathgroup of this path which isn&#39;t actually part of=
<br>
the multipath device.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 337bfe9..3afed62 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -561,7 +561,7 @@ rescan:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto fail;<br>
<br>
=C2=A0fail_map:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 remove_map(mpp, vecs, 1);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b2e14a5af6b2404feec79bb--


--===============1624865946414003185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1624865946414003185==--
