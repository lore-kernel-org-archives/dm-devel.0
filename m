From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] kpartx: Fix check whether to detach loop
	device
Date: Fri, 22 Jul 2016 11:45:33 +0200
Message-ID: <CABr-Gncjgq+3sqic4tCypbyHE4P3iQ-qOgir_8q=zLDE2eNHsA@mail.gmail.com>
References: <1468430582-4260-1-git-send-email-ckk@debian.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1652870854613020708=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468430582-4260-1-git-send-email-ckk@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Kastner <ckk@debian.org>
Cc: Christian Kastner <ckk@kvr.at>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1652870854613020708==
Content-Type: multipart/alternative; boundary=001a11412e42c002770538364b1e

--001a11412e42c002770538364b1e
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Wed, Jul 13, 2016 at 7:23 PM, Christian Kastner <ckk@debian.org> wrote:

> From: Christian Kastner <ckk@kvr.at>
>
> When invoking kpartx -d $FOO with $FOO being a regular file, the intention
> is
> to also detach the loop device backing $FOO using del_loop(), but this
> currently doesn't happen, as can be seen by calling losetup -a afterwards.
>
> This is because the check for the type of $FOO, prior to the del_loop()
> call, is
> broken. S_ISREG() is called on a buffer that initially did contain the
> status of
> $FOO, but was later overwritten with the status of the backing loop device.
>
> This replaces the S_ISREG() test with a check for whether the loop device
> path
> is not NULL. If it isn't, then we know that it contains the correct path,
> and
> del_loop() can be called safely on that.
>
> Reported as Debian bug #829496; that bug also has more information.
>
> Signed-off-by: Christian Kastner <ckk@kvr.at>
> ---
>  kpartx/kpartx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 4de13fa..b7b4047 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -482,14 +482,14 @@ main(int argc, char **argv){
>                                         printf("del devmap : %s\n",
> partname);
>                         }
>
> -                       if (S_ISREG (buf.st_mode)) {
> -                               if (del_loop(device)) {
> +                       if (loopdev) {
> +                               if (del_loop(loopdev)) {
>                                         if (verbose)
>                                                 printf("can't del loop :
> %s\n",
> -                                                       device);
> +                                                       loopdev);
>                                         exit(1);
>                                 }
> -                               printf("loop deleted : %s\n", device);
> +                               printf("loop deleted : %s\n", loopdev);
>                         }
>                         break;
>
> --
> 2.8.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11412e42c002770538364b1e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Wed, Jul 13, 2016 at 7:23 PM, Christian K=
astner <span dir=3D"ltr">&lt;<a href=3D"mailto:ckk@debian.org" target=3D"_b=
lank">ckk@debian.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">From: Christian Kastner &lt;<a href=3D"mailto:ckk@kvr.at">ckk@kvr.at</a>&=
gt;<br>
<br>
When invoking kpartx -d $FOO with $FOO being a regular file, the intention =
is<br>
to also detach the loop device backing $FOO using del_loop(), but this<br>
currently doesn&#39;t happen, as can be seen by calling losetup -a afterwar=
ds.<br>
<br>
This is because the check for the type of $FOO, prior to the del_loop() cal=
l, is<br>
broken. S_ISREG() is called on a buffer that initially did contain the stat=
us of<br>
$FOO, but was later overwritten with the status of the backing loop device.=
<br>
<br>
This replaces the S_ISREG() test with a check for whether the loop device p=
ath<br>
is not NULL. If it isn&#39;t, then we know that it contains the correct pat=
h, and<br>
del_loop() can be called safely on that.<br>
<br>
Reported as Debian bug #829496; that bug also has more information.<br>
<br>
Signed-off-by: Christian Kastner &lt;<a href=3D"mailto:ckk@kvr.at">ckk@kvr.=
at</a>&gt;<br>
---<br>
=C2=A0kpartx/kpartx.c | 8 ++++----<br>
=C2=A01 file changed, 4 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c<br>
index 4de13fa..b7b4047 100644<br>
--- a/kpartx/kpartx.c<br>
+++ b/kpartx/kpartx.c<br>
@@ -482,14 +482,14 @@ main(int argc, char **argv){<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&=
quot;del devmap : %s\n&quot;, partname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (S_ISREG (buf.st_mode)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (del_loop(device)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (loopdev) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (del_loop(loopdev)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (verb=
ose)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 printf(&quot;can&#39;t del loop : %s\n&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0device);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loopdev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf(&quot;loop deleted : %s\n&quot=
;, device);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf(&quot;loop deleted : %s\n&quot=
;, loopdev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.8.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>

--001a11412e42c002770538364b1e--


--===============1652870854613020708==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1652870854613020708==--
