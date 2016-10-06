From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add HPE StoreVirtual 4000
 family(LEFTHAND) to hwtable
Date: Thu, 6 Oct 2016 08:00:42 +0200
Message-ID: <CABr-GnfkkrnxFB+bQ9_hO2kbr3tiJq7DiGpPFEYARR60NQW0Pw@mail.gmail.com>
References: <20161005210014.9104-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0552911448110264503=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161005210014.9104-1-xose.vazquez@gmail.com>
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

--===============0552911448110264503==
Content-Type: multipart/alternative; boundary=001a11401be890336e053e2c0386

--001a11401be890336e053e2c0386
Content-Type: text/plain; charset=UTF-8

Merged.

On Wed, Oct 5, 2016 at 11:00 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> No official documentation, based on field-tested configuration:
> https://www.citrix.com/blogs/2013/10/02/hp-p4000-multipath-config-file/
> https://community.hpe.com/t5/HPE-StoreVirtual-Storage/
> StoreVirtual-4000-and-multipath-tools-Linux/m-p/6874775
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 8ecaffb..e1ed7ef 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -146,6 +146,15 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = 18,
>                 .prio_name     = PRIO_ALUA,
>         },
> +       {
> +               /* StoreVirtual 4000 family */
> +               .vendor        = "LEFTHAND",
> +               .product       = "^(P4000|iSCSIDisk)",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .no_path_retry = 18,
> +               .prio_name     = PRIO_ALUA,
> +       },
>         /*
>          * DataDirect Networks
>          */
> --
> 2.10.1
>
>

--001a11401be890336e053e2c0386
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Oct 5, 2016 at 11:00 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">No official documentation, based on field-tested configuration:<br>
<a href=3D"https://www.citrix.com/blogs/2013/10/02/hp-p4000-multipath-confi=
g-file/" rel=3D"noreferrer" target=3D"_blank">https://www.citrix.com/blogs/=
<wbr>2013/10/02/hp-p4000-multipath-<wbr>config-file/</a><br>
<a href=3D"https://community.hpe.com/t5/HPE-StoreVirtual-Storage/StoreVirtu=
al-4000-and-multipath-tools-Linux/m-p/6874775" rel=3D"noreferrer" target=3D=
"_blank">https://community.hpe.com/t5/<wbr>HPE-StoreVirtual-Storage/<wbr>St=
oreVirtual-4000-and-<wbr>multipath-tools-Linux/m-p/<wbr>6874775</a><br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 9 +++++++++<br>
=C2=A01 file changed, 9 insertions(+)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 8ecaffb..e1ed7ef 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -146,6 +146,15 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
18,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* StoreVirtual 400=
0 family */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;LEFTHAND&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^(P4000|iSCSIDisk)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D =
18,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* DataDirect Networks<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11401be890336e053e2c0386--


--===============0552911448110264503==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0552911448110264503==--
