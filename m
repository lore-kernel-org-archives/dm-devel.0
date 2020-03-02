From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH resend] ALUA support for PURE FlashArray
Date: Mon, 2 Mar 2020 16:03:06 +0100
Message-ID: <CABr-Gnc6kgT3jbZysKkU12dyS9_xReXmo8wW4_EX329CT3Oneg@mail.gmail.com>
References: <20200302145354.1352-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3341276955627513961=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200302145354.1352-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Brian Bunker <brian@purestorage.com>
List-Id: dm-devel.ids

--===============3341276955627513961==
Content-Type: multipart/alternative; boundary="000000000000c480e2059fe07c7e"

--000000000000c480e2059fe07c7e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Applied,
thanks.

On Mon, Mar 2, 2020 at 3:53 PM Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> From: Brian Bunker <brian@purestorage.com>
>
> Hello all,
>
> It has been some time since we updated our PURE FlashArray
> configuration. The Linux vendors that we had been seeing in the field
> were using very old versions of multipath-tools, so we haven=E2=80=99t ne=
eded to
> change anything for some time. With the release of RHEL8, some of our
> earlier values have been lost by upstream changes.
>
> In addition we have our Active Cluster feature which leverages ALUA
> since our last patch. The ALUA confguration will work for all
> FlashArrays with or without Active Cluster.
>
> We are changing 3 things.
>
> 1. ALUA support
> 2. Fast fail timeout from the default of 5 seconds to 10 seconds (We
>    need this for our FC NPIV port migration).
> 3. Maximum sector size of 4MB. Some Linux vendors don=E2=80=99t honor the=
 block
>    limits VPD page of INQUIRY).
>
> Thanks,
> Brian
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>  libmultipath/hwtable.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 16627ec..9bc59f1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1039,7 +1039,12 @@ static struct hwentry default_hw[] =3D {
>                 /* FlashArray */
>                 .vendor        =3D "PURE",
>                 .product       =3D "FlashArray",
> -               .pgpolicy      =3D MULTIBUS,
> +               .pgpolicy      =3D GROUP_BY_PRIO,
> +               .pgfailback    =3D -FAILBACK_IMMEDIATE,
> +               .hwhandler     =3D "1 alua",
> +               .prio_name     =3D PRIO_ALUA,
> +               .fast_io_fail  =3D 10,
> +               .max_sectors_kb =3D 4096,
>         },
>         /*
>          * Huawei
> --
> 2.24.1
>
> Brian Bunker
> SW Eng
> brian@purestorage.com
>

--000000000000c480e2059fe07c7e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><br><div class=3D"gmail_qu=
ote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Mar 2, 2020 at 3:53 PM X=
ose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.com">xose.vazque=
z@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">From: Brian Bunker &lt;<a href=3D"mailto:brian@purestorage.com" =
target=3D"_blank">brian@purestorage.com</a>&gt;<br>
<br>
Hello all,<br>
<br>
It has been some time since we updated our PURE FlashArray<br>
configuration. The Linux vendors that we had been seeing in the field<br>
were using very old versions of multipath-tools, so we haven=E2=80=99t need=
ed to<br>
change anything for some time. With the release of RHEL8, some of our<br>
earlier values have been lost by upstream changes.<br>
<br>
In addition we have our Active Cluster feature which leverages ALUA<br>
since our last patch. The ALUA confguration will work for all<br>
FlashArrays with or without Active Cluster.<br>
<br>
We are changing 3 things.<br>
<br>
1. ALUA support<br>
2. Fast fail timeout from the default of 5 seconds to 10 seconds (We<br>
=C2=A0 =C2=A0need this for our FC NPIV port migration).<br>
3. Maximum sector size of 4MB. Some Linux vendors don=E2=80=99t honor the b=
lock<br>
=C2=A0 =C2=A0limits VPD page of INQUIRY).<br>
<br>
Thanks,<br>
Brian<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
" target=3D"_blank">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: DM-DEVEL ML &lt;<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank=
">dm-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
Signed-off-by: Brian Bunker &lt;<a href=3D"mailto:brian@purestorage.com" ta=
rget=3D"_blank">brian@purestorage.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 7 ++++++-<br>
=C2=A01 file changed, 6 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 16627ec..9bc59f1 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -1039,7 +1039,12 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* FlashArray */<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;PURE&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;FlashArray&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hwhandler=C2=A0 =
=C2=A0 =C2=A0=3D &quot;1 alua&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=A0=
 =3D 10,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.max_sectors_kb =3D=
 4096,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Huawei<br>
-- <br>
2.24.1<br>
<br>
Brian Bunker<br>
SW Eng<br>
<a href=3D"mailto:brian@purestorage.com" target=3D"_blank">brian@purestorag=
e.com</a><br>
</blockquote></div>

--000000000000c480e2059fe07c7e--

--===============3341276955627513961==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3341276955627513961==--
