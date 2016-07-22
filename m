From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix memory leak in reconfigure()
Date: Fri, 22 Jul 2016 11:40:04 +0200
Message-ID: <CABr-Gnei0RHg1ZXo9D4Y753WZ+Te4_ECCC-h6PEvn2hWhATzfg@mail.gmail.com>
References: <1468844071-5484-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4638241003343997207=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468844071-5484-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

--===============4638241003343997207==
Content-Type: multipart/alternative; boundary=001a11402e64228dec0538363828

--001a11402e64228dec0538363828
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Mon, Jul 18, 2016 at 2:14 PM, <tang.junhui@zte.com.cn> wrote:

> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> Problem:
> Memory leak exists in reconfigure() when multipathd command reconfigure is
> executed.
>
> Reasons:
>  * The following judgment condition is not satisfied when there is no path,
>    free_pathvec() is not called to free the vector of vecs->pathvec:
>        if (VECTOR_SIZE(vecs->pathvec))
>            free_pathvec(vecs->pathvec, FREE_PATHS);
>  * Then the vecs->pathvec is set to NULL, so the vector memory which
>    vecs->pathvec pointed to is leaked:
>        vecs->pathvec = NULL;
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  multipathd/main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index c129298..d9731cd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1997,9 +1997,7 @@ reconfigure (struct vectors * vecs)
>         if (VECTOR_SIZE(vecs->mpvec))
>                 remove_maps_and_stop_waiters(vecs);
>
> -       if (VECTOR_SIZE(vecs->pathvec))
> -               free_pathvec(vecs->pathvec, FREE_PATHS);
> -
> +       free_pathvec(vecs->pathvec, FREE_PATHS);
>         vecs->pathvec = NULL;
>
>         /* Re-read any timezone changes */
> --
> 2.8.1.windows.1
>
> --------------------------------------------------------
> ZTE Information Security Notice: The information contained in this mail
> (and any attachment transmitted herewith) is privileged and confidential
> and is intended for the exclusive use of the addressee(s).  If you are not
> an intended recipient, any disclosure, reproduction, distribution or other
> dissemination or use of the information contained is strictly prohibited.
> If you have received this mail in error, please delete it and notify us
> immediately.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11402e64228dec0538363828
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Jul 18, 2016 at 2:14 PM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:tang.junhui@zte.com.cn" target=3D"_blank">ta=
ng.junhui@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">From: &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.com.c=
n">tang.junhui@zte.com.cn</a>&gt;<br>
<br>
Problem:<br>
Memory leak exists in reconfigure() when multipathd command reconfigure is =
executed.<br>
<br>
Reasons:<br>
=C2=A0* The following judgment condition is not satisfied when there is no =
path,<br>
=C2=A0 =C2=A0free_pathvec() is not called to free the vector of vecs-&gt;pa=
thvec:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (VECTOR_SIZE(vecs-&gt;pathvec))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free_pathvec(vecs-&gt;pathvec, FRE=
E_PATHS);<br>
=C2=A0* Then the vecs-&gt;pathvec is set to NULL, so the vector memory whic=
h<br>
=C2=A0 =C2=A0vecs-&gt;pathvec pointed to is leaked:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0vecs-&gt;pathvec =3D NULL;<br>
<br>
Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.cn">ta=
ng.junhui@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c | 4 +---<br>
=C2=A01 file changed, 1 insertion(+), 3 deletions(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index c129298..d9731cd 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1997,9 +1997,7 @@ reconfigure (struct vectors * vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (VECTOR_SIZE(vecs-&gt;mpvec))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remove_maps_and_sto=
p_waiters(vecs);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (VECTOR_SIZE(vecs-&gt;pathvec))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free_pathvec(vecs-&=
gt;pathvec, FREE_PATHS);<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0free_pathvec(vecs-&gt;pathvec, FREE_PATHS);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vecs-&gt;pathvec =3D NULL;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Re-read any timezone changes */<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
--------------------------------------------------------<br>
ZTE Information Security Notice: The information contained in this mail (an=
d any attachment transmitted herewith) is privileged and confidential and i=
s intended for the exclusive use of the addressee(s).=C2=A0 If you are not =
an intended recipient, any disclosure, reproduction, distribution or other =
dissemination or use of the information contained is strictly prohibited.=
=C2=A0 If you have received this mail in error, please delete it and notify=
 us immediately.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>

--001a11402e64228dec0538363828--


--===============4638241003343997207==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4638241003343997207==--
