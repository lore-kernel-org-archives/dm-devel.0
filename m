From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: update 3PARdata builtin config
Date: Sat, 5 Aug 2017 08:36:39 +0200
Message-ID: <CABr-GneY25XFgxb7+BPr3_ay41s_L=GAGNcXBRPAFoOohFfHBg@mail.gmail.com>
References: <1498503799-24026-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7193944675920185952=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498503799-24026-1-git-send-email-bmarzins@redhat.com>
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

--===============7193944675920185952==
Content-Type: multipart/alternative; boundary="94eb2c0933a81215b40555fbd623"

--94eb2c0933a81215b40555fbd623
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

(And version bumped to 0.7.2)

On Mon, Jun 26, 2017 at 9:03 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> This updated config comes from hp.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 390d143..54bdcfc 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -49,6 +49,8 @@ static struct hwentry default_hw[] = {
>                 .hwhandler     = "1 alua",
>                 .prio_name     = PRIO_ALUA,
>                 .no_path_retry = 18,
> +               .fast_io_fail  = 10,
> +               .dev_loss      = MAX_DEV_LOSS_TMO,
>         },
>         {
>                 /* RA8000 / ESA12000 */
> --
> 2.7.4
>
>

--94eb2c0933a81215b40555fbd623
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div><div><br></div><div>(And version =
bumped to 0.7.2)</div></div><div class=3D"gmail_extra"><br><div class=3D"gm=
ail_quote">On Mon, Jun 26, 2017 at 9:03 PM, Benjamin Marzinski <span dir=3D=
"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins=
@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">This up=
dated config comes from hp.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 2 ++<br>
=C2=A01 file changed, 2 insertions(+)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 390d143..54bdcfc 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -49,6 +49,8 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .hwhandler=C2=A0 =
=C2=A0 =C2=A0=3D &quot;1 alua&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
18,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=A0=
 =3D 10,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.dev_loss=C2=A0 =C2=
=A0 =C2=A0 =3D MAX_DEV_LOSS_TMO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* RA8000 / ESA1200=
0 */<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c0933a81215b40555fbd623--


--===============7193944675920185952==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7193944675920185952==--
