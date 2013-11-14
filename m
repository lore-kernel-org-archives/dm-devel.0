From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath/discovery.c: Fix a condition
 that will lead to a table reload during every check.
Date: Thu, 14 Nov 2013 22:09:24 +0100
Message-ID: <CABr-Gnd0d1fKza=CZi9YKpMZnhg-nREgQkoCskYZNYUxb4dhhg@mail.gmail.com>
References: <1384387594-32594-1-git-send-email-sean.stewart@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8027626109233957209=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384387594-32594-1-git-send-email-sean.stewart@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sean Stewart <sean.stewart@netapp.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8027626109233957209==
Content-Type: multipart/alternative; boundary=047d7bdca50412493b04eb297f57

--047d7bdca50412493b04eb297f57
Content-Type: text/plain; charset=ISO-8859-1

Applied.
Thanks.

Christophe Varoqui
www.opensvc.com



On Thu, Nov 14, 2013 at 1:06 AM, Sean Stewart <sean.stewart@netapp.com>wrote:

> If path_offline says PATH_UP and the checker says PATH_DOWN.  In
> this case, pathinfo gets called twice, and the first call, from
> update_prio sets it to -1 because the checker says it's down.  On the
> second pathinfo call, from update_path_groups, it will call the
> prioritizer based on the fact that the prio is -1. This leads to a flip
> flop of the priority value and a reload on every check.
>
> Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
> ---
>  libmultipath/discovery.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 7035a43..04e3ead 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1138,8 +1138,6 @@ pathinfo (struct path *pp, vector hwtable, int mask)
>                         if (!strlen(pp->wwid))
>                                 get_uid(pp);
>                         get_prio(pp);
> -               } else {
> -                       pp->priority = PRIO_UNDEF;
>                 }
>         }
>
> --
> 1.8.3.1
>
>

--047d7bdca50412493b04eb297f57
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div style>Thanks.</div><div style><br></div><div =
style>Christophe Varoqui</div><div style><a href=3D"http://www.opensvc.com"=
>www.opensvc.com</a></div><div style><br></div><div class=3D"gmail_extra"><=
br>
<br><div class=3D"gmail_quote">On Thu, Nov 14, 2013 at 1:06 AM, Sean Stewar=
t <span dir=3D"ltr">&lt;<a href=3D"mailto:sean.stewart@netapp.com" target=
=3D"_blank">sean.stewart@netapp.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">
If path_offline says PATH_UP and the checker says PATH_DOWN. =A0In<br>
this case, pathinfo gets called twice, and the first call, from<br>
update_prio sets it to -1 because the checker says it&#39;s down. =A0On the=
<br>
second pathinfo call, from update_path_groups, it will call the<br>
prioritizer based on the fact that the prio is -1. This leads to a flip<br>
flop of the priority value and a reload on every check.<br>
<br>
Signed-off-by: Sean Stewart &lt;<a href=3D"mailto:sean.stewart@netapp.com">=
sean.stewart@netapp.com</a>&gt;<br>
---<br>
=A0libmultipath/discovery.c | 2 --<br>
=A01 file changed, 2 deletions(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index 7035a43..04e3ead 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -1138,8 +1138,6 @@ pathinfo (struct path *pp, vector hwtable, int mask)<=
br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strlen(pp-&gt;wwid))<b=
r>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_uid(pp)=
;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_prio(pp);<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pp-&gt;priority =3D PRIO_UNDE=
F;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
=A0 =A0 =A0 =A0 }<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div></div>

--047d7bdca50412493b04eb297f57--


--===============8027626109233957209==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8027626109233957209==--
