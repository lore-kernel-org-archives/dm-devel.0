From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath/main.c fix a minor typo
Date: Fri, 8 Jul 2016 08:12:53 +0200
Message-ID: <CABr-GncmwHYxuBAXc2H4hZ1S4md3x-CY0y0t6hwOKOH9iFS0eA@mail.gmail.com>
References: <1911e0e1-006d-1946-e157-afa8b9a5b4df@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4180978497009797782=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1911e0e1-006d-1946-e157-afa8b9a5b4df@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mgandhi@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4180978497009797782==
Content-Type: multipart/alternative; boundary=001a114012607179ef053719b1c8

--001a114012607179ef053719b1c8
Content-Type: text/plain; charset=UTF-8

Rebased and merged.
Thanks.

On Fri, Jul 1, 2016 at 1:17 PM, Milan P. Gandhi <mgandhi@redhat.com> wrote:

> Hello, Below patch fixes a minor typo in multipath/main.c
>
> Thanks,
> Milan.
>
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
>
> diff --git a/multipath/main.c b/multipath/main.c
> index aadebec..7d23521 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -288,7 +288,7 @@ configure (void)
>                         if (failed == 2 && conf->cmd == CMD_VALID_PATH)
>                                 printf("%s is not a valid multipath device
> path\n", conf->dev);
>                         else
> -                               condlog(3, "scope is nul");
> +                               condlog(3, "scope is null");
>                         goto out;
>                 }
>                 if (conf->cmd == CMD_REMOVE_WWID) {
> @@ -360,7 +360,7 @@ configure (void)
>
>
>         if (conf->cmd == CMD_VALID_PATH) {
> -               /* This only happens if find_multipaths is and
> +               /* This only happens if find_multipaths and
>                  * ignore_wwids is set.
>                  * If there is currently a multipath device matching
>                  * the refwwid, or there is more than one path matching
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114012607179ef053719b1c8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Rebased and merged.<div>Thanks.</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Fri, Jul 1, 2016 at 1:17 PM, =
Milan P. Gandhi <span dir=3D"ltr">&lt;<a href=3D"mailto:mgandhi@redhat.com"=
 target=3D"_blank">mgandhi@redhat.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">Hello, Below patch fixes a minor typo in multipath/main.=
c<br>
<br>
Thanks,<br>
Milan.<br>
<br>
Signed-off-by: Milan P. Gandhi &lt;<a href=3D"mailto:mgandhi@redhat.com">mg=
andhi@redhat.com</a>&gt;<br>
---<br>
<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index aadebec..7d23521 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -288,7 +288,7 @@ configure (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (failed =3D=3D 2 &amp;&amp; conf-&gt;cmd =3D=3D CMD_VALID_PAT=
H)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s is not a valid multi=
path device path\n&quot;, conf-&gt;dev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 else<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;scope is nul&quot;);=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;scope is null&quot;)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;cmd =
=3D=3D CMD_REMOVE_WWID) {<br>
@@ -360,7 +360,7 @@ configure (void)<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;cmd =3D=3D CMD_VALID_PATH) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* This only happen=
s if find_multipaths is and<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* This only happen=
s if find_multipaths and<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* ignore_wwid=
s is set.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If there is=
 currently a multipath device matching<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the refwwid=
, or there is more than one path matching<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div><br></div>

--001a114012607179ef053719b1c8--


--===============4180978497009797782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4180978497009797782==--
