From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath/checkers/tur: Fix a recently
	introduced deadlock
Date: Tue, 11 Oct 2016 08:12:54 +0200
Message-ID: <CABr-GndZ=UnjVfGUrHJ2czGZJe5iFN0xpQRBrhFtG0_6xjeeVA@mail.gmail.com>
References: <424be81f-7f4b-db0f-a09d-cd4f14a8407a@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6622163736839813780=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <424be81f-7f4b-db0f-a09d-cd4f14a8407a@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6622163736839813780==
Content-Type: multipart/alternative; boundary=001a1142b8646f6733053e90c4c4

--001a1142b8646f6733053e90c4c4
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Oct 11, 2016 at 1:12 AM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> Avoid that the tur_devt() call from libcheck_check() hangs.
>
> Fixes: commit 873be9fef222 ("libmultipath/checkers/tur: Serialize
> tur_checker_context.devt accesses")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmultipath/checkers/tur.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index a7a70f6..81206e4 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -64,6 +64,7 @@ static const char *tur_devt(char *devt_buf, int size,
>  int libcheck_init (struct checker * c)
>  {
>         struct tur_checker_context *ct;
> +       pthread_mutexattr_t attr;
>
>         ct = malloc(sizeof(struct tur_checker_context));
>         if (!ct)
> @@ -74,7 +75,10 @@ int libcheck_init (struct checker * c)
>         ct->fd = -1;
>         ct->holders = 1;
>         pthread_cond_init_mono(&ct->active);
> -       pthread_mutex_init(&ct->lock, NULL);
> +       pthread_mutexattr_init(&attr);
> +       pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
> +       pthread_mutex_init(&ct->lock, &attr);
> +       pthread_mutexattr_destroy(&attr);
>         pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
>         c->context = ct;
>
> --
> 2.10.0
>
>

--001a1142b8646f6733053e90c4c4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Oct 11, 2016 at 1:12 AM, Bart Van As=
sche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" ta=
rget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">Avoid that the tur_devt() call from libcheck_check(=
) hangs.<br>
<br>
Fixes: commit 873be9fef222 (&quot;libmultipath/checkers/tur: Serialize tur_=
checker_context.devt accesses&quot;)<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/checkers/tur.c | 6 +++++-<br>
=C2=A01 file changed, 5 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c<br>
index a7a70f6..81206e4 100644<br>
--- a/libmultipath/checkers/tur.c<br>
+++ b/libmultipath/checkers/tur.c<br>
@@ -64,6 +64,7 @@ static const char *tur_devt(char *devt_buf, int size,<br>
=C2=A0int libcheck_init (struct checker * c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct tur_checker_context *ct;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutexattr_t attr;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct =3D malloc(sizeof(struct tur_checker_context=
));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ct)<br>
@@ -74,7 +75,10 @@ int libcheck_init (struct checker * c)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;fd =3D -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;holders =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cond_init_mono(&amp;ct-&gt;<wbr>active)=
;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_init(&amp;ct-&gt;lock, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutexattr_init(&amp;attr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutexattr_settype(&amp;<wbr>attr, PTHRE=
AD_MUTEX_RECURSIVE);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_init(&amp;ct-&gt;lock, &amp;attr)=
;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutexattr_destroy(&amp;<wbr>attr);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_spin_init(&amp;ct-&gt;hldr_<wbr>lock, P=
THREAD_PROCESS_PRIVATE);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;context =3D ct;<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.10.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142b8646f6733053e90c4c4--


--===============6622163736839813780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6622163736839813780==--
