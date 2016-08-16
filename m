From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/2] multipath-tools: check for initialized
	checker before
Date: Tue, 16 Aug 2016 09:39:10 +0200
Message-ID: <CABr-GnfcV+WE_HQV8r7H5VG8o8ytkQURT-o7pQ7T9NmuW+ivyw@mail.gmail.com>
References: <1471281226-7719-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1253475569284905132=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471281226-7719-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1253475569284905132==
Content-Type: multipart/alternative; boundary=001a113fc3a0d35afb053a2b7172

--001a113fc3a0d35afb053a2b7172
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Mon, Aug 15, 2016 at 7:13 PM, Mike Christie <mchristi@redhat.com> wrote:

> This fixes a regression added with:
> 015f87b16a7797a17afd514aec46e65c2a1a2f73
>
> We can hit a race where when pathinfo is setting up a path, the path
> could have gone down already. In the DI_CHECKER chunk we then do not run
> get_state and attach a checker. Later when check_path is run
> path_offline could still return PATH_DOWN or PATH_REMOVED and
> get_state is again not run so we do not get to attach a checker. I
> was then running repair_path since the state was PATH_DOWN, and we then
> hit a segfault.
>
> This has us test if a checker is selected before running repair.
>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  libmultipath/checkers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 8976c89..fd999b0 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -213,7 +213,7 @@ void checker_put (struct checker * dst)
>
>  void checker_repair (struct checker * c)
>  {
> -       if (!c)
> +       if (!c || !checker_selected(c))
>                 return;
>
>         c->message[0] = '\0';
> --
> 2.7.2
>
>

--001a113fc3a0d35afb053a2b7172
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Aug 15, 2016 at 7:13 PM, Mike Chris=
tie <span dir=3D"ltr">&lt;<a href=3D"mailto:mchristi@redhat.com" target=3D"=
_blank">mchristi@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">This fixes a regression added with:<br>
015f87b16a7797a17afd514aec46e6<wbr>5c2a1a2f73<br>
<br>
We can hit a race where when pathinfo is setting up a path, the path<br>
could have gone down already. In the DI_CHECKER chunk we then do not run<br=
>
get_state and attach a checker. Later when check_path is run<br>
path_offline could still return PATH_DOWN or PATH_REMOVED and<br>
get_state is again not run so we do not get to attach a checker. I<br>
was then running repair_path since the state was PATH_DOWN, and we then<br>
hit a segfault.<br>
<br>
This has us test if a checker is selected before running repair.<br>
<br>
Signed-off-by: Mike Christie &lt;<a href=3D"mailto:mchristi@redhat.com">mch=
risti@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/checkers.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c<br>
index 8976c89..fd999b0 100644<br>
--- a/libmultipath/checkers.c<br>
+++ b/libmultipath/checkers.c<br>
@@ -213,7 +213,7 @@ void checker_put (struct checker * dst)<br>
<br>
=C2=A0void checker_repair (struct checker * c)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!c)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!c || !checker_selected(c))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;message[0] =3D &#39;\0&#39;;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a113fc3a0d35afb053a2b7172--


--===============1253475569284905132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1253475569284905132==--
