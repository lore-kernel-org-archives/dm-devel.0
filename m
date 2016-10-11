From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] mpathpersist: memset length is wrong
Date: Tue, 11 Oct 2016 08:41:20 +0200
Message-ID: <CABr-GnfT5f+zMmR3HivH7OC_dq5Cbdg+eqRrMdoL2=YnUh_nsw@mail.gmail.com>
References: <1474447486-8892-1-git-send-email-tang.junhui@zte.com.cn>
	<OF9BE89F56.9D2DAD11-ON48258049.00234303-48258049.002461FF@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1020458832872621179=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF9BE89F56.9D2DAD11-ON48258049.00234303-48258049.002461FF@zte.com.cn>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Vijay.Chauhan@netapp.com, device-mapper development <dm-devel@redhat.com>, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

--===============1020458832872621179==
Content-Type: multipart/alternative; boundary=001a1142bfc618f7d0053e912a3e

--001a1142bfc618f7d0053e912a3e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Seems right.
Merged, with thanks.

On Tue, Oct 11, 2016 at 8:37 AM, <tang.junhui@zte.com.cn> wrote:

> Please have a review for this patch, any comment will be highly
> appreciated.
>
>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA:         tang.junhui@zte.com.cn
> =E6=94=B6=E4=BB=B6=E4=BA=BA:         christophe varoqui <christophe.varoq=
ui@free.fr>,
> Chauhan@redhat.com, Vijay <Vijay.Chauhan@netapp.com>, Benjamin Marzinski =
<
> bmarzins@redhat.com>,
> =E6=8A=84=E9=80=81:        zhang.kai16@zte.com.cn, dm-devel@redhat.com, "=
tang.junhui" <
> tang.junhui@zte.com.cn>
> =E6=97=A5=E6=9C=9F:         2016/09/21 16:54
> =E4=B8=BB=E9=A2=98:        [dm-devel] [PATCH] mpathpersist: memset length=
 is wrong
> =E5=8F=91=E4=BB=B6=E4=BA=BA:        dm-devel-bounces@redhat.com
> ------------------------------
>
>
>
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> variable transportids is cleared by memset() with wrong length
> MPATH_MX_TIDS,
> the length should be MPATH_MX_TIDS*sizeof(struct transportid).
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
> mpathpersist/main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index a55865f..8e8cc35 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -105,7 +105,7 @@ int main (int argc, char * argv[])
>
>                  udev =3D udev_new();
>                  conf =3D mpath_lib_init(udev);
> -                 memset(transportids,0,MPATH_MX_TIDS);
> +                 memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct
> transportid));
>                  multipath_conf =3D conf;
>
>                  while (1)
> --
> 2.8.1.windows.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>

--001a1142bfc618f7d0053e912a3e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Seems right.<div>Merged, with thanks.</div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Oct 11, 2016 at 8:=
37 AM,  <span dir=3D"ltr">&lt;<a href=3D"mailto:tang.junhui@zte.com.cn" tar=
get=3D"_blank">tang.junhui@zte.com.cn</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><font size=3D"2">Please have a review</font><font size=
=3D"2" face=3D"sans-serif">
for this patch, any comment will be highly appreciated.<br>
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
>christophe.varoqui@free.fr</a>&gt;, <a href=3D"mailto:Chauhan@redhat.com" =
target=3D"_blank">Chauhan@redhat.com</a>, Vijay &lt;<a href=3D"mailto:Vijay=
.Chauhan@netapp.com" target=3D"_blank">Vijay.Chauhan@netapp.com</a>&gt;,
Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_bl=
ank">bmarzins@redhat.com</a>&gt;, </font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=8A=84=E9=80=
=81: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto:=
zhang.kai16@zte.com.cn" target=3D"_blank">zhang.kai16@zte.com.cn</a>,
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a>, &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.com.cn=
" target=3D"_blank">tang.junhui@zte.com.cn</a>&gt;</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=97=A5=E6=9C=
=9F: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif">2016/09/21
16:54</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E4=B8=BB=E9=A2=
=98: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif">[dm-devel] [PATCH]
mpathpersist: memset length is wrong</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E5=8F=91=E4=BB=
=B6=E4=BA=BA: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto:=
dm-devel-bounces@redhat.com" target=3D"_blank">dm-devel-bounces@redhat.com<=
/a></font>
<br>
<hr noshade><div class=3D"HOEnZb"><div class=3D"h5">
<br>
<br>
<br><tt><font size=3D"2">From: &quot;tang.junhui&quot; &lt;<a href=3D"mailt=
o:tang.junhui@zte.com.cn" target=3D"_blank">tang.junhui@zte.com.cn</a>&gt;<=
br>
<br>
variable transportids is cleared by memset() with wrong length MPATH_MX_TID=
S,<br>
the length should be MPATH_MX_TIDS*sizeof(struct transportid).<br>
<br>
Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.cn" ta=
rget=3D"_blank">tang.junhui@zte.com.cn</a>&gt;<br>
---<br>
 mpathpersist/main.c | 2 +-<br>
 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/mpathpersist/main.c b/mpathpersist/main.c<br>
index a55865f..8e8cc35 100644<br>
--- a/mpathpersist/main.c<br>
+++ b/mpathpersist/main.c<br>
@@ -105,7 +105,7 @@ int main (int argc, char * argv[])<br>
 <br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev
=3D udev_new();<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf
=3D mpath_lib_init(udev);<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
memset(transportids,0,MPATH_<wbr>MX_TIDS);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0multipath_co=
nf
=3D conf;<br>
 <br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while
(1)<br>
-- <br>
2.8.1.windows.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
</font></tt><a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" ta=
rget=3D"_blank"><tt><font size=3D"2">https://www.redhat.com/<wbr>mailman/li=
stinfo/dm-devel</font></tt></a><tt><font size=3D"2"><br>
</font></tt>
<br>
</div></div></blockquote></div><br></div>

--001a1142bfc618f7d0053e912a3e--


--===============1020458832872621179==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1020458832872621179==--
