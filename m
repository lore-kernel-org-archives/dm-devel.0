From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 08/10] multipath-tools: remove
	USER_FRIENDLY_NAMES_OFF
Date: Mon, 20 Jun 2016 08:58:07 +0200
Message-ID: <CABr-GneYSo9zHqsn45wsigTX+sMpu8SgEquBEU_4Qoka47XgZg@mail.gmail.com>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
	<1466175169-16684-8-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4820978859050468460=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466175169-16684-8-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4820978859050468460==
Content-Type: multipart/alternative; boundary=001a114012601287240535b03a30

--001a114012601287240535b03a30
Content-Type: text/plain; charset=UTF-8

I tend to agree with Xose this is unfair to set user_friendly_name in the
hwtable entries.
Does anybody have a vote against my merging this patch ?

On Fri, Jun 17, 2016 at 4:52 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> This is up to sysadmins, and it is already off by default.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 598b9b8..bef8d31 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -794,7 +794,6 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ONTAP,
>                 .prio_args     = NULL,
>                 .retain_hwhandler = RETAIN_HWHANDLER_ON,
> -               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
>                 .detect_prio   = DETECT_PRIO_ON,
>         },
>         /*
> @@ -1133,7 +1132,6 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .checker_name  = TUR,
>                 .fast_io_fail  = 10,
> -               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
>                 .prio_name     = DEFAULT_PRIO,
>                 .no_path_retry = 0,
>                 .dev_loss      = 60,
> --
> 2.5.5
>
>

--001a114012601287240535b03a30
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I tend to agree with Xose this is unfair to set user_frien=
dly_name in the hwtable entries.<div>Does anybody have a vote against my me=
rging this patch ?</div></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Fri, Jun 17, 2016 at 4:52 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">This is up to sysadmins, and it is already off by default.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 2 --<br>
=C2=A01 file changed, 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 598b9b8..bef8d31 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -794,7 +794,6 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ONTAP,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_args=C2=A0 =
=C2=A0 =C2=A0=3D NULL,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .retain_hwhandler =
=3D RETAIN_HWHANDLER_ON,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user_friendly_name=
s =3D USER_FRIENDLY_NAMES_OFF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .detect_prio=C2=A0 =
=C2=A0=3D DETECT_PRIO_ON,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
@@ -1133,7 +1132,6 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .checker_name=C2=A0=
 =3D TUR,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .fast_io_fail=C2=A0=
 =3D 10,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user_friendly_name=
s =3D USER_FRIENDLY_NAMES_OFF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D DEFAULT_PRIO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
0,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .dev_loss=C2=A0 =C2=
=A0 =C2=A0 =3D 60,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a114012601287240535b03a30--


--===============4820978859050468460==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4820978859050468460==--
