From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix waiter_attr resource leak
Date: Fri, 8 Jul 2016 09:59:18 +0200
Message-ID: <CABr-GndMYzjsQrpvi8vNrD9AYUzLO7KmSFOkaOE-Mb4t+O-p5Q@mail.gmail.com>
References: <OF23BCA109.0BE2FFED-ON48257FE8.0023BAD2-48257FE8.002CA989@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1294277211946708252=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF23BCA109.0BE2FFED-ON48257FE8.0023BAD2-48257FE8.002CA989@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zhang.kai16@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============1294277211946708252==
Content-Type: multipart/alternative; boundary=001a1140d2befd920005371b2d20

--001a1140d2befd920005371b2d20
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ben, Hannes, I'd appreciate your ack on this patch.

Thanks.

On Wed, Jul 6, 2016 at 10:08 AM, <zhang.kai16@zte.com.cn> wrote:

> As a global variable waiter_attr of thread attribute was set up in the
> daemon,
> however,it hasn't been destroyed when the daemon exited.
> We need deinitialize waiter_attr.
>
>
> ---
> multipathd/main.c | 3 +++
> 1 file changed, 3 insertions(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index b86374f..09c5485 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2317,6 +2317,9 @@ child (void * param)
>                  conf =3D NULL;
>                  udev_unref(udev);
>                  udev =3D NULL;
> +
> +                 pthread_attr_destroy(&waiter_attr);
> +
> #ifdef _DEBUG_
>                  dbg_free_final(NULL);
> #endif
> --
> 1.9.1
>
>
>
>
> --------------------------------------------------------
> ZTE Information Security Notice: The information contained in this mail (=
and any attachment transmitted herewith) is privileged and confidential and=
 is intended for the exclusive use of the addressee(s).  If you are not an =
intended recipient, any disclosure, reproduction, distribution or other dis=
semination or use of the information contained is strictly prohibited.  If =
you have received this mail in error, please delete it and notify us immedi=
ately.
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1140d2befd920005371b2d20
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ben, Hannes, I&#39;d appreciate your ack on this patch.<di=
v><br></div><div>Thanks.</div></div><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">On Wed, Jul 6, 2016 at 10:08 AM,  <span dir=3D"ltr">&lt;=
<a href=3D"mailto:zhang.kai16@zte.com.cn" target=3D"_blank">zhang.kai16@zte=
.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><font size=
=3D"2" face=3D"sans-serif">As a global variable waiter_attr of thread
attribute was set up in the daemon, </font>
<br><font size=3D"2" face=3D"sans-serif">however,it hasn&#39;t been destroy=
ed when
the daemon exited.</font>
<br><font size=3D"2" face=3D"sans-serif">We need deinitialize waiter_attr.<=
/font>
<br><font size=3D"2" face=3D"sans-serif">=C2=A0<br>
</font>
<br><tt><font size=3D"2">---<br>
 multipathd/main.c | 3 +++<br>
 1 file changed, 3 insertions(+)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index b86374f..09c5485 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2317,6 +2317,9 @@ child (void * param)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf
=3D NULL;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_unref(u=
dev);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev
=3D NULL;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
pthread_attr_destroy(&amp;waiter_attr);<br>
+<br>
 #ifdef _DEBUG_<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbg_free_fin=
al(NULL);<br>
 #endif<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
1.9.1<br>
</font></span></font></tt><span class=3D"HOEnZb"><font color=3D"#888888">
<br>
<br>

<br><pre><font color=3D"blue">
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (an=
d any attachment transmitted herewith) is privileged and confidential and i=
s intended for the exclusive use of the addressee(s).  If you are not an in=
tended recipient, any disclosure, reproduction, distribution or other disse=
mination or use of the information contained is strictly prohibited.  If yo=
u have received this mail in error, please delete it and notify us immediat=
ely.

</font></pre><br>
</font></span><br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br></div>

--001a1140d2befd920005371b2d20--


--===============1294277211946708252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1294277211946708252==--
