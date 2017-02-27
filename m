From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: git should ignore rej and
	orig files
Date: Mon, 27 Feb 2017 06:34:59 +0100
Message-ID: <CABr-Gncmayw6iT41Q8oMJ92-TDjkwA3OhrmdpqfeC5+-BVuRBg@mail.gmail.com>
References: <20170216192308.16546-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6632345151861105678=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170216192308.16546-1-xose.vazquez@gmail.com>
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

--===============6632345151861105678==
Content-Type: multipart/alternative; boundary=001a1142efbec2e66505497c70e6

--001a1142efbec2e66505497c70e6
Content-Type: text/plain; charset=UTF-8

Applied.

On Thu, Feb 16, 2017 at 8:23 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  .gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/.gitignore b/.gitignore
> index aee4ece..07391d3 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -12,3 +12,5 @@ mpathpersist/mpathpersist
>  .nfs*
>  *.swp
>  *.patch
> +*.rej
> +*.orig
> --
> 2.11.1
>
>

--001a1142efbec2e66505497c70e6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Thu, Feb 16, 2017 at 8:23 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.c=
om">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0.gitignore | 2 ++<br>
=C2=A01 file changed, 2 insertions(+)<br>
<br>
diff --git a/.gitignore b/.gitignore<br>
index aee4ece..07391d3 100644<br>
--- a/.gitignore<br>
+++ b/.gitignore<br>
@@ -12,3 +12,5 @@ mpathpersist/mpathpersist<br>
=C2=A0.nfs*<br>
=C2=A0*.swp<br>
=C2=A0*.patch<br>
+*.rej<br>
+*.orig<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.11.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142efbec2e66505497c70e6--


--===============6632345151861105678==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6632345151861105678==--
