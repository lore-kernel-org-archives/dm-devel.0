From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/2] libmultipath/checkers/{rbd,
 tur}: Fix pthread_cond_signal() calls
Date: Mon, 3 Oct 2016 13:52:33 +0200
Message-ID: <CABr-Gncqe2b79FJJC1J9ArVhjGkWva160NsFmNh8RxDiW23e_g@mail.gmail.com>
References: <55a58c33-1edb-548d-f68b-d25cea442650@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7803609453563906126=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55a58c33-1edb-548d-f68b-d25cea442650@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

--===============7803609453563906126==
Content-Type: multipart/alternative; boundary=001a11401be86206b1053df494e2

--001a11401be86206b1053df494e2
Content-Type: text/plain; charset=UTF-8

Merged,
Thanks.

On Thu, Sep 29, 2016 at 11:28 PM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> Calling pthread_cond_signal() without holding the associated
> mutex sporadically results in a lost wakeup. Hence call
> pthread_cond_signal() while holding the mutex used by
> pthread_cond_wait().
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  libmultipath/checkers/rbd.c | 2 +-
>  libmultipath/checkers/tur.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
> index 874bcfa..41259c3 100644
> --- a/libmultipath/checkers/rbd.c
> +++ b/libmultipath/checkers/rbd.c
> @@ -527,8 +527,8 @@ static void *rbd_thread(void *ctx)
>         /* checker done */
>         pthread_mutex_lock(&ct->lock);
>         ct->state = state;
> -       pthread_mutex_unlock(&ct->lock);
>         pthread_cond_signal(&ct->active);
> +       pthread_mutex_unlock(&ct->lock);
>
>         condlog(3, "rbd%d thead finished, state %s", ct->rbd_bus_id,
>                 checker_state_name(state));
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 8c1f633..94e4190 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -225,8 +225,8 @@ static void *tur_thread(void *ctx)
>         /* TUR checker done */
>         pthread_mutex_lock(&ct->lock);
>         ct->state = state;
> -       pthread_mutex_unlock(&ct->lock);
>         pthread_cond_signal(&ct->active);
> +       pthread_mutex_unlock(&ct->lock);
>
>         condlog(3, "%d:%d: tur checker finished, state %s",
>                 TUR_DEVT(ct), checker_state_name(state));
> --
> 2.10.0
>
>

--001a11401be86206b1053df494e2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, Sep 29, 2016 at 11:28 PM, Bart Van A=
ssche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" t=
arget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">Calling pthread_cond_signal() without holding the =
associated<br>
mutex sporadically results in a lost wakeup. Hence call<br>
pthread_cond_signal() while holding the mutex used by<br>
pthread_cond_wait().<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
Cc: Mike Christie &lt;<a href=3D"mailto:mchristi@redhat.com">mchristi@redha=
t.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/checkers/rbd.c | 2 +-<br>
=C2=A0libmultipath/checkers/tur.c | 2 +-<br>
=C2=A02 files changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c<br>
index 874bcfa..41259c3 100644<br>
--- a/libmultipath/checkers/rbd.c<br>
+++ b/libmultipath/checkers/rbd.c<br>
@@ -527,8 +527,8 @@ static void *rbd_thread(void *ctx)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* checker done */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_lock(&amp;ct-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;state =3D state;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_unlock(&amp;ct-&gt;<wbr>lock);<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cond_signal(&amp;ct-&gt;<wbr>active);<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_unlock(&amp;ct-&gt;<wbr>lock);<br=
>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;rbd%d thead finished, state %s=
&quot;, ct-&gt;rbd_bus_id,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 checker_state_name(=
state));<br>
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c<br>
index 8c1f633..94e4190 100644<br>
--- a/libmultipath/checkers/tur.c<br>
+++ b/libmultipath/checkers/tur.c<br>
@@ -225,8 +225,8 @@ static void *tur_thread(void *ctx)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* TUR checker done */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_lock(&amp;ct-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;state =3D state;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_unlock(&amp;ct-&gt;<wbr>lock);<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cond_signal(&amp;ct-&gt;<wbr>active);<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_unlock(&amp;ct-&gt;<wbr>lock);<br=
>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%d:%d: tur checker finished, s=
tate %s&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TUR_DEVT(ct), check=
er_state_name(state));<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a11401be86206b1053df494e2--


--===============7803609453563906126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7803609453563906126==--
