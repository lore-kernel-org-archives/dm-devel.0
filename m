From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 4/5] multipath-tools: Set errno
 mpath_recv_reply() when failure
Date: Fri, 10 Feb 2017 12:36:42 +0100
Message-ID: <CABr-GndzGMjMMGT=tWWy0KFZU5yOYFn+TFT05Ew8PV-F8WG0_Q@mail.gmail.com>
References: <1484919542-11087-1-git-send-email-fge@redhat.com>
	<1484919542-11087-5-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6913269403561173710=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484919542-11087-5-git-send-email-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6913269403561173710==
Content-Type: multipart/alternative; boundary=94eb2c04721003a42d05482b83b7

--94eb2c04721003a42d05482b83b7
Content-Type: text/plain; charset=UTF-8

Applied.

On Fri, Jan 20, 2017 at 2:39 PM, Gris Ge <fge@redhat.com> wrote:

> Enforce what mpath_cmd.h states "-1 on failure (with errno set)" for
> mpath_recv_reply() by set errno and return -1 on failure.
>
> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  libmpathcmd/mpath_cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index 7fc9e98..856e6b4 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -141,7 +141,7 @@ int mpath_recv_reply(int fd, char **reply, unsigned
> int timeout)
>         *reply = NULL;
>         len = mpath_recv_reply_len(fd, timeout);
>         if (len <= 0)
> -               return len;
> +               return -1;
>         *reply = malloc(len);
>         if (!*reply)
>                 return -1;
> @@ -149,7 +149,7 @@ int mpath_recv_reply(int fd, char **reply, unsigned
> int timeout)
>         if (err) {
>                 free(*reply);
>                 *reply = NULL;
> -               return err;
> +               return -1;
>         }
>         return 0;
>  }
> --
> 1.8.3.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--94eb2c04721003a42d05482b83b7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Fri, Jan 20, 2017 at 2:39 PM, Gris Ge <span dir=3D"ltr">&l=
t;<a href=3D"mailto:fge@redhat.com" target=3D"_blank">fge@redhat.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">Enforce what mpath_cmd.h =
states &quot;-1 on failure (with errno set)&quot; for<br>
mpath_recv_reply() by set errno and return -1 on failure.<br>
<br>
Signed-off-by: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com=
</a>&gt;<br>
---<br>
=C2=A0libmpathcmd/mpath_cmd.c | 4 ++--<br>
=C2=A01 file changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c<br>
index 7fc9e98..856e6b4 100644<br>
--- a/libmpathcmd/mpath_cmd.c<br>
+++ b/libmpathcmd/mpath_cmd.c<br>
@@ -141,7 +141,7 @@ int mpath_recv_reply(int fd, char **reply, unsigned int=
 timeout)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *reply =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D mpath_recv_reply_len(fd, timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (len &lt;=3D 0)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *reply =3D malloc(len);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!*reply)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
@@ -149,7 +149,7 @@ int mpath_recv_reply(int fd, char **reply, unsigned int=
 timeout)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(*reply);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *reply =3D NULL;<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--94eb2c04721003a42d05482b83b7--


--===============6913269403561173710==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6913269403561173710==--
