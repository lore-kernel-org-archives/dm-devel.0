From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: Change four threads from
	detached into joinable
Date: Mon, 29 Aug 2016 09:22:58 +0200
Message-ID: <CABr-GndetGDYH_75amQXC4_YuTBvg3v-fW1ZgejN2W-GbBsSSg@mail.gmail.com>
References: <f31a3171-80e1-c01a-a992-588bb063e619@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1664235634009528902=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f31a3171-80e1-c01a-a992-588bb063e619@sandisk.com>
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

--===============1664235634009528902==
Content-Type: multipart/alternative; boundary=001a114002f8d81287053b30bb2a

--001a114002f8d81287053b30bb2a
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Fri, Aug 19, 2016 at 12:44 AM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> Change the CLI listener, checker loop, uevent dispatcher and
> uevent listener threads from detached into joinable threads.
> This change is needed because calling pthread_join() is only
> allowed for joinable threads.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Acked-by: dragan.stancevic@canonical.com
> ---
>  multipathd/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2be6cb2..6b3c856 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2216,8 +2216,8 @@ child (void * param)
>         signal_init();
>         rcu_init();
>
> -       setup_thread_attr(&misc_attr, 64 * 1024, 1);
> -       setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024,
> 1);
> +       setup_thread_attr(&misc_attr, 64 * 1024, 0);
> +       setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024,
> 0);
>         setup_thread_attr(&waiter_attr, 32 * 1024, 1);
>
>         if (logsink == 1) {
> --
> 2.9.2
>
>

--001a114002f8d81287053b30bb2a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Aug 19, 2016 at 12:44 AM, Bart Van A=
ssche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" t=
arget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">Change the CLI listener, checker loop, uevent disp=
atcher and<br>
uevent listener threads from detached into joinable threads.<br>
This change is needed because calling pthread_join() is only<br>
allowed for joinable threads.<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
Acked-by: <a href=3D"mailto:dragan.stancevic@canonical.com">dragan.stancevi=
c@canonical.com</a><br>
---<br>
=C2=A0multipathd/main.c | 4 ++--<br>
=C2=A01 file changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 2be6cb2..6b3c856 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2216,8 +2216,8 @@ child (void * param)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 signal_init();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rcu_init();<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0setup_thread_attr(&amp;misc_attr, 64 * 1024, 1)=
;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0setup_thread_attr(&amp;uevent_<wbr>attr, DEFAUL=
T_UEVENT_STACKSIZE * 1024, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0setup_thread_attr(&amp;misc_attr, 64 * 1024, 0)=
;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0setup_thread_attr(&amp;uevent_<wbr>attr, DEFAUL=
T_UEVENT_STACKSIZE * 1024, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 setup_thread_attr(&amp;waiter_<wbr>attr, 32 * 1=
024, 1);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (logsink =3D=3D 1) {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.9.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a114002f8d81287053b30bb2a--


--===============1664235634009528902==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1664235634009528902==--
