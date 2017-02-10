From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/5] multipath-tools: libmultipath: fix gcc
 link failure on rcu_register_thread_mb.
Date: Fri, 10 Feb 2017 12:33:48 +0100
Message-ID: <CABr-GndxhwKnYbqY8zXwMs=Z2L7ZR9vd2tGYPsO=T2YVLynH9Q@mail.gmail.com>
References: <1484919542-11087-1-git-send-email-fge@redhat.com>
	<1484919542-11087-2-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5009319534316610650=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484919542-11087-2-git-send-email-fge@redhat.com>
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

--===============5009319534316610650==
Content-Type: multipart/alternative; boundary=001a1142efbeaad78a05482b78e7

--001a1142efbeaad78a05482b78e7
Content-Type: text/plain; charset=UTF-8

Applied.

On Fri, Jan 20, 2017 at 2:38 PM, Gris Ge <fge@redhat.com> wrote:

> Error:
>     ../libmultipath/libmultipath.so: undefined reference to
>     `rcu_register_thread_mb'
>     ../libmultipath/libmultipath.so: undefined reference to
>     `rcu_unregister_thread_mb'
>
> Fix:
>     Link the libmultipath with -lurcu
>
> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  libmultipath/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index b5d54d8..1f5ec25 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -9,7 +9,7 @@ LIBS = $(DEVLIB).$(SONAME)
>
>  CFLAGS += -I$(mpathcmddir)
>
> -LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
> +LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
> -lurcu
>
>  ifdef SYSTEMD
>         CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
> --
> 1.8.3.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1142efbeaad78a05482b78e7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Fri, Jan 20, 2017 at 2:38 PM, Gris Ge <span dir=3D"ltr">&l=
t;<a href=3D"mailto:fge@redhat.com" target=3D"_blank">fge@redhat.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">Error:<br>
=C2=A0 =C2=A0 ../libmultipath/libmultipath.<wbr>so: undefined reference to<=
br>
=C2=A0 =C2=A0 `rcu_register_thread_mb&#39;<br>
=C2=A0 =C2=A0 ../libmultipath/libmultipath.<wbr>so: undefined reference to<=
br>
=C2=A0 =C2=A0 `rcu_unregister_thread_mb&#39;<br>
<br>
Fix:<br>
=C2=A0 =C2=A0 Link the libmultipath with -lurcu<br>
<br>
Signed-off-by: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com=
</a>&gt;<br>
---<br>
=C2=A0libmultipath/Makefile | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/Makefile b/libmultipath/Makefile<br>
index b5d54d8..1f5ec25 100644<br>
--- a/libmultipath/Makefile<br>
+++ b/libmultipath/Makefile<br>
@@ -9,7 +9,7 @@ LIBS =3D $(DEVLIB).$(SONAME)<br>
<br>
=C2=A0CFLAGS +=3D -I$(mpathcmddir)<br>
<br>
-LIBDEPS +=3D -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd=
<br>
+LIBDEPS +=3D -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd=
 -lurcu<br>
<br>
=C2=A0ifdef SYSTEMD<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DUSE_SYSTEMD=3D$(SYSTEMD)<br>
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

--001a1142efbeaad78a05482b78e7--


--===============5009319534316610650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5009319534316610650==--
