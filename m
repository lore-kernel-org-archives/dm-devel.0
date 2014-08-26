From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Fix typo in log message of
	execute_program()
Date: Tue, 26 Aug 2014 22:02:53 +0200
Message-ID: <CABr-GnepYHHrYZXO6-Z=osh8aXX-XWpGKPtJJ==0wyCZOmBZTw@mail.gmail.com>
References: <87k35v9q4o.fsf@lant.ki.iif.hu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0445646297648859508=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87k35v9q4o.fsf@lant.ki.iif.hu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?UTF-8?Q?Ferenc_W=C3=A1gner?= <wferi@niif.hu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0445646297648859508==
Content-Type: multipart/alternative; boundary=089e01160ea4f6323f05018dc926

--089e01160ea4f6323f05018dc926
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Applied.
Thanks.


On Tue, Aug 26, 2014 at 6:17 PM, Ferenc W=C3=A1gner <wferi@niif.hu> wrote:

> Signed-off-by: Ferenc W=C3=A1gner <wferi@niif.hu>
> ---
>  libmultipath/callout.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/callout.c b/libmultipath/callout.c
> index c35c7c0..4cbbd06 100644
> --- a/libmultipath/callout.c
> +++ b/libmultipath/callout.c
> @@ -125,7 +125,7 @@ int execute_program(char *path, char *value, int len)
>                         if (status =3D=3D 0)
>                                 retval =3D 0;
>                         else
> -                               condlog(0, "%s exitted with %d", argv[0],
> status);
> +                               condlog(0, "%s exited with %d", argv[0],
> status);
>                 }
>                 else if (WIFSIGNALED(status))
>                         condlog(0, "%s was terminated by signal %d",
> argv[0], WTERMSIG(status));
> --
> 1.7.10.4
>
>

--089e01160ea4f6323f05018dc926
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Tue, Aug 26, 2014 at 6:17 PM, Ferenc=
 W=C3=A1gner <span dir=3D"ltr">&lt;<a href=3D"mailto:wferi@niif.hu" target=
=3D"_blank">wferi@niif.hu</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Signed-off-by: Ferenc W=C3=A1gner &lt;<a hre=
f=3D"mailto:wferi@niif.hu">wferi@niif.hu</a>&gt;<br>
---<br>
=C2=A0libmultipath/callout.c |=C2=A0 =C2=A0 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/callout.c b/libmultipath/callout.c<br>
index c35c7c0..4cbbd06 100644<br>
--- a/libmultipath/callout.c<br>
+++ b/libmultipath/callout.c<br>
@@ -125,7 +125,7 @@ int execute_program(char *path, char *value, int len)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (status =3D=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retval =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 else<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot;%s exitted with %d&q=
uot;, argv[0], status);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot;%s exited with %d&qu=
ot;, argv[0], status);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (WIFSIGNALE=
D(status))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 condlog(0, &quot;%s was terminated by signal %d&quot;, argv[0], =
WTERMSIG(status));<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.7.10.4<br>
<br>
</font></span></blockquote></div><br></div>

--089e01160ea4f6323f05018dc926--


--===============0445646297648859508==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0445646297648859508==--
