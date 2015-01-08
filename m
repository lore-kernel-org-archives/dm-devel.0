From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Fix memory leak problem in
	print_multipath_topology
Date: Thu, 8 Jan 2015 23:28:12 +0100
Message-ID: <CABr-Gnfp+f32ukW+CCBXWMb0EkLQuwaP+yMZtWriL3fPnw7W=Q@mail.gmail.com>
References: <54A0F85A.5020301@huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6724186969974240683=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54A0F85A.5020301@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yingtai Xie <xieyingtai@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6724186969974240683==
Content-Type: multipart/alternative; boundary=089e0115fe1a3ba90e050c2b8e16

--089e0115fe1a3ba90e050c2b8e16
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Mon, Dec 29, 2014 at 7:44 AM, Yingtai Xie <xieyingtai@huawei.com> wrote:

> /sys/block/ directory has been opened in snprint_devices, the handler
> should be released when returned abnormally. Similar memory leak problem
> happens in print_multipath_topology when carried out multipath -ll command.
>
> Signed-off-by: Yingtai Xie <xieyingtai@huawei.com>
> ---
>  libmultipath/print.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 383eae4..916906f 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -890,6 +890,7 @@ print_multipath_topology (struct multipath * mpp, int
> verbosity)
>                 }
>         } while (resize);
>         printf("%s", buff);
> +       FREE(buff);
>  }
>
>  extern int
> @@ -1427,8 +1428,10 @@ snprint_devices (char * buff, int len, struct
> vectors *vecs)
>         if (!(blkdir = opendir("/sys/block")))
>                 return 1;
>
> -       if ((len - fwd - threshold) <= 0)
> +       if ((len - fwd - threshold) <= 0) {
> +               closedir(blkdir);
>                 return len;
> +       }
>         fwd += snprintf(buff + fwd, len - fwd, "available block
> devices:\n");
>
>         strcpy(devpath,"/sys/block/");
> @@ -1446,8 +1449,10 @@ snprint_devices (char * buff, int len, struct
> vectors *vecs)
>                 if (S_ISDIR(statbuf.st_mode) == 0)
>                         continue;
>
> -               if ((len - fwd - threshold)  <= 0)
> +               if ((len - fwd - threshold)  <= 0) {
> +                       closedir(blkdir);
>                         return len;
> +               }
>
>                 fwd += snprintf(buff + fwd, len - fwd, "    %s", devptr);
>                 pp = find_path_by_dev(vecs->pathvec, devptr);
> --
> 1.7.12.4
>
>

--089e0115fe1a3ba90e050c2b8e16
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Dec 29, 2014 at 7:44 AM, Yingtai Xi=
e <span dir=3D"ltr">&lt;<a href=3D"mailto:xieyingtai@huawei.com" target=3D"=
_blank">xieyingtai@huawei.com</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">/sys/block/ directory has been opened in snprint_devices, the ha=
ndler<br>
should be released when returned abnormally. Similar memory leak problem<br=
>
happens in print_multipath_topology when carried out multipath -ll command.=
<br>
<br>
Signed-off-by: Yingtai Xie &lt;<a href=3D"mailto:xieyingtai@huawei.com">xie=
yingtai@huawei.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/print.c | 9 +++++++--<br>
=C2=A01 file changed, 7 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/print.c b/libmultipath/print.c<br>
index 383eae4..916906f 100644<br>
--- a/libmultipath/print.c<br>
+++ b/libmultipath/print.c<br>
@@ -890,6 +890,7 @@ print_multipath_topology (struct multipath * mpp, int v=
erbosity)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } while (resize);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s&quot;, buff);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(buff);<br>
=C2=A0}<br>
<br>
=C2=A0extern int<br>
@@ -1427,8 +1428,10 @@ snprint_devices (char * buff, int len, struct vector=
s *vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(blkdir =3D opendir(&quot;/sys/block&quot;=
)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((len - fwd - threshold) &lt;=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((len - fwd - threshold) &lt;=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0closedir(blkdir);<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fwd +=3D snprintf(buff + fwd, len - fwd, &quot;=
available block devices:\n&quot;);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 strcpy(devpath,&quot;/sys/block/&quot;);<br>
@@ -1446,8 +1449,10 @@ snprint_devices (char * buff, int len, struct vector=
s *vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (S_ISDIR(statbuf=
.st_mode) =3D=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((len - fwd - th=
reshold)=C2=A0 &lt;=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((len - fwd - th=
reshold)=C2=A0 &lt;=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0closedir(blkdir);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fwd +=3D snprintf(b=
uff + fwd, len - fwd, &quot;=C2=A0 =C2=A0 %s&quot;, devptr);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp =3D find_path_by=
_dev(vecs-&gt;pathvec, devptr);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.7.12.4<br>
<br>
</font></span></blockquote></div><br></div>

--089e0115fe1a3ba90e050c2b8e16--


--===============6724186969974240683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6724186969974240683==--
