From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fail path when path check timeout
Date: Tue, 11 Oct 2016 08:55:50 +0200
Message-ID: <CABr-GndRb18LnumK2O3GuUdjHNHqsYYL0KZWTdgjhA4Xyz_YSw@mail.gmail.com>
References: <1470816638-6404-1-git-send-email-tang.junhui@zte.com.cn>
	<OF8F7422C1.AAA99072-ON48258049.002567ED-48258049.00258956@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2763577733392020437=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF8F7422C1.AAA99072-ON48258049.002567ED-48258049.00258956@zte.com.cn>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

--===============2763577733392020437==
Content-Type: multipart/alternative; boundary=94eb2c1a0a0af9deb2053e915dfc

--94eb2c1a0a0af9deb2053e915dfc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Merged.
Thanks.

On Tue, Oct 11, 2016 at 8:50 AM, <tang.junhui@zte.com.cn> wrote:

> Please have a review for this patch, any comment will be highly
> appreciated.
>
>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA:         tang.junhui@zte.com.cn
> =E6=94=B6=E4=BB=B6=E4=BA=BA:         christophe varoqui <christophe.varoq=
ui@free.fr>,
> =E6=8A=84=E9=80=81:        dm-devel@redhat.com, zhang.kai16@zte.com.cn, "=
tang.junhui" <
> tang.junhui@zte.com.cn>
> =E6=97=A5=E6=9C=9F:         2016/08/10 16:11
> =E4=B8=BB=E9=A2=98:        [PATCH] multipathd: fail path when path check =
timeout
> ------------------------------
>
>
>
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> path should be failed when path status is PATH_TIMEOUT after check,
> otherwise, the valid number of paths in the map would be increased when
> the path status is PATH_UP after the next turn check, which would cause
> the valid number of paths exceeding the total number of paths in the map.
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
> multipathd/main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f5e9a01..01f1e58 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1585,7 +1585,7 @@ check_path (struct vectors * vecs, struct path * pp=
,
> int ticks)
>                                   pp->checkint =3D conf->checkint;
>                                   put_multipath_config(conf);
>
> -                                  if (newstate =3D=3D PATH_DOWN || newst=
ate
> =3D=3D PATH_SHAKY) {
> +                                  if (newstate =3D=3D PATH_DOWN || newst=
ate
> =3D=3D PATH_SHAKY || newstate =3D=3D PATH_TIMEOUT) {
>                                                    /*
>                                                     * proactively fail
> path in the DM
>                                                     */
> --
> 2.8.1.windows.1
>
>
>

--94eb2c1a0a0af9deb2053e915dfc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Oct 11, 2016 at 8:50 AM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:tang.junhui@zte.com.cn" target=3D"_blank">ta=
ng.junhui@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><font size=3D"2">Please have a review</font><font size=3D"2" face=3D"sans=
-serif">
for this patch, any comment will be highly appreciated.</font><font size=3D=
"2" face=3D"sans-serif"><br>
</font>
<br>
<br>
<br>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E5=8F=91=E4=BB=
=B6=E4=BA=BA: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto=
:tang.junhui@zte.com.cn" target=3D"_blank">tang.junhui@zte.com.cn</a></font=
>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=94=B6=E4=BB=
=B6=E4=BA=BA: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif">christophe
varoqui &lt;<a href=3D"mailto:christophe.varoqui@free.fr" target=3D"_blank"=
>christophe.varoqui@free.fr</a>&gt;, </font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=8A=84=E9=80=
=81: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto:=
dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a>,
<a href=3D"mailto:zhang.kai16@zte.com.cn" target=3D"_blank">zhang.kai16@zte=
.com.cn</a>, &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.=
com.cn" target=3D"_blank">tang.junhui@zte.com.cn</a>&gt;</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=97=A5=E6=9C=
=9F: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif">2016/08/10
16:11</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E4=B8=BB=E9=A2=
=98: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif">[PATCH] multipathd=
:
fail path when path check timeout</font>
<br>
<hr noshade><div class=3D"HOEnZb"><div class=3D"h5">
<br>
<br>
<br><tt><font size=3D"2">From: &quot;tang.junhui&quot; &lt;<a href=3D"mailt=
o:tang.junhui@zte.com.cn" target=3D"_blank">tang.junhui@zte.com.cn</a>&gt;<=
br>
<br>
path should be failed when path status is PATH_TIMEOUT after check,<br>
otherwise, the valid number of paths in the map would be increased when<br>
the path status is PATH_UP after the next turn check, which would cause<br>
the valid number of paths exceeding the total number of paths in the map.<b=
r>
<br>
Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.cn" ta=
rget=3D"_blank">tang.junhui@zte.com.cn</a>&gt;<br>
---<br>
 multipathd/main.c | 2 +-<br>
 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index f5e9a01..01f1e58 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1585,7 +1585,7 @@ check_path (struct vectors * vecs, struct path *
pp, int ticks)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
pp-&gt;checkint =3D conf-&gt;checkint;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
put_multipath_config(conf);<br>
 <br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if
(newstate =3D=3D PATH_DOWN || newstate =3D=3D PATH_SHAKY) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if
(newstate =3D=3D PATH_DOWN || newstate =3D=3D PATH_SHAKY || newstate =3D=3D=
 PATH_TIMEOUT)
{<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
* proactively fail path in the DM<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
*/<br>
-- <br>
2.8.1.windows.1<br>
<br>
</font></tt>
<br>
</div></div></blockquote></div><br></div>

--94eb2c1a0a0af9deb2053e915dfc--


--===============2763577733392020437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2763577733392020437==--
