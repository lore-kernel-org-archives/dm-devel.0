From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] check info.exists to get valid value
Date: Tue, 1 Jul 2014 20:32:33 +0200
Message-ID: <CABr-GnfLkc+27p7GFALmHxUv21rjYoEGUVQpiFcgmFnPvCXbcg@mail.gmail.com>
References: <1403683708-14220-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3743918748014975299=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1403683708-14220-1-git-send-email-vaughan.cao@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3743918748014975299==
Content-Type: multipart/alternative; boundary=089e01161982c074fc04fd25ffbc

--089e01161982c074fc04fd25ffbc
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Wed, Jun 25, 2014 at 10:08 AM, Vaughan Cao <vaughan.cao@oracle.com>
wrote:

> dm_task_get_info will still return 1 if device doesn't exist.
> Check info.exists to ensure major and minor values are valid.
>
> There is no reason to assign info.open_count to @r here.
>
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  libmultipath/devmapper.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 30e9351..3d4c111 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -567,10 +567,9 @@ dm_dev_t (const char * mapname, char * dev_t, int len)
>         if (!dm_task_run(dmt))
>                 goto out;
>
> -       if (!dm_task_get_info(dmt, &info))
> +       if (!dm_task_get_info(dmt, &info) || !info.exists)
>                 goto out;
>
> -       r = info.open_count;
>         if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
>                     goto out;
>
> --
> 1.9.0
>
>

--089e01161982c074fc04fd25ffbc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<br>Thanks.<br></div><div class=3D"gmail_extra"><b=
r><br><div class=3D"gmail_quote">On Wed, Jun 25, 2014 at 10:08 AM, Vaughan =
Cao <span dir=3D"ltr">&lt;<a href=3D"mailto:vaughan.cao@oracle.com" target=
=3D"_blank">vaughan.cao@oracle.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">dm_task_get_info will still return 1 if devi=
ce doesn&#39;t exist.<br>
Check info.exists to ensure major and minor values are valid.<br>
<br>
There is no reason to assign info.open_count to @r here.<br>
<br>
Signed-off-by: Vaughan Cao &lt;<a href=3D"mailto:vaughan.cao@oracle.com">va=
ughan.cao@oracle.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/devmapper.c | 3 +--<br>
=C2=A01 file changed, 1 insertion(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 30e9351..3d4c111 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -567,10 +567,9 @@ dm_dev_t (const char * mapname, char * dev_t, int len)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dm_task_run(dmt))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 if (!dm_task_get_info(dmt, &amp;info))<br>
+ =C2=A0 =C2=A0 =C2=A0 if (!dm_task_get_info(dmt, &amp;info) || !info.exist=
s)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 r =3D info.open_count;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (snprintf(dev_t, len, &quot;%i:%i&quot;, inf=
o.major, info.minor) &gt; len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto =
out;<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.9.0<br>
<br>
</font></span></blockquote></div><br></div>

--089e01161982c074fc04fd25ffbc--


--===============3743918748014975299==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3743918748014975299==--
