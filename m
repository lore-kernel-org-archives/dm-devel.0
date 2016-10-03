From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/4] multipath-tools: replace GROUP_BY_SERIAL
 with MULTIBUS for IBM 3542 and 2105
Date: Mon, 3 Oct 2016 13:02:05 +0200
Message-ID: <CABr-GndoWMoFD898RPci4yJxFDvtwmhQTERH7QZqLk0Qm5mCuQ@mail.gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
	<1471543096-11441-2-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8415756102911446721=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471543096-11441-2-git-send-email-xose.vazquez@gmail.com>
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

--===============8415756102911446721==
Content-Type: multipart/alternative; boundary=001a11410294e9cbf0053df3dfd2

--001a11410294e9cbf0053df3dfd2
Content-Type: text/plain; charset=UTF-8

Hi Xose,

Group by serial sure can make sense for hardware not capable of multibus.

Can you or Hannes (listed as maintainer for IBM) confirm the concerned IBM
arrays are multibus capable ?

Best regards,
Christophe Varoqui
OpenSVC

On Thu, Aug 18, 2016 at 7:58 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> It doesn't make any sense to have, by default, GROUP_BY_SERIAL in real
> hardware.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index aa3ea9b..72b5e1d 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -443,7 +443,7 @@ static struct hwentry default_hw[] = {
>                 /* DS4200 / FAStT200 */
>                 .vendor        = "IBM",
>                 .product       = "^3542",
> -               .pgpolicy      = GROUP_BY_SERIAL,
> +               .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> @@ -451,7 +451,7 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^2105",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = GROUP_BY_SERIAL,
> +               .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> --
> 2.7.4
>
>

--001a11410294e9cbf0053df3dfd2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Xose,<div><br></div><div>Group by serial sure can make =
sense for hardware not capable of multibus.<br></div><div><br></div><div>Ca=
n you or Hannes (listed as maintainer for IBM) confirm the concerned IBM ar=
rays are multibus capable ?</div><div><br></div><div>Best regards,</div><di=
v>Christophe Varoqui</div><div>OpenSVC</div></div><div class=3D"gmail_extra=
"><br><div class=3D"gmail_quote">On Thu, Aug 18, 2016 at 7:58 PM, Xose Vazq=
uez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" t=
arget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">It doesn&#39;t make any sense to have, by default, GRO=
UP_BY_SERIAL in real hardware.<br>
<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt=
;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 4 ++--<br>
=C2=A01 file changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index aa3ea9b..72b5e1d 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -443,7 +443,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* DS4200 / FAStT20=
0 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^3542&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_SERIAL,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D FAILBACK_UNDEF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
@@ -451,7 +451,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^2105&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
NO_PATH_RETRY_QUEUE,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_SERIAL,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D FAILBACK_UNDEF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a11410294e9cbf0053df3dfd2--


--===============8415756102911446721==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8415756102911446721==--
